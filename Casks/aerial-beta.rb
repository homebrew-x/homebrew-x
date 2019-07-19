cask 'aerial-beta' do
  version '1.5.1beta10'
  sha256 '6773cc215692914167bb8d7d209aaf65162bd277014310fa81d750181a19a5b7'

  url "https://github.com/JohnCoates/Aerial/releases/download/v#{version}/Aerial.saver.zip"
  appcast 'https://github.com/JohnCoates/Aerial/releases.atom'
  name 'Aerial Screensaver'
  homepage 'https://github.com/JohnCoates/Aerial'

  screen_saver 'Aerial.saver'

  zap trash: '~/Library/Caches/Aerial'
end
