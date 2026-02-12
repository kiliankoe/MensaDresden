<h1>Mensa Dresden
<img src="https://user-images.githubusercontent.com/2625584/66001401-b2137d00-e4a1-11e9-919a-edb5c9635ec0.png" align="right" width="128" />
</h1>

Looking to see what's for lunch today?

<a href="https://apps.apple.com/us/app/mensa-dresden/id1481891701?ls=1"><img src="https://user-images.githubusercontent.com/2625584/67429359-4b850900-f5e0-11e9-8c0f-467dd638b556.png" alt="app store" width="160"></a>

Want to help by translating the app into your language? Look [here](https://poeditor.com/join/project/qAgTstzLia), thank you!

If you're interested in how this app communicates with the Studentenwerk Dresden server to fetch meal information, your recent Emeal transactions or how it reads your Emeal balance via NFC, check out [EmealKit](https://github.com/kiliankoe/emealkit).

![Screenshots](https://user-images.githubusercontent.com/2625584/148906162-fbdffcb3-da3c-447b-8291-85d907238d58.png)

## Development setup (Tuist)

This repository uses [Tuist](https://tuist.dev) manifests (`Project.swift`) instead of manually editing the Xcode project file.

### Generate the project

```bash
tuist generate
```

This opens `MensaDresden.xcworkspace` in Xcode.

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

### App Store screenshots

Fastlane is configured for automated localized screenshots using the `Screenshots` UI test target.

```bash
fastlane ios screenshots
```

This generates fresh screenshots in `appstore_screenshots` for:

- iPhone 17 Pro Max (6.9")
- iPhone 11 Pro Max (6.5")
- iPhone 8 Plus (5.5")
- iPad Pro 13-inch (M4)

across these locales: `en-US`, `de-DE`, `ja`, `ru`, `zh-Hans`.

To upload screenshots to App Store Connect (without uploading a build or metadata):

```bash
fastlane ios upload_screenshots
```

Or generate and upload in one go:

```bash
fastlane ios screenshots_and_upload
```
