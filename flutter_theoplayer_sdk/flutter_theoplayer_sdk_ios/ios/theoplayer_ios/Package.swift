// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "theoplayer_ios",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        // Flutter requires the product name to be the plugin name with hyphens instead of underscores.
        .library(name: "theoplayer-ios", targets: ["theoplayer_ios"])
    ],
    dependencies: [
        // Must match the native SDK versions in theoplayer_ios.podspec. Updated by scripts/update_theoplayer_native.sh
        // and verified by scripts/check_ios_dependency_versions.sh, so keep this declaration on a single line.
        .package(url: "https://github.com/THEOplayer/theoplayer-sdk-apple", exact: "11.14.0"),
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "theoplayer_ios",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "THEOplayerSDK", package: "theoplayer-sdk-apple"),
                .product(name: "THEOplayerTHEOliveIntegration", package: "theoplayer-sdk-apple")
            ]
        )
    ]
)
