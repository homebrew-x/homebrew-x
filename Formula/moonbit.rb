require 'mktemp'
require 'utils/curl'
require 'unpack_strategy'

class Moonbit < Formula
  desc 'An end-to-end programming language toolchain for cloud and edge computing using WebAssembly'
  homepage 'https://www.moonbitlang.com'
  license 'MIT'
  version '0.6.23+906028000'

  os = OS.mac? ? 'darwin' : 'linux'
  arch = Hardware::CPU.arm? ? 'aarch64' : 'x86_64'
  url "https://cli.moonbitlang.com/binaries/#{version.to_s.gsub('+', '%2B')}/moonbit-#{os}-#{arch}.tar.gz"

  private def core_url =
    "https://cli.moonbitlang.com/cores/core-#{version.to_s.gsub('+', '%2B')}.tar.gz"

  # stree-ignore
  sha256 OS.mac? ?
    if Hardware::CPU.arm?
      'f5c2200cece11d22fbb8a8fb7f5683d4db550328bf1d66d5d54e1086aeb20fea'
    else
      '616d247691f62346e8938380dea198f2234c18a17a9da74d3386bac2ae8231f9'
    end :
    if Hardware::CPU.arm?
      '' # unavailable for linux arm64
    else
      '4eb1605418592f9b4c370bd724edc7e131fc6c249bed056e2588fe28d5831149'
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
