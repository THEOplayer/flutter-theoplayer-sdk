# Picture-in-Picture support

THEOplayer Flutter SDK supports native Picture-in-Picture on iOS, Android and Web platforms.
However, there are some differences and limitations.

## Android and iOS
Entering Picture-in-Picture (PiP) is possible through the `THEOplayer.setAllowAutomaticPictureInPicture(bool)` API.

This will not put the player into Picture-in-Picture mode immediately, but enables the player to enter PiP when the application moves to the background.

### Necessary configurations on app-level

#### Android

Enable [Picture-in-Picture support](https://developer.android.com/develop/ui/views/picture-in-picture#declaring) for your main Activity in the `AndroidManifest.xml` file.

```xml
<activity android:name=".MainActivity"
    android:supportsPictureInPicture="true"
    android:configChanges=
        "screenSize|smallestScreenSize|screenLayout|orientation|..."
    ...
```

#### iOS

Enable `Background Audio mode` for your application target in [XCode](https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/MediaPlaybackGuide/Contents/Resources/en.lproj/ConfiguringAudioSettings/ConfiguringAudioSettings.html#//apple_ref/doc/uid/TP40016757-CH9-SW4).

<img src="https://raw.githubusercontent.com/THEOplayer/flutter-theoplayer-sdk/main/doc/xcode_background_modes.png" />

### Limitations
- In multi-player scenarios there can be only one player that has `allowAutomaticPictureInPicture` set to `true`.
- On iOS paused player can not enter PiP mode
- Calling `THEOplayer.setPresentationMode(PresentationMode.PIP)` API to explicitly enter PiP mode doesn't work on iOS and Android. 
  - This limitation is due to the differences on how native iOS and Android handles the PiP mode. 
    - iOS moves the player into PiP, while keeping the ViewController on the screen.
    - Android moves the whole Activity into PiP.
  - Aligning these will be investigated in the next iterations of the THEOplayer Flutter SDK.
  - You can try use the [`go_home`](https://pub.dev/packages/go_home) package to simulate "Home button press" on Android and iOS to trigger application backgrounding (which will start the automatic PiP mode).
    - **NOTE**: there could be issues in the App Stores with the way this plugin simulates the "Home button press", use it on your own risk.

## Web
Entering Picture-in-Picture (PiP) is possible through the `THEOplayer.setPresentationMode(PresentationMode.PIP)` API.

### Limitations
- Picture-in-Picture is not supported in Firefox.
- `THEOplayer.setAllowAutomaticPictureInPicture(bool)` API is not supported.