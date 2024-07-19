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