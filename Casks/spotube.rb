cask 'spotube' do
  version '3.4.0'
  sha256 '7627f679cdfb40bf4554f1a0aaabed076cd15fa3f7342b61e45167a40491fc0b'

  url "https://github.com/KRTirtho/spotube/releases/download/v#{version}/Spotube-macos-universal.dmg",
      verified: 'github.com/KRTirtho/spotube/releases/download/'
  name 'spotube'
  desc 'Open source Spotify client'
  homepage 'https://spotube.krtirtho.dev/'

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: '>= :mojave'

  app 'spotube.app'

  caveats { unsigned_accessibility }
end
