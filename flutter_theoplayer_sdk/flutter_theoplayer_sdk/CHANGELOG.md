## 10.0.0

* Updated THEOplayer to 10.0.0.
  - For underlying native SDK changes please consult with the [THEOplayer SDK 10.0.0 changelog](https://optiview.dolby.com/docs/theoplayer/changelog/#-1000-20250912)).
  - Android: Updated Kotlin version to 2.2.10 (to match with THEOplayer Android SDK).
  - Android: Updated Gradle version to 8.13.0.
  - Android: Update minSdkVersion to 23.
  - Android: Update compileSdkVersion to 36.
* Added **experimental** WASM compilation support for web builds.
* **BREAKING CHANGE**: Renamed all "publication"-related APIs to "distribution" for consistency with THEOplayer native SDKs:
	- **State Management**: `PublicationState` → `DistributionState`, `publicationState` → `distributionState`
	- **Event Types**: `PUBLICATIONLOADSTART` → `DISTRIBUTIONLOADSTART`, `PUBLICATIONLOADED` → `ENDPOINTLOADED`, `PUBLICATIONOFFLINE` → `DISTRIBUTIONOFFLINE`
	- **Event Classes**: `PublicationLoadStartEvent` → `DistributionLoadStartEvent`, `PublicationLoadedEvent` → removed (replaced by `EndpointLoadedEvent`), `PublicationOfflineEvent` → `DistributionOfflineEvent`
	- **Event Parameters**: `event.publicationId` → `event.distributionId` in distribution events
* **BREAKING CHANGE**: Removed Android PlaybackPipeline configuration support:
	- **Removed**: `PlaybackPipeline` enum (`media3`, `legacy` options)
	- **Removed**: `AndroidTypedSourceConfiguration.playbackPipeline` parameter
	- **Default**: Media3 is now the only supported playback pipeline (legacy pipeline removed)

### Migration Notes
This release contains significant breaking changes that require code updates:

1. **THEOlive API Renaming**: All publication-related APIs have been renamed to distribution equivalents
2. **Android Configuration Simplification**: PlaybackPipeline configuration is no longer needed (Media3 is default)
3. **Event Parameter Changes**: Event handlers need to use `distributionId` instead of `publicationId`
4. **Class Name Updates**: Some event classes have been renamed for consistency

**Migration Required**: Existing code using THEOlive APIs will need updates to compile and function correctly.

For detailed migration instructions, automated find/replace patterns, and complete examples, see the [Migration Guide](https://github.com/THEOplayer/flutter-theoplayer-sdk/blob/main/doc/migrations/migration_from_9.x_to_10.x.md).

## 9.11.0

* Updated THEOplayer to 9.11.0.

## 9.7.1

* Added `TypedSource.type` property.
* Added `WebConfig.libraryLocation` to specify a different path for THEOplayer WEB SDK through `THEOplayerConfig`.

## 9.7.0

* Updated THEOplayer to 9.7.0.
* Added `TheoLiveConfiguration.discoveryUrl` to support custom discovery URLs for OptiView live streams (formerly known as THEOlive).

## 9.3.1

* Updated THEOplayer to 9.3.1.

## 9.3.0

* Updated THEOplayer to 9.3.0.
  - Fixed an issue where `THEOplayer.allowAutomaticPictureInPicture` was not respected after setting a source.

## 9.2.0

* Updated THEOplayer to 9.2.0.
* Added `TypedSource.headers` to set custom headers for requests (Applied on master playlist, media playlist and segment requests).
	- Supported only on Android (PlaybackPipeline.MEDIA3) and iOS.
* Fixed an issue where calling `player.dispose()` would not release resources properly on iOS.

## 9.0.0

* Updated THEOplayer to 9.0.0.
* Added `TypedSource.androidSourceConfiguration` to change playback pipelines on Android (legacy/media3)
* **BREAKING CHANGE**: Changed default media playback pipeline on Android
	- Starting from THEOplayer 9.0, the new Media3 Playback pipeline is now the default for all [Android SDK playback](https://www.theoplayer.com/docs/theoplayer/changelog/#-900-20250403).
	- The legacy playback pipeline from version 8.x is still available, and can be activated by setting `TypedSource.androidSourceConfiguration.playbackPipeline` to `PlaybackPipeline.LEGACY`.
	- The legacy playback pipeline is scheduled to be removed in version 10.
* Known issues:
	- Combining `AndroidViewComposition.SURFACE_PRODUCER` or `AndroidViewComposition.SURFACE_TEXTURE` with the new default pipeline doesn't play DRM (content protected) sources.
	- As a workaround please use `PlaybackPipeline.LEGACY` with these rendering engines, or `AndroidViewComposition.HYBRID_COMPOSITION` with `PlaybackPipeline.MEDIA3`.

## 8.14.0

* Updated THEOplayer to 8.14.0.

## 8.13.2

* Updated THEOplayer to 8.13.2.
* Added [THEOlive support](https://github.com/THEOplayer/flutter-theoplayer-sdk/blob/main/doc/theolive.md) for Android and iOS.
* Added `THEOplayer.isWaiting` state.
* Added experimental `THEOplayer.addAllEventListener(...)` to listen on all player events at once.

## 8.11.0

* Updated THEOplayer to 8.11.0.
* Added support for Flutter 3.29.0.

## 8.4.0

* Updated THEOplayer to 8.4.0.

## 8.3.0

* Updated THEOplayer to 8.3.0.
* Added [THEOlive support](https://github.com/THEOplayer/flutter-theoplayer-sdk/blob/main/doc/theolive.md) for Flutter WEB.
* Deprecated getX and setX methods on THEOplayer API in favor of properties.
* Added new properties on THEOplayer API. (`muted`, `played`, `buffered`, `videoTracks`, etc... for the full list check the API.)
* **BREAKING CHANGE**: Changed `THEOplayer.allowBackgroundPlayback()` to `THEOplayer.allowBackgroundPlayback`.
* **BREAKING CHANGE**: Changed `THEOplayer.allowAutomaticPictureInPicture()` to `THEOplayer.allowAutomaticPictureInPicture`.
* **BREAKING CHANGE**: Changed `THEOplayer.isEnded()` to `THEOplayer.isEnded`.
* **BREAKING CHANGE**: Changed `THEOplayer.isPlaying()` to `THEOplayer.isPlaying`.
* **BREAKING CHANGE**: Changed `THEOplayer.isSeeking()` to `THEOplayer.isSeeking`.

## 8.2.0

* Fixed an issue where play/pause buttons were not connected in the Picture-in-Picture window on Android.
* Updated THEOplayer to 8.2.0.
* Updated Kotlin version to 1.9.25 (to match with THEOplayer Android SDK)

## 8.0.0

* Updated THEOplayer to 8.0.0.
* Added Picture-in-Picture support with `THEOplayer.setPresentationMode(PresentationMode.PIP)` API for WEB and `THEOplayer.setAllowAutomaticPictureInPicture(bool)` for Android and iOS.
* Removed iOS 12 support. The minimum supported iOS version is now iOS 13.

## 7.12.0

* Updated THEOplayer to 7.12.0.

## 7.3.1

* Fixed an issue where playback failed with license error when using Texture-based (SURFACE_TEXTURE, SURFACE_PRODUCER) rendering.
* Fixed an issue where player lifecycle callbacks were triggered multiple times when using Texture-based (SURFACE_TEXTURE, SURFACE_PRODUCER) rendering.

## 7.3.0

* Updated THEOplayer to 7.3.0.
* Added `AndroidConfig.viewComposition` to support Texture-based rendering.
* Added `AndroidViewComposition.SURFACE_TEXTURE` to use SurfaceTexture on native Android (instead of PlatformViews).
* Added `AndroidViewComposition.SURFACE_PRODUCER` to use SurfaceProducer on native Android (instead of PlatformViews).
	- Only works from [Flutter 3.22.0](https://docs.flutter.dev/release/breaking-changes/android-surface-plugins#timeline)
	- Supports [Texture-based rendering with Impeller](https://docs.flutter.dev/release/breaking-changes/android-surface-plugins#summary) rendering engine
* Added Support for continuing playback when transitioning the app into background with `THEOplayer.setAllowBackgroundPlayback(boolean)`.
* Added Fullscreen support with `THEOplayer.setPresentationMode(PresentationMode)`.
* Deprecated `AndroidConfig.useHybridComposition` in favor of `AndroidConfig.viewComposition` (use `AndroidViewComposition.HYBRID_COMPOSITION` for the previous behaviour).

## 7.0.0

* Updated THEOplayer to 7.0.0.

### Versioning changes
We are updating the version numbering for THEOplayer Flutter SDK to more closely match the underlying native THEOplayer SDKs.

Here are the notable changes:
- The **major** version will be matching the underlying native SDK major version.
- The **minor** version will reflect new features added in THEOplayer Flutter SDK.
- The **patch** version will be increased when there is a need for a hotfix on top of the minor version bump.

>Note: Breaking changes in THEOplayer Flutter SDK will only occur while increasing the **major** version.

## 1.0.3

* Updated THEOplayer to 6.10.1.
* Added and coupled application lifecycle listener.

## 1.0.2

* Service release, no new features.

## 1.0.1

* Updated minimum Dart version to 3.3.0.
* Updated minimum Flutter version to 3.19.0.

## 1.0.0

* Initial release.