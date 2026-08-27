cask 'llm-space@performance' do
  arch arm: 'arm64', intel: 'x64'

  version "4.14.2"
  sha256 arm:
           "4c9629fbec0ca14c9c6819535355eca37e9ee98b633011626a44958ca033f651",
         intel:
           "c3280d32cf6ff1759efd6d229a0319b9fcc72f6fd25dfc7cd5eb3de53b4f2497"

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
