# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Flutter SDK for THEOplayer video player. Melos-managed monorepo using the **federated plugin architecture** pattern with five packages all versioned together (currently 10.6.1):

- **`theoplayer`** (`flutter_theoplayer_sdk/flutter_theoplayer_sdk/`) — Main aggregator package, exports the `THEOplayer` widget
- **`theoplayer_platform_interface`** (`flutter_theoplayer_sdk/flutter_theoplayer_sdk_platform_interface/`) — Shared API definitions, Pigeon-generated native bindings
- **`theoplayer_android`** (`flutter_theoplayer_sdk/flutter_theoplayer_sdk_android/`) — Android implementation (Kotlin)
- **`theoplayer_ios`** (`flutter_theoplayer_sdk/flutter_theoplayer_sdk_ios/`) — iOS implementation (Swift)
- **`theoplayer_web`** (`flutter_theoplayer_sdk/flutter_theoplayer_sdk_web/`) — Web implementation (Dart + JS interop)

Example app: `flutter_theoplayer_sdk/flutter_theoplayer_sdk/example/`

## Common Commands

```bash
# Setup workspace (required after clone)
melos bootstrap

# Static analysis (all packages)
melos run analyze
# or in a single package:
dart analyze

# Format (200 char line limit, NOT default 80)
dart format -l 200

# Run unit tests (in the main package directory)
cd flutter_theoplayer_sdk/flutter_theoplayer_sdk && flutter test

# Run integration tests - Android/iOS (in example directory)
cd flutter_theoplayer_sdk/flutter_theoplayer_sdk/example && flutter test integration_test

# Run integration tests - Web (requires chromedriver on port 4444)
cd flutter_theoplayer_sdk/flutter_theoplayer_sdk/example && \
  flutter drive --driver=webdriver_integration_test/webdriver.dart \
  --target=integration_test_single_entrypoint/entrypoint.dart \
  -d web-server --profile --driver-port=4444

# Update all package versions
VERSION=<version> melos run update:theoplayer:flutter

# Update native SDK versions
./scripts/update_theoplayer_native.sh --all <version>
# or per-platform: --android <ver> --ios <ver> --web <ver>
```

## Architecture

### Pigeon Code Generation

The platform interface uses **Pigeon** for type-safe Flutter-to-native communication. Pigeon files live in `flutter_theoplayer_sdk_platform_interface/pigeon/`. The file `pigeons_merged.dart` is **auto-generated** — never edit it directly.

To regenerate after modifying pigeon files:
```bash
cd flutter_theoplayer_sdk/flutter_theoplayer_sdk_platform_interface
dart run build_runner build --delete-conflicting-outputs
```

This merges pigeon files and generates platform-specific bindings (Kotlin, Swift).

### Native SDK Dependencies

- **Android**: `com.theoplayer.theoplayer-sdk-android:core` from `maven.theoplayer.com/releases` (min SDK 23, compile SDK 36)
- **iOS**: `THEOplayerSDK-core` + `THEOplayer-Integration-THEOlive` via CocoaPods (iOS 13.0+, Swift 5.0)
- **Web**: THEOplayer JS SDK downloaded from npm registry, served as web assets

### Key Environment Requirements

- Dart SDK: `^3.3.0`, Flutter: `>=3.19.0`
- Xcode 16.2 (iOS builds)
- A THEOplayer license from portal.theoplayer.com may be required for feature-specific development. The example app license only allows streams from localhost or theoplayer.com domains.
