# Agent Instructions — THEOplayer Flutter SDK

Guidance for AI coding agents (and new contributors) working in this repository.
Read [doc/architecture.md](doc/architecture.md) for how the SDK is structured and
[CONTRIBUTING.md](CONTRIBUTING.md) for the feature workflow before making changes.

## Repository shape

- Melos monorepo: 5 pub packages under `flutter_theoplayer_sdk/` + the `example` app.
- This is a **federated plugin wrapping the native THEOplayer SDKs** — playback logic
  lives in the native players, not here. Don't try to implement player behavior in Dart.
- The Flutter SDK version is locked to the native THEOplayer version.

## Setup (required before anything works)

```bash
dart pub global activate melos
melos bootstrap   # creates pubspec_overrides.yaml linking local packages
```

## Hard rules

1. **Never hand-edit generated files**: `lib/pigeon/apis.g.dart`, `APIs.g.kt`,
   `APIs.g.swift`, `pigeons/pigeons_merged.dart`. Source of truth is
   `flutter_theoplayer_sdk_platform_interface/pigeons/` (models + apis).
2. **After changing pigeon definitions**, regenerate and **commit the generated files**
   (they are checked into git):
   ```bash
   # from flutter_theoplayer_sdk/flutter_theoplayer_sdk_platform_interface/
   dart run build_runner build --delete-conflicting-outputs
   ```
3. **Don't rename `theopalyer_config.dart` or `TheoplayerPlatform.initalize()` as a
   drive-by fix.** The typos are known. Fixing them is possible but requires a
   coordinated rename in a dedicated PR: the umbrella export in `theoplayer.dart`,
   the caller in `theoplayer_view.dart`, and the overrides in all 3 platform
   packages (`theoplayer_android`, `theoplayer_ios`, `theoplayer_web`) must change
   together, and it is strictly a breaking change for `theoplayer_platform_interface`
   consumers outside this monorepo.
4. **Never bump package versions manually.** The 5 packages version in lockstep via
   `VERSION=x.y.z melos run update:theoplayer:flutter`.
5. **Cross-platform parity**: a feature is not done until it works on Android + iOS
   (pigeon bridges) **and** web (`dart:js_interop` — web bypasses pigeon entirely).
   Follow the step-by-step recipe in [CONTRIBUTING.md](CONTRIBUTING.md).

## Style & checks

- Format with `dart format -l 200 .` — this repo uses 200-char lines, not 80.
- `melos run analyze` must pass with no issues (`--fatal-infos`).

## Testing

- Integration tests live in `flutter_theoplayer_sdk/flutter_theoplayer_sdk/example/integration_test/`
  and are the real test coverage (unit tests are thin).
- **Web CI gotcha**: tests must also be registered in
  `example/integration_test_single_entrypoint/entrypoint.dart`, otherwise they
  silently won't run on web CI.
- Run locally: `flutter test` (unit), `flutter test integration_test` (from `example/`,
  device required). Web driver setup is described in [CONTRIBUTING.md](CONTRIBUTING.md).
- Playback of non-theoplayer.com streams requires a THEOplayer license
  (https://portal.theoplayer.com).

## Branch conventions

`feature/*`, `bugfix/*`, `experimental/*`, `poc/*` (public sample forks), `release/x.y.z`.
PRs target `develop` for regular work.
