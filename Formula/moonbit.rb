require 'mktemp'
require 'utils/curl'
require 'unpack_strategy'

class Moonbit < Formula
  desc 'An end-to-end programming language toolchain for cloud and edge computing using WebAssembly'
  homepage 'https://www.moonbitlang.com'
  license 'MIT'
  version '0.1.20250429+d96028625'

  os = OS.mac? ? 'darwin' : 'linux'
  arch = Hardware::CPU.arm? ? 'aarch64' : 'x86_64'
  url "https://cli.moonbitlang.com/binaries/#{version.to_s.gsub('+', '%2B')}/moonbit-#{os}-#{arch}.tar.gz"

  private def core_url =
    "https://cli.moonbitlang.com/cores/core-#{version.to_s.gsub('+', '%2B')}.tar.gz"

  # stree-ignore
  sha256 Hardware::CPU.arm? ?
    if OS.mac?
      '95f91c49c36ab5fd659b898ab3b174a6bdd78f25930fecb73551c44a6cc74afe'
    else
      '' # not available for linux arm64
    end :
    if OS.mac?
      '95f91c49c36ab5fd659b898ab3b174a6bdd78f25930fecb73551c44a6cc74afe'
    else
      '9c7b55965cedadfea476432aa557877a10c7a3c7c4760868d733a50efda01ca2'
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
