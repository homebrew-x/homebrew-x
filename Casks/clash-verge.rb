cask 'clash-verge' do
  version '1.3.8'
  sha256 arm:
           '1b6037b599aefc67042b87899e8c1e7c9a6db2c91897bb22e0e606756ccc20cf',
         intel:
           'c5c9369353364496174ba2522e487147cd588b7e0831ed9ae7218635ada6d52b'

  suffix = on_arch_conditional arm: '.aarch64', intel: '_x64'

  url "https://github.com/zzzgydi/clash-verge/releases/download/v#{version}/Clash.Verge#{suffix}.app.tar.gz"
  name 'Clash Verge'
  desc 'Cross-Platform Clash GUI based on Tauri'
  homepage 'https://github.com/zzzgydi/clash-verge'

  livecheck do
    url :url
    strategy :github_latest
  end

  app 'Clash Verge.app'

  zap trash: [
        '~/.config/clash-verge',
        '~/Library/Caches/top.gydi.clashverge',
        '~/Library/Preferences/top.gydi.clashverge.plist',
        '~/Library/Saved Application State/top.gydi.clashverge.savedState',
      ]
end
