cask 'llm-space' do
  arch arm: 'arm64', intel: 'x64'

  version '4.18.1'
  sha256 arm:
           '21ba05c33a744b73b22ce5ef7b9ab643f1cd73299bd0b332bcef44df4c870a82',
         intel:
           'c5870eded6a52fa0e1a39c52bf1d7dae7582a68555db544e27a87525b9c661d4'

  url "https://github.com/deer-flow/llm-space/releases/download/v#{version}/LLMSpace-v#{version}-macos-#{arch}.dmg"
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
