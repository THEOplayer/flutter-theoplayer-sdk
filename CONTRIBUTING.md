# Contributing

## Project setup

1. Have a proper [Flutter development environment](https://docs.flutter.dev/get-started/install) ready.
2. Install [Melos](https://melos.invertase.dev/~melos-latest/getting-started)


## Development

1. Clone the repository
2. Run `melos bootstrap` to setup the project and the local package overrides
3. Open the root of the project in Visual Studio / Android Studio to start development
4. The project contains the `flutter_theoplayer_sdk/example` folder that can be used during development.
5. Use `main.dart` to run the project

### Pigeon
The project uses pigeons for type-safe communication between Flutter and the native mobile platforms.

Pigeon doesn't support splitting your code into multiple files, so we added a `build_runner` script to help the code stay more readable.

To add new communication interfaces:

1. Modify `flutter_theoplayer_sdk_platform_interface/pigeon` files. (**NOTE**: `pigeons_merged.dart` is autogenerated, don't modify it.)
2. Run `dart run build_runner build --delete-conflicting-outputs` in `flutter_theoplayer_sdk_platform_interface` folder to generate the final (merged) pigeon file
   and subsequently to generate the platform-specific bindings based on the merged `pigeons_merged.dart` file.
3. Implement the new APIs on the Flutter and native side.

## Pull-requests
Before making a pull-request, please make sure:

1. The code has no Dart issues. Run `dart analyze` and fix the problem.
2. The code has no formatting issues. Run `dart format -l 200`. We don't enforce the 80 character limit by the dart formatter (and pub.dev). It makes the code quite unreadable in some cases. (Hopefully pub.dev fixes this at some point)
3. If you added cross-platform code, at least **add integration tests** in the `theoplayer_flutter_sdk/example/integration_test` folder.
4. Add unit test and widget test to your code, if applicable.
5. Make sure all platforms are happy with your change (iOS, Android, Web)
6. Make sure your PR has no merge conflicts.

### Run integration tests locally

#### Android and iOS

1. Run `flutter test integration_test` in the `theoplayer_flutter_sdk/example/` directory.

#### Web

1. Setup [Chrome webdriver](https://docs.flutter.dev/cookbook/testing/integration/introduction#5b-web)
2. Download the matching version of the `Chrome For Testing` app.
3. Run tests with `flutter drive --driver=webdriver_integration_test/webdriver.dart --target=integration_test_web/web_entrypoint.dart -d web-server --profile --driver-port=4444 --chrome-binary PATH_TO_CHROME_TESTING_BINARY/Google\ Chrome\ for\ Testing.app/Contents/MacOS/Google\ Chrome\ for\ Testing  --web-renderer html --web-browser-flag="--disable-web-security --autoplay-policy=no-user-gesture-required"` in the `theoplayer_flutter_sdk/example/` directory targeting your `Chrome For Testing` binary.

4. Also run it with `--web-renderer canvaskit`.
 

## Note

A THEOplayer license from [https://portal.theoplayer.com](https://portal.theoplayer.com) can be required for feature/stream/integration-specific development. The current license in the example app only allows streams to be played from localhost or theoplayer.com domains.