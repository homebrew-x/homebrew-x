cask 'transmissionic' do
  version '1.8.0'
  sha256 'badfc69a0281311afdec2f2a13be3bf90c7ee95a22e9d68ca4277ce0a37dea43'

  url "https://github.com/6c65726f79/Transmissionic/releases/download/v#{version}/Transmissionic-mac-v#{version}.dmg",
      verified: 'github.com/6c65726f79/Transmissionic/'
  name 'Transmissionic'
  desc 'Remote for Transmission Daemon'
  homepage 'https://github.com/6c65726f79/Transmissionic'

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  app 'Transmissionic.app'

  zap trash: [
        '~/Library/Application Support/Transmissionic',
        '~/Library/Caches/com.sleroy.transmissionic',
        '~/Library/Logs/Transmissionic',
        '~/Library/Preferences/com.sleroy.transmissionic.plist',
        '~/Library/Saved Application State/com.sleroy.transmissionic.savedState',
      ]
end
