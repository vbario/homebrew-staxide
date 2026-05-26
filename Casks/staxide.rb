cask "staxide" do
  version "0.2.0"
  sha256 "252b5ae43ff3fb84792eaa4ee0b5a71650e848ffdeda3944c5e03354f54b34af"

  url "https://github.com/vbario/staxide/releases/download/v#{version}/STAXIDE-#{version}.dmg"
  name "STAX IDE"
  desc "Local-only multi-stack terminal IDE"
  homepage "https://staxide.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  # First-launch note: the .app is ad-hoc signed (no Apple Developer ID
  # yet), so macOS Gatekeeper will block the first open. Tell the user
  # to right-click → Open the first time, or strip the quarantine xattr.
  # Once we notarize, this caveat goes away.
  caveats <<~EOS
    The build is not yet notarized. On first launch macOS may say the
    developer cannot be verified — right-click STAX IDE in
    /Applications and choose Open, then click Open in the dialog.
    A subsequent double-click works normally.

    Or, from the terminal:
      xattr -dr com.apple.quarantine "/Applications/STAX IDE.app"
  EOS

  app "STAXIDE.app", target: "STAX IDE.app"

  zap trash: [
    "~/.termgrid",
    "~/Library/Preferences/io.vbar.termgrid.plist",
    "~/Library/Saved Application State/io.vbar.termgrid.savedState",
  ]
end
