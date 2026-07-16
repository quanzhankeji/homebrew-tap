cask "omnidock" do
  version "1.0"
  sha256 "4f0678d34ed01f848ddb565f89d82c61fb0c97befaa54ddbaa895fd9f23969c6"

  url "https://github.com/quanzhankeji/OmniDock/releases/download/#{version}/OmniDock-#{version}.zip"
  name "OmniDock"
  desc "Dock window previews, app toggling, and per-app keyboard shortcuts"
  homepage "https://github.com/quanzhankeji/OmniDock"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :monterey

  app "OmniDock.app"

  uninstall quit: "com.quanzhankeji.OmniDock"

  zap trash: [
    "~/Library/Preferences/com.quanzhankeji.OmniDock.plist",
    "~/Library/Saved Application State/com.quanzhankeji.OmniDock.savedState",
  ]

  caveats "OmniDock requires macOS 12.3 or later."
end
