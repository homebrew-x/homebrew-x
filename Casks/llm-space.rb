cask 'llm-space' do
  arch arm: 'arm64', intel: 'x64'

  version '4.3.0'
  sha256 arm:
           '8674dffa864a3911a77a8c0e369a651ad99455ce0155c4650019fbd4aea78ab6',
         intel:
           '70da7f2e7710ebb2ba075deccc5088b1f2d6b6575643a3d3da7e32b9375180f8'

  url "https://github.com/deer-flow/llm-space/releases/download/v#{version}/LLMSpace-v#{version}-macos-#{arch}.dmg",
      verified: 'github.com/deer-flow/llm-space/'
  name 'LLM Space'
  desc 'Prototype agent ideas, inspect harness steps, replay failures, and evaluate performance'
  homepage 'https://deer-flow.github.io/llm-space/'

  livecheck do
    url :url
    strategy :github_latest
  end

  app 'LLM Space.app'

  zap trash: [
        '~/Library/Application Support/tech.deerflow.llm-space',
        '~/Library/Caches/tech.deerflow.llm-space',
        '~/Library/Logs/tech.deerflow.llm-space',
        '~/Library/Preferences/tech.deerflow.llm-space.plist',
        '~/Library/Saved Application State/tech.deerflow.llm-space.savedState',
      ]
end
