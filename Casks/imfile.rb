cask "imfile" do
  arch arm: "-arm64"

  version "1.0.8"
  sha256 arm:   "e910960baf4982378496a234b59b03fe6ca45618de8e5c2713b9323a4d7cfff0",
         intel: "96411654c8b21ebc97c888def6621e08c31aef51f0872b866ac461b5eaa48a4f"

  url "https://github.com/imfile-io/imfile-desktop/releases/download/v#{version}/imFile-#{version}#{arch}.dmg",
      verified: "github.com/imfile-io/imfile-desktop/"
  name "imFile"
  desc "Open-source download manager"
  homepage "https://imfile.io/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "imFile.app"

  zap trash: [
    "~/Library/Application Support/imFile",
    "~/Library/Caches/io.imFile",
    "~/Library/Logs/imFile",
    "~/Library/Preferences/io.imFile.plist",
    "~/Library/Saved Application State/io.imFile.savedState",
  ]
end
