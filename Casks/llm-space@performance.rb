cask 'llm-space@performance' do
  arch arm: 'arm64', intel: 'x64'

  version '4.18.1'
  sha256 arm:
           '795dfed1cd8b73adab9aaf961a2be429cc5bd7b9f41a6811463c07c7ed221590',
         intel:
           'b0a00001bdf40d279f4805f0bc05d74f13383c26fcc39cfe81015678b4b66e9d'

  url "https://github.com/deer-flow/llm-space/releases/download/v#{version}/LLMSpace-performance-v#{version}-macos-#{arch}.dmg"
  name 'LLM Space Performance'
  desc 'Prototype agent ideas, inspect harness steps, replay failures, and evaluate performance'
  homepage 'https://deer-flow.github.io/llm-space/'

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app 'LLM Space Performance.app'

  zap trash: [
        '~/Library/Application Support/tech.deerflow.llm-space.performance',
        '~/Library/Caches/tech.deerflow.llm-space.performance',
        '~/Library/Logs/tech.deerflow.llm-space.performance',
        '~/Library/Preferences/tech.deerflow.llm-space.performance.plist',
        '~/Library/Saved Application State/tech.deerflow.llm-space.performance.savedState',
      ]
end
