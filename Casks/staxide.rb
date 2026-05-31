cask "staxide" do
  version "0.4.15"
  sha256 "5880c7b0749377772ce7253c5b15455a8afea6ee61e718a1649f565c167da0ba"

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
