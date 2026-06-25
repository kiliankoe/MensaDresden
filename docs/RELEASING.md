# Releasing

How to ship a new version of Mensa Dresden. This project no longer uses Xcode Cloud, but is built locally using fastlane. All commands run inside the nix devshell (`direnv allow`, or `nix develop`).

## Prerequisites (one-time)

- **App Store Connect API key** in `.envrc.local` (gitignored): `ASC_KEY_ID`, `ASC_ISSUER_ID`, `ASC_KEY_FILEPATH` (path to the `.p8`).
- An **Apple Distribution** certificate (with private key) in the login keychain — Xcode ▸ Settings ▸ Accounts ▸ Manage Certificates ▸ **+ Apple Distribution**.
- App Store **distribution provisioning profiles** for `io.kilian.MensaDresden` and `…watchkitapp` (created on the first archive + distribute via Xcode's Organizer).

## Version & build numbers

- **Marketing version** (`appVersion` in `Project.swift`) — bumped by hand, once per release (e.g. `2026.3` → `2026.4`); feeds `CFBundleShortVersionString`. Must be higher than the last approved version.
- **Build number** (`appBuildNumber`) — automatic, not edited per release. The lanes derive it from App Store Connect (`latest_testflight_build_number + 1`) and inject it at build time; the committed value is only a baseline for local builds.

## Release (App Store)

1. **Bump the version** — set `appVersion` in `Project.swift` (e.g. `2026.4`).
2. **Write release notes** — edit `fastlane/metadata/<locale>/release_notes.txt` for each store locale (one folder per locale under `fastlane/metadata/`).
3. **Build & upload the binary** — `fastlane ios release`. The build lands in ASC under the `2026.4` train; allow a few minutes for processing.
4. **Push metadata & create the version** — `fastlane ios upload_metadata`. `deliver` creates/updates the `2026.4` version record and uploads the localized text.
  - `upload_metadata` does not upload screenshots; use `fastlane ios upload_screenshots` if needed.
  - This can only attach a processed build; if the build isn't found yet, wait a couple of minutes and rerun.
5. **Finish in App Store Connect (manual)** — confirm the build is selected, answer export compliance if prompted, then **Submit for Review**. Submission is intentionally manual (`submit_for_review: false`).
6. **Tag the released commit** — tag the exact commit that was built, matching the bare-version convention:
   ```bash
   git tag 2026.4 && git push origin 2026.4
   ```

## TestFlight-only build

`fastlane ios beta` — same build/sign/upload, then `upload_to_testflight`. No version record or metadata changes.

## Screenshots & metadata (independent of a release)

- `fastlane ios screenshots` — regenerate (config in `fastlane/Snapfile`).
- `fastlane ios download_metadata` / `upload_metadata` — pull from / push to ASC.
- Full lane list: `fastlane/README.md` or `fastlane lanes`.
