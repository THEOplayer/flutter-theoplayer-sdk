# Backlog: Tracks & Qualities — React Native vs Flutter SDK Differences

## Tracks & Qualities: React Native vs Flutter SDK

### 1. Quality Model Differences

| Property | React Native | Flutter |
|----------|-------------|---------|
| `averageBandwidth` | Present on `Quality` | **Missing** |
| `available` (DRM) | Present on `Quality` | **Missing** |
| `label` (settable) | Settable on `Quality` | Read-only (`name`) |
| `audioSamplingRate` type | `number \| [number, number]` (supports range) | `int` only |

### 2. Track Model Differences

| Feature | React Native | Flutter |
|---------|-------------|---------|
| `unlocalizedLabel` | Present on MediaTrack and TextTrack (iOS manifest label, added Jun 2025) | **Missing** |
| `DateRangeCue` | Dedicated type with `startDate`, `endDate`, `duration`, `plannedDuration`, `class`, `customAttributes`, SCTE-35 markers | **Missing** — cues only have `id`, `uid`, `startTime`, `endTime`, `content` (string) |
| `TextTrackStyle` | Full styling API: font family/color/size/path, background color, window color, edge color/style, margins | **Missing entirely** |
| `TextTrackCue.content` | `any` type (format depends on track type) | `String` only |

### 3. API Surface Differences

| Capability | React Native | Flutter |
|------------|-------------|---------|
| Track selection | `player.selectedAudioTrack = uid` (by uid directly) | `track.isEnabled = true` (on the track object) |
| Video quality target | `player.targetVideoQuality = uid \| uid[]` (player-level) | `track.targetQuality` / `track.targetQualities` (track-level) |
| Text track mode | Implicit via `selectedTextTrack = uid` | Explicit `track.setMode(TextTrackMode)` with 3 modes (disabled/hidden/showing) |

The Flutter SDK has a **more object-oriented** approach (operate on track/quality objects directly), while React Native uses a **uid-based** approach (set uids on the player).

### 4. iOS Quality Support

| Aspect | React Native | Flutter |
|--------|-------------|---------|
| Quality info from iOS | **Supported** — qualities are bridged with full metadata, `activeQuality` reported (recently refactored Nov 2025 to pass as single object) | **Not supported** — `setTargetQuality`/`setTargetQualities` are **no-ops** on iOS, quality events not forwarded |

This is a significant gap. The RN SDK recently improved iOS quality bridging (commits `cb79e407`, `fa4b3cbe`) to extract quality info directly from `ActiveQualityChangedEvent`, while the Flutter iOS bridge explicitly skips qualities.

### 5. Event System Differences

| Event | React Native | Flutter |
|-------|-------------|---------|
| `TARGET_QUALITY_CHANGED` | Present on Android only (`MediaTrackEventType`) | Present on both platforms (Pigeon API defined) |
| Quality `UPDATE` event | Not present | **Present** — `AudioQualityUpdateEvent` / `VideoQualityUpdateEvent` for quality property changes |
| Cue events | `ADD_CUE`, `REMOVE_CUE`, `ENTER_CUE`, `EXIT_CUE` | Same + `CUECHANGE`, `CueUpdateEvent` (more granular) |

### 6. Missing in Flutter (features present in RN)

1. **`TextTrackStyle`** — No subtitle styling API (font, color, edge, margins)
2. **`DateRangeCue`** — No HLS date range / SCTE-35 metadata support in cue model
3. **`unlocalizedLabel`** — No manifest-level label passthrough from iOS
4. **`Quality.available`** — No DRM availability flag on qualities
5. **`Quality.averageBandwidth`** — Missing average bandwidth property
6. **iOS quality bridging** — Qualities are entirely unavailable on iOS
7. **Rich cue content** — Cue content is string-only, not arbitrary typed data

### 7. Missing in React Native (features present in Flutter)

1. **Quality `UPDATE` events** — Flutter can notify when quality properties change dynamically
2. **`TextTrackReadyState`** — Flutter exposes `none|loading|loaded|error` state on text tracks
3. **Granular `CueUpdate` events** — Flutter has `onCueUpdate` with changed `endTime`/`content`
4. **`hidden` text track mode** — Flutter explicitly supports 3 modes; RN only toggles selected/deselected

### Key Takeaway

The biggest gaps in the Flutter SDK compared to RN are: **no TextTrackStyle**, **no iOS quality support**, **no DateRangeCue/SCTE-35**, and **no `unlocalizedLabel`**. The RN SDK's recent iOS quality bridging refactor (Nov 2025) is particularly notable — the Flutter SDK should consider similar work.

## Analysis: Can 10.6.1-updates be applied to 9.3.3?

**Date:** 2026-03-04

**Short answer: No, not as a clean cherry-pick.** The first commit already produces 6 conflicts.

### Feature commits analyzed (excluding version bumps):

| Commit | Description | Files |
|--------|-------------|-------|
| `8ef8498` | Add tracks and qualities | 25 files |
| `8436d47` | Intent to fallback | 12 files |
| `32bc2de` | Expose latencies | 14 files |
| `f5b4a53` | Changes for web | 5 files |
| `aa3247f` | Handle stop in web | 1 file |

### Why it fails — 6 conflicting files on the first commit alone:

1. **Pigeon-generated files (3 files — Critical):** `APIs.g.kt`, `APIs.g.swift`, `apis.g.dart` — The 10.6.1 branch uses a newer Pigeon version (v12.0.1) with different variable naming (`channel` → `pigeonVar_channel`), error types (`FlutterError` → `PigeonError`), and channel suffix handling. These are auto-generated and can't be manually merged.

2. **iOS bridge implementations (2 files):** `AudioTrackBridge.swift`, `VideoTrackBridge.swift` — New track-level event listener management and quality enumeration don't exist in 9.3.3.

3. **Android build.gradle:** compileSdk 35→36, NDK 27→29, minSdk changed from hardcoded to Flutter reference.

### Root causes of incompatibility:

- **Pigeon version gap** between 9.3.3 and 10.6.1 produces fundamentally different generated code
- **New API surface** (tracks, qualities, DateRange cues) that 9.3.3's Pigeon schema doesn't define
- **Platform SDK bumps** (Android SDK 36, NDK 29)

### Recommended alternatives:

1. **Manual port**: Branch from 9.3.3, manually implement the business logic for each feature, then regenerate Pigeon for that branch's Pigeon version.
2. **Web-only commits**: `f5b4a53` and `aa3247f` (web changes) may apply more cleanly since they don't touch Pigeon-generated code — worth trying those individually.
3. **Forward-port instead**: Upgrade the 9.3.3 consumer to 10.6.1 rather than backporting features.