fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios screenshots

```sh
[bundle exec] fastlane ios screenshots
```

Generate localized App Store screenshots

### ios upload_screenshots

```sh
[bundle exec] fastlane ios upload_screenshots
```

Upload existing screenshots to App Store Connect

### ios download_metadata

```sh
[bundle exec] fastlane ios download_metadata
```

Download App Store metadata into fastlane/metadata

### ios upload_metadata

```sh
[bundle exec] fastlane ios upload_metadata
```

Upload App Store metadata without uploading a build

### ios upload_metadata_and_screenshots

```sh
[bundle exec] fastlane ios upload_metadata_and_screenshots
```

Upload App Store metadata and existing screenshots

### ios screenshots_and_upload

```sh
[bundle exec] fastlane ios screenshots_and_upload
```

Generate and upload screenshots to App Store Connect

### ios screenshots_and_upload_all_assets

```sh
[bundle exec] fastlane ios screenshots_and_upload_all_assets
```

Generate screenshots, then upload metadata and screenshots

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
