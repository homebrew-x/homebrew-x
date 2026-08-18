cask 'llm-space' do
  arch arm: 'arm64', intel: 'x64'

  version '4.13.0'
  sha256 arm:
           'c313b7c41237b210352cd68c02605acc8b636cb1c46b79ea13380c8678dd504c',
         intel:
           '1682c9c0370785b24f2a9e3929aeaeca123fc1ad2cc12a33ec2c51d405be9266'

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
