cask 'intellij-idea-eap' do
  arch arm: '-aarch64'

  version '2023.3,233.11799.67'
  sha256 arm:
           '8c76c861901e831558c684a779bb34daadbc14f6e30ba6a31f1ccb51b249c1e9',
         intel:
           'ca349a7ac4654ffbf4e1621410323a4bf6f9ca0425a9fce47fca23595b0bee17'

  url "https://download.jetbrains.com/idea/ideaIU-#{version.csv.second}#{arch}.dmg"
  name 'IntelliJ IDEA EAP'
  desc 'IntelliJ IDEA Early Access Program'
  homepage 'https://www.jetbrains.com/idea/nextversion'

  livecheck do
    url 'https://data.services.jetbrains.com/products/releases?code=IIU&release.type=eap'
    strategy :json do |json|
      json['IIU'].map { |release| "#{release['version']},#{release['build']}" }
    end
  end

  auto_updates true
  depends_on macos: '>= :high_sierra'

  app "IntelliJ IDEA #{version.csv.first} EAP.app"

  uninstall_postflight do
    ENV['PATH']
      .split(File::PATH_SEPARATOR)
      .map { |path| File.join(path, 'idea') }
      .each do |path|
        if File.readable?(path) &&
             File
               .readlines(path)
               .grep(
                 /# see com.intellij.idea.SocketLock for the server side of this interface/,
               )
               .any?
          File.delete(path)
        end
      end
  end

  zap trash: [
        "~/Library/Application Support/JetBrains/IntelliJIdea#{version.major_minor}",
        "~/Library/Caches/JetBrains/IntelliJIdea#{version.major_minor}",
        "~/Library/Logs/JetBrains/IntelliJIdea#{version.major_minor}",
        '~/Library/Preferences/com.jetbrains.intellij.plist',
        "~/Library/Preferences/IntelliJIdea#{version.major_minor}",
        '~/Library/Preferences/jetbrains.idea.*.plist',
        '~/Library/Saved Application State/com.jetbrains.intellij.savedState',
      ]
end
