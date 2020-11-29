require_relative '../shared/appcenter_download_strategy.rb'

cask 'clashx-pro' do
  version '1.31.0.1'
  sha256 'a606c0558c3f391af832ef8f1ef1c667bf0b90cad69107e9c645abb08360362f'

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
