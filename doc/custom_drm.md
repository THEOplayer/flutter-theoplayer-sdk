## Using a custom DRM integration

The initial version of the THEOplayer Flutter SDK only support generic Widevine and Fairplay DRM playback.

In a later release the Flutter SDK will also add functionality to utilize the well-known [THEOplayer Custom DRM Integration](https://github.com/THEOplayer/samples-drm-integration/tree/master) on the Flutter/Dart level.

The good news is that **the underlying platforms already support this functionality, so if you need to play a custom DRM stream, you can leverage this knowledge, and you can implement a _(temporary)_ hybrid solution**.

### Configuration in Flutter

The current Flutter API is already taking into account the future custom extension of the DRM configurations.
It already contains a `customIntegrationID` and an `integrationParameters` property to pass custom data:

```dart
SourceDescription(sources: [
    TypedSource(
        src: "https://fps.ezdrm.com/demo/video/ezdrm.m3u8",
        drm: DRMConfiguration(
            customIntegrationId: "YourCustomDRMIntegrationID",
            integrationParameters: {
                "custom_key": "custom_value",
            },
            fairplay: FairPlayDRMConfiguration(
                licenseAcquisitionURL: "https://yourlicenseurl.com",
                certificateURL: "https://yourcertificateurl.com",
                headers: null,
            ),
            widevine: WidevineDRMConfiguration(
                licenseAcquisitionURL: "https://yourlicenseurl.com",
            ),
        )),
    ])
)
```
By specifying these values the underlying platform knows it has to use a custom DRM logic.
Somehow we just have to make sure that the custom DRM logic is available on the native side.

### Registering a custom DRM connector on Android

You can rely on any existing native Java/Kotlin implementation you have already, or take one from our [samples repository](https://github.com/THEOplayer/samples-drm-integration/tree/master).

After you copied over the code into your Android application project (`projectRoot/android/app/src/main`), you can hook it up when the application gets initialized.

For example you can use the `MainActivity` class as a starting point (if you don't have any other platform-specific code).

```kotlin
import com.theoplayer.android.api.THEOplayerGlobal
import com.theoplayer.android.api.contentprotection.KeySystemId
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onAttachedToWindow() {
        super.onAttachedToWindow()

        THEOplayerGlobal.getSharedInstance(context).registerContentProtectionIntegration(
            "YourCustomDRMIntegrationID",
            KeySystemId.WIDEVINE,
            YourCustomWidevineContentProtectionIntegrationFactory()
        )
    }
}
```

By using the exact same `customIntegrationId` on the native side, the underlying THEOplayer will know what to do when it sees a source with the same custom DRM ID.

### Registering a custom DRM connector on iOS

You can rely on any existing native Swift/ObjC implementation you have already, or take one from our [samples repository](https://github.com/THEOplayer/samples-drm-integration/tree/master).

After you copied over the code into your Android application project (`projectRoot/ios/Runner`), you can hook it up when the application gets initialized.

For example you can use the `AppDelegate` class as a starting point (if you don't have any other platform-specific code).

```swift
import UIKit
import Flutter
import THEOplayerSDK

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    THEOplayer.registerContentProtectionIntegration(integrationId: "YourCustomDRMIntegrationID" , keySystem: .FAIRPLAY, integrationFactory: YourCustomFairplayContentProtectionIntegrationFactory())
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

By using the exact same `customIntegrationId` on the native side, the underlying THEOplayer will know what to do when it sees a source with the same custom DRM ID.

### Registering a custom DRM connector on Web

You can rely on any existing native Javascript/Typescript implementation you have already, or take one from our [samples repository](https://github.com/THEOplayer/samples-drm-integration/tree/master).

After you copied over the code into your Android application project (`projectRoot/web/`), you can hook it up when the application gets initialized.

For example you can use the `index.html` class as a starting point (if you don't have any other platform-specific code).

```html
<head>
  <!-- ... -->
  <script src="THEOplayer.chromeless.js" type="application/javascript"></script>
  <!-- after THEOplayer is loaded, you can load your custom DRM code/file -->
  <script src="customdrm.js" type="application/javascript"></script>
  <!-- and connect it with THEOplayer -->
  <script type="application/javascript">
    THEOplayer.registerContentProtectionIntegration(
        'YourCustomDRMIntegrationID',
        'widevine',
        new ContentProtectionIntegrations.YourCustomContentProtectionIntegrationFactory()
    );
  </script>

</head>
```

By using the exact same `customIntegrationId` on the native side, the underlying THEOplayer will know what to do when it sees a source with the same custom DRM ID.