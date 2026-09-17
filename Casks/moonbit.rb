require 'cask/quarantine'
require 'download_strategy'
require 'rubygems/package'
require 'unpack_strategy'
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
