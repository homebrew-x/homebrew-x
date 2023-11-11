cask 'ryujinx' do
  version '1.1.1072'
  sha256 '4e8991b7d0f9e760242a9634ed8fcc551130e1cd1c682dc2a87b47753792accc'

  url "https://github.com/Ryujinx/release-channel-master/releases/download/#{version}/test-ava-ryujinx-#{version}-macos_universal.app.tar.gz"
  name 'Ryujinx'
  desc 'Experimental Nintendo Switch Emulator'
  homepage 'https://ryujinx.org'

  livecheck do
    url :url
    strategy :github_latest
  end

  app 'Ryujinx.app'

  zap trash: [
        '~/Library/Preferences/org.ryujinx.Ryujinx.plist',
        '~/Library/Saved Application State/org.ryujinx.Ryujinx.savedState',
      ]
end
