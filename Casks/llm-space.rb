cask 'llm-space' do
  arch arm: 'arm64', intel: 'x64'

  version '4.20.0'
  sha256 arm:
           '865c6cda4745159299433a650490d493cead9b7966cd14cbb9704b7997b83f2f',
         intel:
           '168ab104b3e9798d6e2ebd03aea2409fedec66c98ab4452203c3efa21eb18214'

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
