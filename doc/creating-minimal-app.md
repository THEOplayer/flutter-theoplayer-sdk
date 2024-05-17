# Creating a minimal demo app

In this section we start from an empty Flutter project, include a dependency to `flutter_theoplayer_sdk`, and deploy it on an Android or iOS device.

## Table of Contents
- [Setting up a new project](#setting-up-a-new-project)
- [Getting started on Android](#getting-started-on-android)
- [Getting started on iOS](#getting-started-on-ios)
- [Getting started on Web](#getting-started-on-web)


## Setting up a new project

### Getting a new project ready
After [setting up your Flutter development environment](https://docs.flutter.dev/get-started/install)
you can run the following command to create a new project from Terminal. (You can use Android Studio too)

```bash
$ flutter create -a kotlin -i swift -t app --org com.theoplayer --description "New THEOplayer project" --project-name "flutter_theoplayer_sample_app" --platform web,ios,android flutter_theoplayer_sample_app
```

This will generate a basic project as a starting point for Android, iOS and Web development.

```bash
Signing iOS app for device deployment using developer identity: "Apple Development: XXXXXXXXXXX"
Creating project flutter_theoplayer_sample_app...
Resolving dependencies in flutter_theoplayer_sample_app... 
Got dependencies in flutter_theoplayer_sample_app.
Wrote 81 files.

All done!
You can find general documentation for Flutter at: https://docs.flutter.dev/
Detailed API documentation is available at: https://api.flutter.dev/
If you prefer video documentation, consider: https://www.youtube.com/c/flutterdev

In order to run your application, type:

  $ cd flutter_theoplayer_sample_app
  $ flutter run

Your application code is in flutter_theoplayer_sample_app/lib/main.dart.
```

Following the guidance from the script you can have your basic app running:

```bash
$ cd flutter_theoplayer_sample_app
$ flutter run
```

### Adding THEOplayer Flutter SDK
#### Option 1: Adding THEOplayer Flutter SDK as dependency (Recommended)
To add THEOplayer Flutter SDK as a dependency, you can simply fetch it from [pub.dev](https://pub.dev) using:

```bash
$ flutter pub add theoplayer
```

#### Option 2: Adding THEOplayer Flutter SDK as submodule
As an alternative, you can add the SDK as a submodule in your git project.
This can be useful if you are trying to fork the project to [contribute](https://github.com/THEOplayer/flutter-theoplayer-sdk/blob/main/CONTRIBUTING.md) with us.

```bash
$ git submodule add https://GITHUB_USERNAME:GITHUB_PASSWORD@github.com/THEOplayer/flutter-theoplayer-sdk flutter-theoplayer-sdk
```

Then, your project structure will look like this:
```bash
➜  flutter_theoplayer_sample_app git:(master) ✗ ls
README.md                         flutter-theoplayer-sdk            pubspec.lock
analysis_options.yaml             flutter_theoplayer_sample_app.iml pubspec.yaml
android                           ios                               test
build                             lib                               web

```

After the submodule added, you can add the THEOplayer Flutter SDK as a dependency in your project's `pubspec.yaml` file manually, or just by running this command:

```bash
$ flutter pub add 'theoplayer:{"path":"./flutter-theoplayer-sdk/flutter_theoplayer_sdk"}' --directory .
```

You should get an output like this after executing the command,
meaning `flutter` found and added the SDK as a dependency, and fetched the necessary packages too.

```diff
Resolving dependencies... 
  collection 1.17.2 (1.18.0 available)
  flutter_lints 2.0.3 (3.0.1 available)
+ theoplayer_sdk_android 1.0.0 from path ../flutter-theoplayer-sdk/flutter_theoplayer_sdk_android
+ theoplayer_sdk_ios 1.0.0 from path ../flutter-theoplayer-sdk/flutter_theoplayer_sdk_ios
+ theoplayer_sdk_platform_interface 1.0.0 from path ../flutter-theoplayer-sdk/flutter_theoplayer_sdk_platform_interface
+ theoplayer_sdk_web 1.0.0 from path ../flutter-theoplayer-sdk/flutter_theoplayer_sdk_web
+ flutter_web_plugins 0.0.0 from sdk flutter
+ js 0.6.7
  lints 2.1.1 (3.0.0 available)
  material_color_utilities 0.5.0 (0.8.0 available)
  meta 1.9.1 (1.11.0 available)
+ plugin_platform_interface 2.1.6
  stack_trace 1.11.0 (1.11.1 available)
  stream_channel 2.1.1 (2.1.2 available)
  test_api 0.6.0 (0.6.1 available)
+ theoplayer 1.0.0 from path ../flutter-theoplayer-sdk/flutter_theoplayer_sdk
  web 0.1.4-beta (0.4.0 available)
Changed 8 dependencies!
```

To make sure the submodule references the platform-specific SDKs from within the repository run `melos bootstrap`.

If your main project doesn't pick up the changes, it is possible you need to configure `melos` to include your project too.

You can do it in 2 ways.

1. Create your `melos.yaml` file in your root project and configure it according to your setup (including the `theopalyer` submodule and its packages).
2. Or, modifiy the `flutter-theoplayer-sdk/melos.yaml` to include your project by adding `../` into the `packages` section of the melos file.

Don't forget to run `melos bootstrap` again in the directory according to your choice from above.

### Adding THEOplayer to your view hierarchy

1. Initialize THEOplayer (e.g. in your StatefulWidget)
```dart
  late THEOplayer player;

  @override
  void initState() {
    super.initState();

    player = THEOplayer(
        theoPlayerConfig: THEOplayerConfig(
          license: "YOUR_LICENSE_STRING",
        ),
        onCreate: () {
          print("THEOplayer is created and ready to use");
        });
  }
```
Keep in mind, you need to have a valid license from [THEOportal](https://portal.theoplayer.com).

Without a license you can only play sources hosted on `theoplayer.com` domain.
(If you want to try this, just delete the `license` String from the `THEOplayerConfig`)

2. Adding THEOplayer to the view hierarchy

```dart
SizedBox(
    height: 300,
    child: player.getView(),
),
```

3. Setting a source and start playback on a button press:

```dart
FilledButton(
    onPressed: () {
        player.setSource(SourceDescription(sources: [
            TypedSource(src: "https://cdn.theoplayer.com/video/big_buck_bunny/big_buck_bunny.m3u8"),
        ]));
        player.play();
    },
    child: const Text("Play BBB source"),
),
```

---
You are (almost) ready to play with THEOplayer 😉


Is there anything else to configure on the specific platforms?

Check it below ⬇️

## Getting started on Android

The generated sample project doesn't have Internet permission by default (only in debug/profile mode).

By declaring the `INTERNET` the `AndroidManifest.xml`, your app can reach the Internet.
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

As noted in the [limitations](./limitations.md), THEOplayer on Android supports Android 5 (API level 21) and above, 
so defining this in the `android/app/build.gradle` is necessary:
```java
defaultConfig {
    // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
    applicationId "com.theoplayer.theoplayer_example"
    // You can update the following values to match your application needs.
    // For more information, see: https://docs.flutter.dev/deployment/android#reviewing-the-gradle-build-configuration.
    minSdkVersion 21
    targetSdkVersion flutter.targetSdkVersion
    versionCode flutterVersionCode.toInteger()
    versionName flutterVersionName
}
```

By using the `flutter run android` command, you can try out your application on an Android device.

## Getting started on iOS

No changes are required.

By using the `flutter run ios` command, you can try out your applicaiton on an iOS device.

## Getting started on Web

You need to acquire THEOplayer HTML5 SDK from [THEOportal](https://portal.theoplayer.com/) (or from an NPM package, e.g. from [6.9.0](https://registry.npmjs.org/theoplayer/-/theoplayer-6.9.0.tgz)).

**The current iteration of the THEOplayer Flutter SDK is not able to automatically pull THEOplayer HTML5 SDK from NPM, 
so this is now a manual procedure.**

If you have all the files at your hand (`THEOplayer.chromeless.js`, `common` and `transmux` files) 
copy them into the root of your Web project. 
(Next to the `index.html`, which is the entry point of your Flutter Web application)

Load the `THEOplayer.chromeless.js` Javascript in the `<HEAD>` of your `index.html` page:

```html
<!-- This script adds the flutter initialization JS code, don't change it -->
<script src="flutter.js" defer></script>

<!-- Loading THEOplayer -->
<script src="THEOplayer.chromeless.js" type="application/javascript"></script>
```

After these steps, you are good to go.

By using the `flutter run chrome` command, you can try out your application in the Chrome browser.
