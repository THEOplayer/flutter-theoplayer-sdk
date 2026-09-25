// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "theoplayer_ios",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(name: "theoplayer-ios", targets: ["theoplayer_ios"])
    ],
    dependencies: [
        .package(url: "https://github.com/THEOplayer/theoplayer-sdk-apple", exact: "11.10.0"),
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
