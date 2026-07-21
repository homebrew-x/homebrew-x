require 'cask/quarantine'
require 'download_strategy'
require 'rubygems/package'
require 'unpack_strategy'
require 'zlib'

cask 'moonbit' do
  os macos: 'darwin', linux: 'linux'

  on_macos do
    arch arm: 'aarch64'

    sha256 '9f949682cfbf438b7aa9ca93d44fe462dd6c522d89b0b9bd39f87dabf8d86551'

    depends_on arch: :arm64
  end
  on_linux do
    arch arm: 'aarch64', intel: 'x86_64'

    sha256 arm:
             '7f0e0bcb3a1b3d629a0d5ffdb1ab6d6d0ce3b3619775127ec0b86bff876d568e',
           intel:
             '3c5017f569284802f1a0b8422d149963a01ca587c514451164aef91c65df8aa8'
  end

  version '0.10.4+2cc641edf,03ad55b99f3e431f3cb81b4e2bb28bb98173304e4a1b18a891ea027cabba5d1c'

  url "https://cli.moonbitlang.com/binaries/#{version.csv.first.gsub('+', '%2B')}/moonbit-#{os}-#{arch}.tar.gz"
  name 'MoonBit'
  desc 'An end-to-end programming language toolchain for cloud and edge computing using WebAssembly'
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
  binary 'bin/moonbit-lsp'
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
