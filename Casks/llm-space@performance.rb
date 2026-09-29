cask 'llm-space@performance' do
  arch arm: 'arm64', intel: 'x64'

  version '4.19.1'
  sha256 arm:
           'a1c73ae56651b3245578f0eede7cde0b657d1474bba544f2f0cdf10b6c2684cb',
         intel:
           '9c5fc71e5a39e0c12f064c25c067f027ea2b23825a974a6b35f3c379f1b531f4'

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
