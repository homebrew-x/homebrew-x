cask 'llm-space@performance' do
  arch arm: 'arm64', intel: 'x64'

  version '4.13.0'
  sha256 arm:
           'f9ae2a42347685d8c14f3bd53214a06ea025f8ccf3fa06147a9a479fdc87ea03',
         intel:
           '15e741da0d179035bf5f633704973f5dab4aba2ed98b6c28a30c63b87c146a5e'

  url "https://github.com/deer-flow/llm-space/releases/download/v#{version}/LLMSpace-performance-v#{version}-macos-#{arch}.dmg",
      verified: 'github.com/deer-flow/llm-space/'
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
