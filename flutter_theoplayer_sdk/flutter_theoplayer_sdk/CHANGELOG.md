## 9.2.0

* Updated THEOplayer to 9.2.0.
* Added `TypedSource.headers` to set custom headers for requests (Applied on master playlist, media playlist and segment requests).
	- Supported only on Android (PlaybackPipeline.MEDIA3) and iOS.
* Fixed an issue where calling `player.dispose()` would not release resources properly on iOS.

## 9.0.0

* Updated THEOplayer to 9.0.0.
* Added `TypedSource.androidSourceConfiguration` to change playback pipelines on Android (legacy/media3)
* Changed default media playback pipeline on Android (**Breaking change**)
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
* Changed `THEOplayer.allowBackgroundPlayback()` to `THEOplayer.allowBackgroundPlayback`. **(Breaking change)**.
* Changed `THEOplayer.allowAutomaticPictureInPicture()` to `THEOplayer.allowAutomaticPictureInPicture`. **(Breaking change)**.
* Changed `THEOplayer.isEnded()` to `THEOplayer.isEnded`. **(Breaking change)**.
* Changed `THEOplayer.isPlaying()` to `THEOplayer.isPlaying`. **(Breaking change)**.
* Changed `THEOplayer.isSeeking()` to `THEOplayer.isSeeking`. **(Breaking change)**.

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