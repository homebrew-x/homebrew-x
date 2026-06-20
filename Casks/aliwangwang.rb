cask 'aliwangwang' do
  version '10.01.06M'
  sha256 '9957c3b7bdd031868af0187c0cb912f4c926f82221bbe34fb05f6eb1396fa5b0'

  url "https://download.alicdn.com/wangwang/AliWangWang_(#{version}).dmg",
      verified: 'download.alicdn.com/wangwang/'
  name 'Ali Wangwang'
  name '阿里旺旺'
  homepage 'https://pages.tmall.com/wow/qnww/act/index'

  auto_updates true

  app 'AliWangwang.app'

  uninstall quit: 'com.taobao.Aliwangwang'

  zap trash: [
        '~/Library/Application Support/AliWangwang',
        '~/Library/Caches/com.taobao.Aliwangwang',
        '~/Library/Containers/com.taobao.Aliwangwang',
        '~/Library/HTTPStorages/com.taobao.Aliwangwang',
        '~/Library/HTTPStorages/com.taobao.Aliwangwang.binarycookies',
        '~/Library/Preferences/com.taobao.Aliwangwang.plist',
        '~/Library/Saved Application State/com.taobao.Aliwangwang.savedState',
        '~/Library/WebKit/com.taobao.Aliwangwang',
      ]
end
