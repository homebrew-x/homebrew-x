cask 'clashx-meta' do
  version '1.4.46'
  sha256 'b98426e9ab51b7f01afb2f5491571034d17de3aecab36d4e346771ff9d5ce96d'

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
