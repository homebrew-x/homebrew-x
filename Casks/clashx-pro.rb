require_relative '../shared/appcenter_download_strategy.rb'

cask 'clashx-pro' do
  version '1.40.0.1'
  sha256 '4f9fb11bf8118478e1f3e52c951cc3f6a6e618c043377f6e0e543656344f59dd'

  url "https://install.appcenter.ms/users/clashx/apps/clashx-pro/distribution_groups/public?version=#{
        version
      }",
      using: AppCenterDownloadStrategy
  name 'ClashX Pro'
  desc 'A rule based proxy For Mac base on Clash.'
  homepage 'https://install.appcenter.ms/users/clashx/apps/clashx-pro/distribution_groups/public'

  livecheck do
    url 'https://api.appcenter.ms/v0.1/public/sparkle/apps/1cd052f7-e118-4d13-87fb-35176f9702c1'
    strategy :sparkle
  end

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
        '~/.config/clash/',
      ]
end
