cask "melatonin" do
  version "0.1.0"
  sha256 "c7648f196c3a19a1a662a7ff6efcdae8ee9d6a81b844acac3897f25d926e5ff2"

  url "https://github.com/jugol/Melatonin/releases/download/v#{version}/Melatonin.dmg"
  name "Melatonin"
  desc "Keep your Mac awake with the lid closed while AI agents work"
  homepage "https://jugol.github.io/Melatonin/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "Melatonin.app"

  uninstall launchctl: "io.github.jugol.melatonin.helper",
            quit:      "io.github.jugol.Melatonin",
            script:    {
              executable: "/usr/bin/pmset",
              args:       ["-a", "disablesleep", "0"],
              sudo:       true,
            },
            delete:    [
              "/Library/Application Support/Melatonin",
              "/Library/LaunchDaemons/io.github.jugol.melatonin.helper.plist",
              "/Library/PrivilegedHelperTools/io.github.jugol.melatonin.helper",
            ]

  zap trash: "~/Library/Preferences/io.github.jugol.Melatonin.plist"

  caveats <<~EOS
    Melatonin isn't notarized by Apple yet. If macOS blocks the first launch,
    open System Settings › Privacy & Security and click "Open Anyway", or run:
      xattr -dr com.apple.quarantine #{appdir}/Melatonin.app
  EOS
end
