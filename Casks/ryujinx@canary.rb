cask 'ryujinx@canary' do
  version '1.3.354'
  sha256 '83858164e1d3c78772d018f484c20dd3fd93da8e4adf4438e06dad119438c41c'

  url "https://git.ryujinx.app/Ryubing/Canary/releases/download/#{version}/ryujinx-canary-#{version}-macos_universal.app.tar.gz"
  name 'Ryujinx Canary'
  desc 'Experimental Nintendo Switch Emulator (Canary)'
  homepage 'https://ryujinx.app/'

  livecheck do
    url 'https://git.ryujinx.app/Ryubing/Canary/releases'
    regex(
      %r{href=.*?/download/v?(\d+(?:\.\d+)+)/ryujinx-canary[._-]v?\1[._-]macos[._-]universal\.app\.tar\.gz}i,
    )
  end

  depends_on :macos

  app 'Ryujinx.app'

  zap trash: [
        '~/Library/Preferences/org.ryujinx.Ryujinx.plist',
        '~/Library/Saved Application State/org.ryujinx.Ryujinx.savedState',
      ]
end
