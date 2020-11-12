cask 'clashx-pro' do
  version '1.30.4.1'
  sha256 '4a0d4ce4c9da31272bde93cbc0c2aed66ee2f5c2d941175d53e162283cb1e531'

  url "https://appcenter.vercel.app/clashx/clashx-pro/#{version}"
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
