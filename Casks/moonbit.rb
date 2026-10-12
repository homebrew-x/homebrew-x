require 'download_strategy'
require 'rubygems/package'
require 'zlib'

cask 'moonbit' do
  os macos: 'darwin', linux: 'linux'

  version '0.10.15+943464bfa,96d30f4dbcc6a9e1736ef26fbdd0e8fb0e97cb01d50e55d2a0072208b8061ae5'
  sha256 arm:
           '563109ff02c6dc77fdc74acd0be423964ef678dfea4d9b948c19d245dc8b0e83',
         arm64_linux:
           '27551288b9552db1426d186403645bb40308a3f5e525054d0a2860283ae118bf',
         x86_64_linux:
           '24b93a5409d2a4fb8e3d1b84b473f27b63476cef4418094764df96cb26b03c09'

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
