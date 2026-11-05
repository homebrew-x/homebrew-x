require 'download_strategy'
require 'rubygems/package'
require 'zlib'

cask 'moonbit' do
  os macos: 'darwin', linux: 'linux'

  version '0.10.20+65efd5b93,8ec2a2c01335501d703867bb4eef5f92d3cd7e1ae1ee5f7f14d54d16d2c7c2b5'
  sha256 arm:
           '3ccd56479ba704a779178abe8731490edee9e57b3b90f5cef2252afef4fdf130',
         arm64_linux:
           '8eaf1e2bd633bc6ab480d86ebeeef2d40248b7c8b5317dc287d77ad01f165727',
         x86_64_linux:
           '80d987523308fa490eba9f1baf98df996a5a7891e118357553b7c2608c0597c5'

  on_macos do
    arch arm: 'aarch64'

    depends_on arch: :arm64
  end
  on_linux { arch arm: 'aarch64', intel: 'x86_64' }

  url "https://cli.moonbitlang.com/binaries/#{version.csv.first.gsub('+', '%2B')}/moonbit-#{os}-#{arch}.tar.gz"
  name 'MoonBit'
  desc 'End-to-end programming language toolchain for cloud and edge computing using WebAssembly'
  homepage 'https://www.moonbitlang.com/'

  livecheck do
    url 'https://cli.moonbitlang.com/cores/core-latest.tar.gz'
    strategy :header_match do |headers|
      _ = headers # To appease `brew style` without modifying arg name
      core_download = CurlDownloadStrategy.new(url, 'moonbit-core', 'latest')
      core_download.quiet!
      core_download.fetch

      core_mod =
        Zlib::GzipReader.open(core_download.cached_location) do |gzip|
          Gem::Package::TarReader
            .new(gzip)
            .find { |entry| entry.full_name == './core/moon.mod' }
            &.read
        end
      core_version = core_mod&.[](/^version\s*=\s*"([^"]+)"/, 1)
      next if core_version.blank?

      "#{core_version},#{Digest::SHA256.file(core_download.cached_location).hexdigest}"
    end
  end

  binary 'bin/moon'
  binary 'bin/moon-cram'
  binary 'bin/moon-ide'
  binary 'bin/moon-lsp'
  binary 'bin/moon-wasm-opt'
  binary 'bin/moon_cove_report'
  binary 'bin/moonc'
  binary 'bin/mooncake'
  binary 'bin/moondoc'
  binary 'bin/moonfmt'
  binary 'bin/mooninfo'
  binary 'bin/moonrun'

  core_url =
    "https://cli.moonbitlang.com/cores/core-#{version.csv.first.gsub('+', '%2B')}.tar.gz"
  core_sha256 = version.csv.second

  # The standard library is a second download that has to be verified and
  # bundled with the toolchain; casks have no `resource` for it.
  postflight_steps do
    set_permissions 'bin/*', '+x'

    on_macos do
      run 'xattr',
          args: %w[-dr com.apple.quarantine {{staged_path}}],
          must_succeed: false,
          print_stderr: false
    end

    run 'curl',
        args: [
          '--fail',
          '--show-error',
          '--silent',
          '--location',
          '--output',
          '{{staged_path}}/core.tar.gz',
          core_url,
        ],
        network_access: true

    write_file 'core.sha256',
               "#{core_sha256}  {{staged_path}}/core.tar.gz",
               append_newline: true

    on_macos { run 'shasum', args: %w[-a 256 -c {{staged_path}}/core.sha256] }
    on_linux { run 'sha256sum', args: %w[-c {{staged_path}}/core.sha256] }

    remove 'lib/core', recursive: true
    run 'tar', args: %w[-xzf {{staged_path}}/core.tar.gz -C {{staged_path}}/lib]
    run '{{staged_path}}/bin/moon',
        args: %w[-C {{staged_path}}/lib/core bundle --warn-list -a --all]

    remove %w[core.tar.gz core.sha256]
  end
end
