cask 'sideserver' do
  version '1.0.6'
  sha256 'cd3a185af744f4659f7adb6d846b0e8d718c0cabf2be917f3513a60f5b931d22'

  url "https://github.com/SideStore/SideServer-macOS/releases/download/v#{version}/SideServer.dmg"
  name 'SideServer'
  desc 'Alternative iOS app store for seamless sideloading'
  homepage 'https://sidestore.io/'

  auto_updates true
  depends_on macos: :catalina

  app 'SideServer.app'

  uninstall launchctl: 'io.SideStore.SideServer-LaunchAtLoginHelper',
            quit: 'io.SideStore.SideServer',
            delete: '/Applications/SideServer.app'

  zap trash: [
        '~/Library/Application Scripts/io.SideStore.SideServer-LaunchAtLoginHelper',
        '~/Library/HTTPStorages/io.SideStore.SideServer',
        '~/Library/Preferences/io.SideStore.SideServer.plist',
      ]
end
