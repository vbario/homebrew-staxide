cask "staxide" do
  version "0.6.0"
  sha256 "132c6c65b7d9dbf4b46dd9b51f703cd4e7731f478d01523ec087c3922c8fc517"

  url "https://github.com/vbario/staxide/releases/download/v#{version}/STAXIDE-#{version}.dmg"
  name "STAX IDE"
  desc "Local-only multi-stack terminal IDE"
  homepage "https://staxide.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  # As of 0.6.0 the app and DMG are Developer ID-signed and Apple-notarized,
  # so Gatekeeper accepts them on first launch — no caveat needed.

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
