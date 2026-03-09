# Changelog

## [Unreleased]

### Added — Expose `currentLatency` and `latencies` (HESP state) in Flutter SDK and xnappet player state

#### Flutter SDK (`flutter-theoplayer-sdk`)

- **Pigeon bridge**: Added `HespLatencies` data class and two async methods (`currentLatency()`, `latencies()`) to `THEOplayerNativeTHEOliveAPI` host API.
- **Code generation**: Regenerated `apis.g.dart`, `APIs.g.swift`, and `APIs.g.kt` via pigeon.
- **Public API** (`theolive_api.dart`): Added `HespLatencies` class with fields `engineLatency`, `distributionLatency`, `playerLatency`, `theoliveLatency`. Added `Future<double?> get currentLatency` and `Future<HespLatencies?> get latencies` to the `THEOlive` abstract class.
- **Internal API** (`theolive_internal_api.dart`): Added matching getters to `THEOliveInternalInterface`.
- **Wrapper** (`theolive_wrapper.dart`): Implemented both getters in `THEOliveAPIHolder`, delegating to the internal API.
- **Mobile controller** (`theolive_controller_mobile.dart`): Implemented both getters, calling pigeon host API and mapping pigeon `HespLatencies` to the public Dart type.
- **iOS native bridge** (`THEOliveBridge.swift`): Implemented `currentLatency()` and `latencies()` by reading from the native THEOlive SDK.
- **Android native bridge** (`THEOliveBridge.kt`): Stubbed both methods returning `null` (Android does not expose HESP latencies natively).

### Fixed — Duplicate `HespLatencies` class conflict

- **`theoplayer.dart`**: Added `hide HespLatencies` to the `apis.g.dart` export to avoid conflict with the public `HespLatencies` in `theolive_api.dart`. Both files were being re-exported, causing a duplicate symbol error.
- **`theolive_controller_mobile.dart`**: Added `hide HespLatencies` on the `apis.g.dart` import and a prefixed `pigeon show HespLatencies` import, so the controller can distinguish between the pigeon-generated type and the public API type.

### Fixed — Web build failure: missing `currentLatency` and `latencies` in `THEOliveControllerWeb`

- **`theoplayer_api_web.dart`**: Added `currentLatency` and `latencies` JS interop bindings to `THEOplayerTheoLiveApiExtension`. Added `HespLatenciesJS` interop type with extension exposing `engineLatency`, `distributionLatency`, `playerLatency`, `theoliveLatency`.
- **`theolive_controller_web.dart`**: Implemented `currentLatency` and `latencies` overrides, bridging from JS types to Dart. Added `hide HespLatencies` on the `apis.g.dart` import and imported `theolive_api.dart` to resolve the duplicate symbol conflict.

### (Parked this fix and used track.activeQuality in the Xnappet app instead) Fixed — Stale `isEnabled` cache for audio/video tracks on Android

On Android, `isEnabled` is `false` when the ADDTRACK event fires but becomes `true` shortly after (once playback starts). The Flutter SDK cached `isEnabled` at ADDTRACK time and never updated it, causing it to remain stale. iOS reports `true` from the start so was unaffected.

The primary fix: pass `isEnabled` through `onActiveQualityChange` (which fires reliably when playback starts and `isEnabled` is already `true`). Also added `isEnabled` to `onVideoTrackListChange` / `onAudioTrackListChange` as a secondary path.

- **Pigeon definitions** (`theoplayer_flutter_videotracks_bridge.dart`, `theoplayer_flutter_audiotracks_bridge.dart`): Added `bool isEnabled` parameter to `onVideoTrackListChange`, `onAudioTrackListChange`, and `onActiveQualityChange`.
- **Code generation**: Regenerated `apis.g.dart`, `APIs.g.kt`, and `APIs.g.swift` via pigeon.
- **Track impls** (`theoplayer_videotrack_impl.dart`, `theoplayer_audiotrack_impl.dart`): Added `updateCachedIsEnabled(bool)` method to `VideoTrackImpl` and `AudioTrackImpl` to update the cached value without triggering a redundant native `setEnabled` call back.
- **Flutter API impls** (`theoplayer_flutter_videotracks_api.dart`, `theoplayer_flutter_audiotracks_api.dart`): Updated `onActiveQualityChange`, `onVideoTrackListChange` / `onAudioTrackListChange` to accept `isEnabled` and call `updateCachedIsEnabled` before dispatching events.
- **Android bridges** (`VideoTrackBridge.kt`, `AudioTrackBridge.kt`): Pass `track.isEnabled` in the `onActiveQualityChange`, `onVideoTrackListChange` / `onAudioTrackListChange` calls.
- **iOS bridges** (`VideoTrackBridge.swift`, `AudioTrackBridge.swift`): Pass track `enabled` state in `onActiveQualityChange` and trackListChange calls.

#### Web track lists not populated

- **`theoplayer_videotracklist_impl_web.dart`**: Added initial population loop in constructor to read pre-existing video tracks from the JS player, since `ADDTRACK` events only fire for tracks added *after* the listener is attached.
- **`theoplayer_audiotracklist_impl_web.dart`**: Same fix for audio tracks.

#### Nullable quality properties crash on web (`Null is not a subtype of int`)

##### Flutter SDK (`flutter-theoplayer-sdk`)

- **`theoplayer_api_web.dart`**: Made JS interop quality properties nullable (`bandwidth`, `averageBandwidth`, `name`, `codecs`, `audioSamplingRate`, `width`, `height`, `frameRate`, `firstFrame`) since the web JS player can return `null`/`undefined` for these fields.
- **`transformers_web.dart`**: Default null values to `0` in `toFlutterAudioQuality` and `toFlutterVideoQuality` when constructing `AudioQualityImpl`/`VideoQualityImpl`.
