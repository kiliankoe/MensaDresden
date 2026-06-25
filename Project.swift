import ProjectDescription

let appVersion = "2026.4"
// Baseline only — must be numeric (CFBundleVersion can't be "dev"). The release
// lane overrides this per build via CURRENT_PROJECT_VERSION (see fastlane/Fastfile).
let appBuildNumber = "1"
let uiTestVersion = "1.0"
let uiTestBuildNumber = "1"

let developmentTeam = "HU85FER47E"
let swiftVersion = "5.0"

let appBundleId = "io.kilian.MensaDresden"
let watchBundleId = "\(appBundleId).watchkitapp"

let appDeploymentTarget = "16.0"
let uiTestDeploymentTarget = "15.2"
let watchDeploymentTarget = "8.5"

let sharedSettings: SettingsDictionary = [
    "DEVELOPMENT_TEAM": .string(developmentTeam),
    "SWIFT_VERSION": .string(swiftVersion),
]

let appSettings = sharedSettings.merging([
    "ASSETCATALOG_COMPILER_APPICON_NAME": "Icon",
    "ASSETCATALOG_COMPILER_INCLUDE_ALL_APPICON_ASSETS": "YES",
    "CURRENT_PROJECT_VERSION": .string(appBuildNumber),
    "DEVELOPMENT_ASSET_PATHS": "\"MensaDresden/Preview Content\"",
    "IPHONEOS_DEPLOYMENT_TARGET": .string(appDeploymentTarget),
    "LD_RUNPATH_SEARCH_PATHS": [
        "$(inherited)",
        "@executable_path/Frameworks",
    ],
    "MARKETING_VERSION": .string(appVersion),
    "PRODUCT_BUNDLE_IDENTIFIER": .string(appBundleId),
    "PRODUCT_NAME": "Mensa Dresden",
    "SUPPORTS_MACCATALYST": "NO",
    "TARGETED_DEVICE_FAMILY": "1,2",
]) { _, new in new }

let watchSettings = sharedSettings.merging([
    "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
    "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "AccentColor",
    "CURRENT_PROJECT_VERSION": .string(appBuildNumber),
    "MARKETING_VERSION": .string(appVersion),
    "PRODUCT_BUNDLE_IDENTIFIER": .string(watchBundleId),
    "PRODUCT_NAME": "MensaDD",
    "SDKROOT": "watchos",
    "SKIP_INSTALL": "YES",
    "SWIFT_EMIT_LOC_STRINGS": "YES",
    "TARGETED_DEVICE_FAMILY": "4",
    "WATCHOS_DEPLOYMENT_TARGET": .string(watchDeploymentTarget),
]) { _, new in new }

let uiTestSettings = sharedSettings.merging([
    "CURRENT_PROJECT_VERSION": .string(uiTestBuildNumber),
    "IPHONEOS_DEPLOYMENT_TARGET": .string(uiTestDeploymentTarget),
    "MARKETING_VERSION": .string(uiTestVersion),
    "SWIFT_EMIT_LOC_STRINGS": "NO",
    "TARGETED_DEVICE_FAMILY": "1,2",
]) { _, new in new }

