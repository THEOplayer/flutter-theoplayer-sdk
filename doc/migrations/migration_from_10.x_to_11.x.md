# Migration Guide: From THEOplayer Flutter SDK 10.x to 11.x

This guide covers the breaking changes introduced by updating the underlying native THEOplayer SDKs to 11.1.0.

## Overview

Most of the Dart API surface is unchanged. Migrating consists of:

1. Removing the OptiView Live preloading calls (removed from the native SDKs).
2. Raising the iOS deployment target of your app to 15.0.
3. Building your iOS app with Xcode 26 or later.

## Breaking Changes

### 1. OptiView Live (THEOlive) preloading removed

`preloadChannels` (Android, iOS) and `preloadPublications` (web) were removed from the native OptiView Live APIs, so the Flutter wrapper drops the corresponding methods as well. There is no replacement: the stream is loaded when the source is set on the player.

**Before:**
```dart
// preload channels for faster startup
player.theoLive?.preloadChannels(["38yyniscxeglzr8n0lbku57b0"]);

player.source = SourceDescription(sources: [
    TheoLiveSource(src: "38yyniscxeglzr8n0lbku57b0"),
]);
```

**After:**
```dart
player.source = SourceDescription(sources: [
    TheoLiveSource(src: "38yyniscxeglzr8n0lbku57b0"),
]);
```

### 2. Update iOS toolchain

- THEOplayer iOS SDK 11.0.0 dropped support for iOS 13 and 14. Set the deployment target to 15.0 or higher.
- Building an app that uses this Flutter SDK therefore requires **Xcode 26 or later** and a macOS version supporting it.

## What Remains Unchanged

- The rest of the THEOlive API

## Rationale

These changes were made to:
- **Align with THEOplayer 11.1.0**: the Flutter SDK version is locked to the native SDK version
- **Follow Apple's tooling requirements**: iOS 15+ and Xcode 26 are required by the native iOS SDK
- **Drop unsupported APIs**: the THEOlive preloading APIs no longer exist in the native SDKs

## Need Help?

If you encounter issues during migration or have questions about the new API, please:
1. Check the updated documentation in `doc/theolive.md`
2. Review the example app for working code samples
3. Consult the [THEOplayer 11.0.0](https://optiview.dolby.com/docs/theoplayer/changelog/#-1100-20260416) and [11.1.0](https://optiview.dolby.com/docs/theoplayer/changelog/#-1110-20260428) native changelogs
4. Open an issue in the repository with specific migration questions
