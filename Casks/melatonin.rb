cask "melatonin" do
  version "0.1.4"
  sha256 "3c8b1ed2bf2a55efbdb48aa84d3edf5427156c810bd9a08ed88700a6ec052e42"

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
    To remove Melatonin's privileged helper too, uninstall with --zap.
  EOS
end
