cask 'clashx-meta' do
  version '1.4.44'
  sha256 'd5399f0171d2d9b385f4b0225bae8021819e6a3948ea5d5a94cc6291cfe990f1'

  url "https://github.com/MetaCubeX/ClashX.Meta/releases/download/v#{version}/ClashX.Meta.zip"
  name 'ClashX Meta'
  desc 'Rule-based custom proxy with GUI based on Clash.Meta'
  homepage 'https://github.com/MetaCubeX/ClashX.Meta'

  auto_updates true
  livecheck do
    url :url
    strategy :github_latest
  end

  app 'ClashX Meta.app'

  uninstall launchctl: 'com.metacubex.ClashX.ProxyConfigHelper',
            quit: 'com.metacubex.ClashX',
            delete: %w[
              /Library/LaunchDaemons/com.metacubex.ClashX.ProxyConfigHelper.plist
              /Library/PrivilegedHelperTools/com.metacubex.ClashX.ProxyConfigHelper
            ]

  zap trash: [
        '~/Library/Application Support/com.metacubex.ClashX.meta',
        '~/Library/Caches/com.metacubex.ClashX.meta',
        '~/Library/Logs/ClashX Meta',
        '~/Library/Preferences/com.metacubex.ClashX.meta.plist',
      ]
end
