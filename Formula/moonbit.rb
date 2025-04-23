class Moonbit < Formula
  desc 'An end-to-end programming language toolchain for cloud and edge computing using WebAssembly'
  homepage 'https://www.moonbitlang.com'
  version 'latest'
  os = OS.mac? ? 'darwin' : 'linux'
  arch = Hardware::CPU.arm? ? 'aarch64' : 'x86_64'
  url "https://cli.moonbitlang.com/binaries/#{version}/moonbit-#{os}-#{arch}.tar.gz"

  # stree-ignore
  sha256 Hardware::CPU.arm? ?
    if OS.mac?
      'c13aaf9dc4d332266c80011c583a885466d87adfdcf90560bb8ed268741342d1'
    else
      :no_check
    end :
    if OS.mac?
      '080a65f561acafaf2e65968e42fb89e9c3eb565c0b376e4d9e444f86fd30d394'
    else
      'a22a658e9ee375f70c3aaa337d6228419f5797adb5f5a9b40600b28af9b5fe92'
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
  end
end
