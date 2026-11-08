cask 'mygo-music' do
  arch arm: 'arm64', intel: 'amd64'

  version '0.1.22'
  sha256 arm:
           'f1074aab65cee1530e5038eb63d9860e77f0c376858110baf85d5f240a7ec43d',
         intel:
           '29fd1b5835e8f483a8da602e42c39066f1742185667b5dea60944f9a5b2251b4',
         arm64_linux:
           '5434d1addaad9d8ffcf5a6c271208c94bbd78ea2ffbc4721cbcf9f6871768a82',
         x86_64_linux:
           '7507094313b97d03c6abf9eb45ef83dc01722d367f242f55cf84f9116243b71a'

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

    xdg_data_home =
      ENV['XDG_DATA_HOME'] || ENV['HOMEBREW_XDG_DATA_HOME'] || '~/.local/share'
    xdg_config_home =
      ENV['XDG_CONFIG_HOME'] || ENV['HOMEBREW_XDG_CONFIG_HOME'] || '~/.config'
    xdg_cache_home =
      ENV['XDG_CACHE_HOME'] || ENV['HOMEBREW_XDG_CACHE_HOME'] || '~/.cache'

    binary 'mygo-music-wrapper', target: 'mygo-music'

    preflight_steps do
      write_file 'mygo-music-wrapper', <<~SH
        #!/bin/sh
        export LD_LIBRARY_PATH="{{HOMEBREW_PREFIX}}/lib:{{HOMEBREW_PREFIX}}/opt/gtk+3/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
        exec "{{staged_path}}/mygo-music" "$@"
      SH
      set_permissions 'mygo-music-wrapper', '+x'
      inreplace 'mygo-music.desktop',
                'Exec=mygo-music',
                'Exec={{HOMEBREW_PREFIX}}/bin/mygo-music'
      inreplace 'mygo-music.desktop',
                'Icon=mygo-music',
                'Icon={{staged_path}}/mygo-music.png'
    end

    # Copy rather than link: the app replaces mygo-music.desktop on self-update.
    postflight_steps do
      copy 'mygo-music.desktop',
           "#{xdg_data_home}/applications/mygo-music.desktop"
    end

    uninstall delete: "#{xdg_data_home}/applications/mygo-music.desktop"

    zap trash: [
          "#{xdg_cache_home}/MyGo Music",
          "#{xdg_config_home}/MyGo Music",
          '~/.cache/MyGo Music',
          '~/.config/MyGo Music',
        ]

    caveats <<~EOS
      MyGo Music stores data under XDG_CONFIG_HOME and XDG_CACHE_HOME. `brew uninstall --zap`
      uses the paths recorded at install time; if you change those variables afterwards, remove
      data from the other locations the app used manually.
    EOS
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
