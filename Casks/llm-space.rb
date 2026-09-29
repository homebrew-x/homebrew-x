cask 'llm-space' do
  arch arm: 'arm64', intel: 'x64'

  version '4.19.1'
  sha256 arm:
           '4b734b2244f9a1e44b9224d6f210c827845a1133b28959592b5a64bfa355562e',
         intel:
           '27d2ac6fb71897816d1e0d3a8f3b356938c8aaedc2c14b4d6560a9e82163ef11'

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
