cask 'mygo-music' do
  arch arm: 'arm64', intel: 'amd64'

  version '0.1.19'
  sha256 arm:
           'c80d52c3fc4cd5dcd4887e13fe6e827e5e14867c27baf470c0bb4a3d14becf72',
         intel:
           '1eea1071670894c189302b2514b5285fb459255148b145da860dcda774682af0',
         arm64_linux:
           '9272a11d7e654485f43f6b3af6a49f90c2d9260f7130f99cf90eddd109c16ea6',
         x86_64_linux:
           'ac155828ea842ad2ef9b4158b924ed5590af255c24093a3143802f5d94b0cac1'

  on_macos do
    url "https://github.com/egoist/mygo-music/releases/download/v#{version}/mygo-music-#{version}-#{arch}.dmg"

    depends_on macos: :ventura

    app 'MyGo Music.app'

    zap trash: [
          '~/Library/Application Support/MyGo Music',
          '~/Library/Caches/MyGo Music',
          '~/Library/Logs/MyGo Music',
          '~/Library/Preferences/dev.egoist.music.plist',
          '~/Library/Saved Application State/dev.egoist.music.savedState',
        ]
  end
  on_linux do
    url "https://github.com/egoist/mygo-music/releases/download/v#{version}/mygo-music-#{version}-linux-#{arch}.tar.gz"

    depends_on formula: 'gtk+3'

    binary 'mygo-music'
    artifact 'mygo-music.desktop',
             target: '~/.local/share/applications/mygo-music.desktop'

    preflight_steps do
      inreplace 'mygo-music.desktop',
                'Exec=mygo-music',
                'Exec={{HOMEBREW_PREFIX}}/bin/mygo-music'
      inreplace 'mygo-music.desktop',
                'Icon=mygo-music',
                'Icon={{staged_path}}/mygo-music.png'
    end

    zap trash: ['~/.cache/MyGo Music', '~/.config/MyGo Music']
  end

  name 'MyGo Music'
  desc 'Native music player you extend with plugins'
  homepage 'https://github.com/egoist/mygo-music'

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
end
