require 'download_strategy'
require 'rubygems/package'
require 'zlib'

cask 'moonbit' do
  os macos: 'darwin', linux: 'linux'

  version '0.10.13+cbb11c36f,d36b64c42df3019d9da87291e40738e90623c0380d0e200a62156091fb00c176'

  on_macos do
    arch arm: 'aarch64'

    sha256 '8f33fbbdca7af16034cce40af12661a0aa50d92afa32abadac9a1964dcd57766'

    depends_on arch: :arm64
  end
  on_linux do
    arch arm: 'aarch64', intel: 'x86_64'

    sha256 arm64_linux:
             '04e8b74192a57f4f9e9c3a4537d1e1a79016779bd52d6631d895420723bdd9ff',
           x86_64_linux:
             'ef643f267d5ee075dbafd54b44b0a26c55116340515dca07294c2a0b83479a8b'
  end

  url "https://cli.moonbitlang.com/binaries/#{version.csv.first.gsub('+', '%2B')}/moonbit-#{os}-#{arch}.tar.gz"
  name 'MoonBit'
  desc 'End-to-end programming language toolchain for cloud and edge computing using WebAssembly'
  homepage 'https://www.moonbitlang.com/'

  livecheck do
    url 'https://cli.moonbitlang.com/cores/core-latest.tar.gz'
    strategy :header_match do |headers|
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
  # bundled with the toolchain, which is not expressible as a cask resource.
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
