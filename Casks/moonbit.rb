require 'download_strategy'
require 'rubygems/package'
require 'zlib'

cask 'moonbit' do
  os macos: 'darwin', linux: 'linux'

  version '0.10.14+7d59c7ec9,6f18b8fdea18f85e628a75e4a1bd3977c5a5c9c6a836fd8824192b0e6bd91b14'
  sha256 arm:
           '20967f9389ac54508899ee2fc051a3470d051452bac5818a9696ed4c144f3ec3',
         arm64_linux:
           '6443fd47b39e10ee25bdfa0250921e13a3a68649c02837aa382512b7d187c790',
         x86_64_linux:
           '9226694de9ff978db1ecf820b7710c4224e84ec7a76b19a222d96f0cd4e31b6a'

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
