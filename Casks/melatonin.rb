cask "melatonin" do
  version "0.1.3"
  sha256 "35752e7a2bce17db8aa924de3fb38cb553925b8ac092586cbe6068a32c6f1e41"

  url "https://github.com/jugol/Melatonin/releases/download/v#{version}/Melatonin.dmg"
  name "Melatonin"
  desc "Keeps the computer awake with the lid closed while AI agents work"
  homepage "https://jugol.github.io/Melatonin/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "Melatonin.app"

  # Quitting the app is enough for the helper to restore normal sleep. The
  # helper itself stays across upgrades so they don't need a password; `zap`
  # removes it.
  uninstall quit: "io.github.jugol.Melatonin"

  zap launchctl: "io.github.jugol.melatonin.helper",
      script:    {
        executable: "/usr/bin/pmset",
        args:       ["-a", "disablesleep", "0"],
        sudo:       true,
      },
      delete:    [
        "/Library/Application Support/Melatonin",
        "/Library/LaunchDaemons/io.github.jugol.melatonin.helper.plist",
        "/Library/PrivilegedHelperTools/io.github.jugol.melatonin.helper",
      ],
      trash:     "~/Library/Preferences/io.github.jugol.Melatonin.plist"

  caveats <<~EOS
    Melatonin isn't notarized by Apple yet. If macOS blocks the first launch,
    open System Settings › Privacy & Security and click "Open Anyway", or run:
      xattr -dr com.apple.quarantine #{appdir}/Melatonin.app

    To remove Melatonin's privileged helper too, uninstall with --zap.
  EOS
end
