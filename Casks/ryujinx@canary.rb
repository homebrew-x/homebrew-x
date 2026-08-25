cask 'ryujinx@canary' do
  version "1.3.349"
  sha256 "fb6003844764d498c4cc29296caaf1d867dabd79d461a60073ccca72c5350636"

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