let project = Project(
    name: "MensaDresden",
    organizationName: "Kilian Koeltzsch",
    options: .options(automaticSchemesOptions: .disabled),
    packages: [
        .remote(url: "https://github.com/TelemetryDeck/SwiftClient", requirement: .upToNextMajor(from: "2.9.4")),
        .remote(url: "https://github.com/Jake-Short/swiftui-image-viewer.git", requirement: .upToNextMajor(from: "2.0.0")),
        .remote(url: "https://github.com/objcio/keychain-item", requirement: .upToNextMajor(from: "0.1.0")),
        .remote(url: "https://github.com/brightdigit/SyndiKit.git", requirement: .upToNextMajor(from: "0.2.0")),
        .remote(url: "https://github.com/MaxHaertwig/SwiftyHolidays", requirement: .upToNextMajor(from: "1.0.0")),
        .remote(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", requirement: .upToNextMajor(from: "4.2.2")),
        .remote(url: "https://github.com/kiliankoe/EmealKit.git", requirement: .upToNextMajor(from: "0.12.0")),
    ],
    settings: .settings(
        base: [
            "DEVELOPMENT_TEAM": .string(developmentTeam),
        ],
        defaultSettings: .recommended
    ),
    targets: [
        .target(
            name: "MensaDresden",
            destinations: .iOS,
            product: .app,
            bundleId: appBundleId,
            deploymentTargets: .iOS(appDeploymentTarget),
            infoPlist: .file(path: "MensaDresden/Info.plist"),
            sources: ["MensaDresden/**/*.swift"],
            resources: [
                "MensaDresden/Assets.xcassets",
                "MensaDresden/Icon.icon",
                "MensaDresden/Base.lproj/LaunchScreen.storyboard",
                "MensaDresden/Preview Content/Preview Assets.xcassets",
                "MensaDresden/*.lproj/InfoPlist.strings",
                "MensaDresden/*.lproj/Localizable.strings",
                "MensaDresden/Resources/FixtureMealImages/**",
            ],
            entitlements: .file(path: "MensaDresden/Mensa Dresden.entitlements"),
            dependencies: [
                .target(name: "MensaDresdenWatch"),
                .package(product: "TelemetryClient"),
                .package(product: "ImageViewerRemote"),
                .package(product: "KeychainAccess"),
                .package(product: "SwiftyHolidays"),
                .package(product: "SyndiKit"),
                .package(product: "KeychainItem"),
                .package(product: "EmealKit"),
            ],
            settings: .settings(base: appSettings)
        ),
        .target(
            name: "MensaDresdenWatch",
            destinations: [.appleWatch],
            product: .app,
            bundleId: watchBundleId,
            deploymentTargets: .watchOS(watchDeploymentTarget),
            infoPlist: .extendingDefault(with: [
                // Versions must match the companion app; reference the same build
                // settings instead of Tuist's literal "1.0"/"1" defaults.
                "CFBundleShortVersionString": .string("$(MARKETING_VERSION)"),
                "CFBundleVersion": .string("$(CURRENT_PROJECT_VERSION)"),
                // Single-target watchOS app (no separate WatchKit extension).
                "WKApplication": .boolean(true),
                "WKCompanionAppBundleIdentifier": .string(appBundleId),
            ]),
            sources: [
                "MensaDresdenWatch WatchKit Extension/AppView.swift",
                "MensaDresdenWatch WatchKit Extension/CanteenList/CanteenListView.swift",
                "MensaDresdenWatch WatchKit Extension/MealList/MealCell.swift",
                "MensaDresdenWatch WatchKit Extension/MealList/MealDetailView.swift",
                "MensaDresdenWatch WatchKit Extension/MealList/MealImage.swift",
                "MensaDresdenWatch WatchKit Extension/MealList/MealList.swift",
                "MensaDresdenWatch WatchKit Extension/MealList/MealListView.swift",
                "MensaDresdenWatch WatchKit Extension/MealList/PriceLabel.swift",
                "MensaDresdenWatch WatchKit Extension/MensaDresdenApp.swift",
                "MensaDresdenWatch WatchKit Extension/SettingsView/IngredientsAllergensSetting.swift",
                "MensaDresdenWatch WatchKit Extension/SettingsView/SettingsView.swift",
                "MensaDresden/API/API.swift",
                "MensaDresden/API/AppDataMode.swift",
                "MensaDresden/API/Canteen+Example.swift",
                "MensaDresden/API/FixtureData.swift",
                "MensaDresden/API/LoadingResult.swift",
                "MensaDresden/API/Meal+Extensions.swift",
                "MensaDresden/EmealView/CardserviceErrorWrapper.swift",
                "MensaDresden/Extensions/Binding.swift",
                "MensaDresden/Extensions/Color.swift",
                "MensaDresden/Extensions/Date.swift",
                "MensaDresden/Extensions/Logger.swift",
                "MensaDresden/Extensions/Meal.swift",
                "MensaDresden/Extensions/Transaction.swift",
                "MensaDresden/Extensions/UserDefaults.swift",
                "MensaDresden/Extensions/View.swift",
                "MensaDresden/L10n.swift",
                "MensaDresden/SettingsView/Settings.swift",
                "MensaDresden/Shared/Analytics.swift",
                "MensaDresden/Shared/BlacklistBinding.swift",
                "MensaDresden/Shared/Formatter.swift",
                "MensaDresden/Shared/LoadingListView.swift",
                "MensaDresden/Shared/LocationManager.swift",
                "MensaDresden/Shared/TranslationService.swift",
                "MensaDresden/Shared/UserDefault.swift",
            ],
            resources: [
                "MensaDresdenWatch/Assets.xcassets",
                "MensaDresdenWatch WatchKit Extension/Preview Content/Preview Assets.xcassets",
                "MensaDresden/*.lproj/Localizable.strings",
            ],
            entitlements: .file(path: "MensaDresdenWatch/MensaDresdenWatch.entitlements"),
            dependencies: [
                .package(product: "KeychainAccess"),
                .package(product: "SwiftyHolidays"),
                .package(product: "TelemetryClient"),
                .package(product: "KeychainItem"),
                .package(product: "EmealKit"),
            ],
            settings: .settings(base: watchSettings)
        ),
        .target(
            name: "UITests",
            destinations: .iOS,
            product: .uiTests,
            bundleId: "io.kilian.MensaDresden.UITests",
            deploymentTargets: .iOS(uiTestDeploymentTarget),
            infoPlist: .default,
            sources: [
                "UITests/UITests.swift",
                "UITests/App+Interaction.swift",
            ],
            dependencies: [
                .target(name: "MensaDresden"),
            ],
            settings: .settings(base: uiTestSettings)
        ),
        .target(
            name: "Screenshots",
            destinations: .iOS,
            product: .uiTests,
            bundleId: "io.kilian.MensaDresden.Screenshots",
            deploymentTargets: .iOS(uiTestDeploymentTarget),
            infoPlist: .default,
            sources: [
                "Screenshots/Screenshots.swift",
                "SnapshotHelper.swift",
                "UITests/App+Interaction.swift",
            ],
            dependencies: [
                .target(name: "MensaDresden"),
            ],
            settings: .settings(base: uiTestSettings)
        ),
    ],
    schemes: [
        .scheme(
            name: "MensaDresden",
            shared: true,
            buildAction: .buildAction(targets: ["MensaDresden"]),
            testAction: .targets(
                [
                    .testableTarget(target: "UITests"),
                    .testableTarget(target: "Screenshots"),
                ],
                options: .options(language: "de", coverage: true, codeCoverageTargets: ["MensaDresden"])
            ),
            runAction: .runAction(
                executable: "MensaDresden",
                options: .options(language: "de")
            ),
            archiveAction: .archiveAction(configuration: .release),
            profileAction: .profileAction(configuration: .release, executable: "MensaDresden"),
            analyzeAction: .analyzeAction(configuration: .debug)
        ),
        .scheme(
            name: "Screenshots",
            shared: true,
            buildAction: .buildAction(targets: ["Screenshots"]),
            testAction: .targets([
                .testableTarget(target: "Screenshots"),
            ]),
            archiveAction: .archiveAction(configuration: .release),
            profileAction: .profileAction(configuration: .release, executable: "Screenshots"),
            analyzeAction: .analyzeAction(configuration: .debug)
        ),
    ],
    resourceSynthesizers: []
)
