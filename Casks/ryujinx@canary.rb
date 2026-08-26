cask 'ryujinx@canary' do
  version "1.3.350"
  sha256 "ce24012f6460cdaa2676a6986b13b4c8d9de497ee8793cb071fa1a7623f1f27c"

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
