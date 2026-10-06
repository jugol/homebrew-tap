cask "melatonin" do
  version "0.1.5"
  sha256 "555e03b75e7e58c46def53ffe4658843c63377c0e788f188e917b2de89e45c60"

  url "https://github.com/jugol/Melatonin/releases/download/v#{version}/Melatonin.dmg"
  name "Melatonin"
  desc "Keeps the computer awake with the lid closed while AI agents work"
  homepage "https://jugol.github.io/Melatonin/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
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
      trash:     [
        "~/Library/Caches/io.github.jugol.Melatonin",
        "~/Library/Preferences/io.github.jugol.Melatonin.plist",
      ]

  caveats <<~EOS
    To remove Melatonin's privileged helper too, uninstall with --zap.
  EOS
end
