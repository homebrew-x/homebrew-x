cask 'ryujinx@canary' do
  version "1.3.351"
  sha256 "bcdac85194e89e6f5ad19282b91af7a5f8c8a08aa908040750b688028efa7212"

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
