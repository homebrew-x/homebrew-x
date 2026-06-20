cask 'ryujinx' do
  version '1.3.3'
  sha256 'e4818bb84c98e0d3120691821e90772099e46101273d3f145ffdb10eee2c0dbb'

  url "https://git.ryujinx.app/projects/Ryubing/releases/download/#{version}/ryujinx-#{version}-macos_universal.app.tar.gz"
  name 'Ryujinx'
  desc 'Experimental Nintendo Switch Emulator'
  homepage 'https://ryujinx.app'

  livecheck do
    url 'https://git.ryujinx.app/projects/Ryubing/releases'
    regex(
      %r{href=.*?/download/v?(\d+(?:\.\d+)+)/ryujinx[._-]v?\1[._-]macos[._-]universal\.app\.tar\.gz}i,
    )
  end

  app 'Ryujinx.app'

  zap trash: [
        '~/Library/Preferences/org.ryujinx.Ryujinx.plist',
        '~/Library/Saved Application State/org.ryujinx.Ryujinx.savedState',
      ]
end
