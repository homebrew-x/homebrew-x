cask 'llm-space' do
  arch arm: 'arm64', intel: 'x64'

  version "4.15.2"
  sha256 arm:
           "6e6ebaaa8e288a39799169e5453d31d0b04f3ede11b1b6962d4fcc81cef5cfd4",
         intel:
           "0be4f20a22987d034420c161779be80ff965b0a0b41b4e7e8e89ff952c0ed4d5"

  url "https://github.com/deer-flow/llm-space/releases/download/v#{version}/LLMSpace-v#{version}-macos-#{arch}.dmg",
      verified: 'github.com/deer-flow/llm-space/'
  name 'LLM Space'
  desc 'Prototype agent ideas, inspect harness steps, replay failures, and evaluate performance'
  homepage 'https://deer-flow.github.io/llm-space/'

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app 'LLM Space.app'

  zap trash: [
        '~/Library/Application Support/tech.deerflow.llm-space',
        '~/Library/Caches/tech.deerflow.llm-space',
        '~/Library/Logs/tech.deerflow.llm-space',
        '~/Library/Preferences/tech.deerflow.llm-space.plist',
        '~/Library/Saved Application State/tech.deerflow.llm-space.savedState',
      ]
end
