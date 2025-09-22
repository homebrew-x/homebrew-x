require 'mktemp'
require 'utils/curl'
require 'unpack_strategy'

class Moonbit < Formula
  desc 'An end-to-end programming language toolchain for cloud and edge computing using WebAssembly'
  homepage 'https://www.moonbitlang.com'
  license 'MIT'
  version '0.6.28+d96d14d39'

  os_arch = OS.mac? ? 'darwin-aarch64' : 'linux-x86_64'
  url "https://cli.moonbitlang.com/binaries/#{version.to_s.gsub('+', '%2B')}/moonbit-#{os_arch}.tar.gz"

  private def core_url =
    "https://cli.moonbitlang.com/cores/core-#{version.to_s.gsub('+', '%2B')}.tar.gz"

  sha256(
    if OS.mac?
      '2580b532a52ca966a9fc39ec8753e9bb4738a1a2d49af823e4a99979b6f6e3b1'
    else
      '14158aaa2c8f39f039809ad866e66cb8a3084814828d45f3aef57d03d1636bd5'
    end,
  )

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
