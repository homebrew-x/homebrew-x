cask 'mygo-music' do
  arch arm: 'arm64', intel: 'amd64'

  version '0.1.25'
  sha256 arm:
           '589373d58a6b2a9c2dcdcb2ca7ecfc0b5ca43d029174e73240eed491e94a211d',
         intel:
           '3e52759de81d4890e30be2c13593dcde15a678d891b98761a833341706b4febd',
         arm64_linux:
           'd676b54ffc8aa2bdd44de41d60f47998eed53f338dff2c49fec85ea5d0a08573',
         x86_64_linux:
           'b4688195ab31084ad306f036836de6e574c4ff33e567fd264c35f7841d64742b'

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
