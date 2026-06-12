cask "staxide" do
  version "0.4.37"
  sha256 "a559867eb0aaa73f6504d443eb28093ff2090b14f1c407a0c9ad4170a3cc7797"

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

  # Fire-and-forget install ping so staxide.com/stats can count cask installs
  # alongside website downloads and in-app updates. Anonymous: only the version
  # is sent. Run via `sh -c "... &"` so curl is backgrounded and fully silenced
  # (capped at 5s) — a network hiccup can never fail or slow the install.
  postflight do
    system_command "/bin/sh",
                   args: ["-c",
                          "curl -fsS -m 5 " \
                          "-H 'Content-Type: application/json' " \
                          "--data '{\"version\":\"#{version}\",\"source\":\"cask\"}' " \
                          "-X POST https://staxide.com/api/track-download " \
                          ">/dev/null 2>&1 &"]
  end

  zap trash: [
    "~/.termgrid",
    "~/Library/Preferences/io.vbar.termgrid.plist",
    "~/Library/Saved Application State/io.vbar.termgrid.savedState",
  ]
end
