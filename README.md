<h1>Mensa Dresden
<img src="https://user-images.githubusercontent.com/2625584/66001401-b2137d00-e4a1-11e9-919a-edb5c9635ec0.png" align="right" width="128" />
</h1>

Looking to see what's for lunch today?

<a href="https://apps.apple.com/us/app/mensa-dresden/id1481891701?ls=1"><img src="https://user-images.githubusercontent.com/2625584/67429359-4b850900-f5e0-11e9-8c0f-467dd638b556.png" alt="app store" width="160"></a>

If you're interested in how this app communicates with the Studentenwerk Dresden server to fetch meal information, your recent Emeal transactions or how it reads your Emeal balance via NFC, check out [EmealKit](https://github.com/kiliankoe/emealkit).

![Screenshots](https://user-images.githubusercontent.com/2625584/148906162-fbdffcb3-da3c-447b-8291-85d907238d58.png)

## Development setup (Tuist)

This repository uses [Tuist](https://tuist.dev) manifests (`Project.swift`) instead of manually editing the Xcode project file.

### Generate the project

```bash
tuist generate
```

This opens `MensaDresden.xcworkspace` in Xcode.

### Fixture mode (stable local data)

The app supports a fixture data mode with static canteens, opening hours and meals.

- In debug builds, enable it in `Settings > Developer > Use fixture data`.
- For automated runs, force it via environment:

```bash
MENSA_DATA_MODE=fixtures
```

This is what the screenshot UI tests use, so screenshots are independent of live API timing (weekends, holidays, current serving windows).

### Typical workflow

1. Make project changes in `Project.swift` (targets, dependencies, settings, schemes).
2. Regenerate with `tuist generate`.
3. Build/test in Xcode or with `xcodebuild`.

### Useful commands

```bash
tuist version
tuist dump
tuist generate --no-open
```

### Building & releasing

Builds and releases run locally via fastlane (this project no longer uses Xcode Cloud). Authentication uses an App Store Connect API key — set these (e.g. in a gitignored `.envrc.local`):

```bash
export ASC_KEY_ID="..."
export ASC_ISSUER_ID="..."
export ASC_KEY_FILEPATH="/absolute/path/to/AuthKey_XXXXXXXX.p8"
```

Build and upload a TestFlight build:

```bash
fastlane ios beta
```

Build and upload to App Store Connect (without submitting for review):

```bash
fastlane ios release
```

Both lanes run `tuist generate` first, derive the next build number from the latest TestFlight build, and produce a signed App Store `.ipa`. Signing uses the project's automatic signing, so the distribution certificate/profile must be available in the local keychain.

### App Store screenshots

Fastlane is configured for automated localized screenshots using the `Screenshots` UI test target.

```bash
fastlane ios screenshots
```

This generates fresh screenshots in `appstore_screenshots`. The devices and languages (and other snapshot options) are configured in `fastlane/Snapfile`.

To upload screenshots to App Store Connect (without uploading a build or metadata):

```bash
fastlane ios upload_screenshots
```

Or generate and upload in one go:

```bash
fastlane ios screenshots_and_upload
```

### App Store metadata

Fastlane is also configured for localized App Store metadata (name, subtitle, description, keywords, release notes, URLs, review info).

Pull the current metadata from App Store Connect into `fastlane/metadata`:

```bash
fastlane ios download_metadata
```

Upload metadata only (without build and without screenshots):

```bash
fastlane ios upload_metadata
```

Upload metadata and already-generated screenshots together:

```bash
fastlane ios upload_metadata_and_screenshots
```

Or generate fresh screenshots first, then upload both metadata and screenshots:

```bash
fastlane ios screenshots_and_upload_all_assets
```
