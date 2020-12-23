require_relative '../shared/appcenter_download_strategy.rb'

cask 'clashx-pro' do
  version '1.31.2.1'
  sha256 'f0ce1ae36ab256ec58b136c74687eee2d689fdc662fdd1ba6973d49817f3c810'

  url "https://install.appcenter.ms/users/clashx/apps/clashx-pro/distribution_groups/public?version=#{
        version
      }",
      using: AppCenterDownloadStrategy
  name 'ClashX Pro'
  desc 'A rule based proxy For Mac base on Clash.'
  homepage 'https://install.appcenter.ms/users/clashx/apps/clashx-pro/distribution_groups/public'

  auto_updates true
  depends_on macos: '>= :sierra'

  app 'ClashX Pro.app'

  uninstall delete: %w[
              /Library/PrivilegedHelperTools/com.west2online.ClashXPro.ProxyConfigHelper
              /Library/LaunchDaemons/com.west2online.ClashXPro.ProxyConfigHelper.plist
            ],
            launchctl: 'com.west2online.ClashXPro.ProxyConfigHelper',
            quit: 'com.west2online.ClashXPro'

  zap trash: [
        '~/Library/Application Support/com.west2online.ClashXPro',
        '~/Library/Cookies/com.west2online.ClashXPro.binarycookies',
        '~/Library/Caches/io.fabric.sdk.mac.data/com.west2online.ClashXPro',
        '~/Library/Caches/com.west2online.ClashXPro',
        '~/Library/Caches/com.crashlytics.data/com.west2online.ClashXPro',
        '~/Library/Preferences/com.west2online.ClashXPro.plist',
        '~/Library/Logs/ClashX Pro',
        '~/.config/clash/'
      ]
end
