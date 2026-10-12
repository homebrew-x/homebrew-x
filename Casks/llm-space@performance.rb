cask 'llm-space@performance' do
  arch arm: 'arm64', intel: 'x64'

  version '4.20.0'
  sha256 arm:
           'ac5e4cf4acbdc3364572ce030c67836fafd4d9ebe7620726f5b95f1960b56bac',
         intel:
           'e60cd71f58494cf106c7aa4f6f4629caaf1bd40d5d8a87b4e8b2cdec02ac553d'

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
