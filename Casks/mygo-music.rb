cask 'mygo-music' do
  arch arm: 'arm64', intel: 'amd64'

  version '0.1.21'
  sha256 arm:
           '956c72d7f13ad2a5a3abbde03c3750e38475ae577db0f74ff557c1671c1e608b',
         intel:
           '09f7efbb465bc4b1edc8c38ae263ac5fd61268e17e8ec30ca7f24bd519f099c1',
         arm64_linux:
           'd378bdc2dd5492714deca91107db9cd51537881a6a99324af527cea8b9d03dcc',
         x86_64_linux:
           '9f7e3973d6294c766eb9ed27f643f81357090e9a2d2d24697a1807453b38cae6'

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
