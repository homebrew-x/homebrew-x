require 'cask/quarantine'
require 'download_strategy'
require 'rubygems/package'
require 'unpack_strategy'
require 'zlib'

cask 'moonbit' do
  os macos: 'darwin', linux: 'linux'

  version '0.10.8+8606a5800,858a4d2d505bfd2db43176a76f3f02457d5cf080e35231bfb9c78e33e9c6719d'

  on_macos do
    arch arm: 'aarch64'

    sha256 'd9527dbb7e955b55888ffa45cc89740b9139dff6e0dc02edf4b9b66a9d5e513b'

    depends_on arch: :arm64
  end
  on_linux do
    arch arm: 'aarch64', intel: 'x86_64'

    sha256 arm:
             'be3bf32705e73ab456f7cf8f267aed7ddf353dcd86b03ba53da6e340d6562049',
           intel:
             'ac66bf5c04c00bb8e1512d2bfc2cc9801d24a60429302bab48320a5d68ca20a2'
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

  postflight do
    core_download =
      CurlDownloadStrategy.new(
        "https://cli.moonbitlang.com/cores/core-#{version.csv.first.gsub('+', '%2B')}.tar.gz",
        'moonbit-core',
        version.csv.first,
      )

    set_permissions Dir[staged_path / 'bin/*'], '+x'
    set_permissions staged_path / 'bin/internal/tcc', '+x'
    if OS.mac?
      Pathname
        .glob(staged_path / '**/*', File::FNM_DOTMATCH)
        .reject(&:symlink?)
        .each { |path| Object::Cask::Quarantine.release!(download_path: path) }
    end

    core_download.fetch
    if Digest::SHA256.file(core_download.cached_location).hexdigest !=
         version.csv.second
      raise 'MoonBit core checksum mismatch'
    end

    core_path = staged_path / 'lib/core'
    Utils.gain_permissions_remove(core_path) if core_path.directory?
    UnpackStrategy.detect(core_download.cached_location).extract_nestedly(
      to: staged_path / 'lib',
    )

    system_command staged_path / 'bin/moon',
                   args: [
                     '-C',
                     staged_path / 'lib/core',
                     'bundle',
                     '--warn-list',
                     '-a',
                     '--all',
                   ]
  end
end
