cask 'spotube' do
  version '4.0.2'
  sha256 'd1e35e3290bcbac3df6ee8766a3e379fa28bcac450e79c8b74e4fb6797da54b5'

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

  app 'Spotube.app'

  caveats { unsigned_accessibility }
end
