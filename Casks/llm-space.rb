cask 'llm-space' do
  arch arm: 'arm64', intel: 'x64'

  version "4.14.2"
  sha256 arm:
           "0fcdbdb3703ffc9eb4bc921ee051a1f8f2f780db5d4bf62eac1751e83e124cd1",
         intel:
           "758d13048b9462b1280655fdf7c79cf782940c4515c7bf2665807d9a999f77c2"

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
