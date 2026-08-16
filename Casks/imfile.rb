cask 'imfile' do
  arch arm: '-arm64'

  version '2.3.4'
  sha256 arm:
           '7d3259be8a22887915b495c58adb48287cfb3b07dfc5e607339fcd29715dbec5',
         intel:
           'ff3731599e4f70387852d548f7192daa708ca3789f82e0bfa8d33a6c846e355e'

  url "https://github.com/imfile-io/imfile-desktop/releases/download/v#{version}/imFile-#{version}#{arch}.dmg",
      verified: 'github.com/imfile-io/imfile-desktop/'
  name 'imFile'
  desc 'Open-source download manager'
  homepage 'https://imfile.org/'

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :monterey

  app 'imFile.app'

  zap trash: [
        '~/Library/Application Support/imFile',
        '~/Library/Caches/io.imFile',
        '~/Library/Logs/imFile',
        '~/Library/Preferences/io.imFile.plist',
        '~/Library/Saved Application State/io.imFile.savedState',
      ]
end
