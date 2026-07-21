cask 'llm-space@performance' do
  arch arm: 'arm64', intel: 'x64'

  version '4.3.0'
  sha256 arm:
           'dd1fd644db729279da8e3fa45ce2c3cf1ec509462fd812b5a79eb275e0957fc6',
         intel:
           'df3ef5e7541184fc2311450997275a71ddda59a7e5a14c15ccc666ef819bb17d'

  url "https://github.com/deer-flow/llm-space/releases/download/v#{version}/LLMSpace-performance-v#{version}-macos-#{arch}.dmg",
      verified: 'github.com/deer-flow/llm-space/'
  name 'LLM Space Performance'
  desc 'Prototype agent ideas, inspect harness steps, replay failures, and evaluate performance'
  homepage 'https://deer-flow.github.io/llm-space/'

  livecheck do
    url :url
    strategy :github_latest
  end

  app 'LLM Space Performance.app'

  zap trash: [
        '~/Library/Application Support/tech.deerflow.llm-space.performance',
        '~/Library/Caches/tech.deerflow.llm-space.performance',
        '~/Library/Logs/tech.deerflow.llm-space.performance',
        '~/Library/Preferences/tech.deerflow.llm-space.performance.plist',
        '~/Library/Saved Application State/tech.deerflow.llm-space.performance.savedState',
      ]
end
