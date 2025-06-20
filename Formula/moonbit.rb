require 'mktemp'
require 'utils/curl'
require 'unpack_strategy'

class Moonbit < Formula
  desc 'An end-to-end programming language toolchain for cloud and edge computing using WebAssembly'
  homepage 'https://www.moonbitlang.com'
  license 'MIT'
  version '0.6.18+2d6615047'

  os = OS.mac? ? 'darwin' : 'linux'
  arch = Hardware::CPU.arm? ? 'aarch64' : 'x86_64'
  url "https://cli.moonbitlang.com/binaries/#{version.to_s.gsub('+', '%2B')}/moonbit-#{os}-#{arch}.tar.gz"

  private def core_url =
    "https://cli.moonbitlang.com/cores/core-#{version.to_s.gsub('+', '%2B')}.tar.gz"

  # stree-ignore
  sha256 OS.mac? ?
    if Hardware::CPU.arm?
      '9ae1a63c6085737b1adbcb4b72c7c7c78ac3ab3ea6ebde964ba2b09dfbe1ac8e'
    else
      '05cfbd1a459da10eeeaf097dce6e3686e7b97d9eac2c369c38abf7e5926301f3'
    end :
    if Hardware::CPU.arm?
      '' # not available for linux arm64
    else
      '7b0aa4e3989030521c79f1b10d24db441861804468f5953270e4242bc5a91594'
    end

  def install
    bin.install %w[
                  bin/moon
                  bin/moon_cove_report
                  bin/moonc
                  bin/mooncake
                  bin/moondoc
                  bin/moonfmt
                  bin/mooninfo
                  bin/moonrun
                ]

    # FIXME: not sure what's the cause
    # generate_completions_from_executable(bin/"moon", "shell-completion", "--shell")

    core_url_sha256 = Digest::SHA256.hexdigest(core_url)

    puts "Downloading moonbit core from #{core_url}"

    # stree-ignore
    temporary_path = HOMEBREW_CACHE/"downloads/#{core_url_sha256}--#{Utils.safe_filename(File.basename(core_url))}"

    Utils::Curl.curl_download("#{core_url}", to: temporary_path)

    Mktemp
      .new('homebrew-unpack')
      .run(chdir: false) do |unpack_dir|
        tmp_unpack_dir = T.must(unpack_dir.tmpdir)

        puts "Unpacking moonbit lib core to #{tmp_unpack_dir}"

        UnpackStrategy.detect(temporary_path).extract_nestedly(
          to: tmp_unpack_dir,
        )

        user_home_dir = Etc.getpwuid(Process.uid)&.dir

        core_lib_dir = "#{user_home_dir}/.moon/lib/core"

        puts "Moving moonbit lib core to #{core_lib_dir}"

        FileUtils.mv tmp_unpack_dir, core_lib_dir, force: true
      end
  end
end
