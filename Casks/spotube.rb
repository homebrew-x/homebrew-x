cask 'spotube' do
  version '3.4.1'
  sha256 '5686cb0b1b261399062250c36b7bf9c481e4c36c76615d787e01c77036fe6cba'

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
