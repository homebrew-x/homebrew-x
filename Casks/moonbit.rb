require 'cask/quarantine'
require 'download_strategy'
require 'rubygems/package'
require 'unpack_strategy'
require 'zlib'

cask 'moonbit' do
  os macos: 'darwin', linux: 'linux'

  version '0.10.7+bc794d341,06922d35dd94dc0baea7682295fe6084f0d854eed3b497cd6b527f77d899a7f5'

  on_macos do
    arch arm: 'aarch64'

    sha256 'b4781a1e38c800d1fd65693b1970b2d2429faef31d8933d266a1f6e2693a96ef'

    depends_on arch: :arm64
  end
  on_linux do
    arch arm: 'aarch64', intel: 'x86_64'

    sha256 arm:
             '400d271de568d50c921b07c1d3be71723440e9ece898240e57a75de6ebf4c80a',
           intel:
             '36f5e7cf1545594e17cd3f1c0b757fe6e86ad0218bc96f419369cbb8502e62ba'
  end

  url "https://cli.moonbitlang.com/binaries/#{version.csv.first.gsub('+', '%2B')}/moonbit-#{os}-#{arch}.tar.gz"
  name 'MoonBit'
  desc 'End-to-end programming language toolchain for cloud and edge computing using WebAssembly'
  homepage 'https://www.moonbitlang.com/'

  livecheck do
    url 'https://cli.moonbitlang.com/cores/core-latest.tar.gz'
    strategy :header_match do |_headers|
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
