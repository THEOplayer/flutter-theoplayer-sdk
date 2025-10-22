# WASM support (experimental)

When compiling the THEOplayer Flutter SDK for WEB, you can now specify [WASM support](https://docs.flutter.dev/platform-integration/web/wasm).

## Flutter Compatibility
Use **Flutter 3.35.3 or later** for the best performance and compatibility. (earlier versions could have rendering issues with the video element)

## Run or build your app
To run the app with Wasm for development or testing, use the `--wasm` flag with the `flutter run` command.

```bash
flutter run -d chrome --wasm
```

To build a web application with Wasm, add the `--wasm` flag to the existing `flutter build web` command.

```bash
flutter build web --wasm
```

The command produces output into the `build/web` directory relative to the package root, just like `flutter build web`.

## Changes required in your app

### Bootstrapping
Make sure your app's `web/index.html` is updated to the [latest Flutter web app initialization](https://docs.flutter.dev/platform-integration/web/initialization) (it was introduced from Flutter 3.22).

It depends on your project structure, but most of the times this only means you need to make sure that `flutter_bootstrap.js` is properly included in your `index.html`.

### Include THEOplayer WEB SDK as asset

Define the path of the folder that contains THEOplayer Web SDK as an `asset` in your `pubspec.yaml` file to make sure the Javascript files will be included.

For example, if the THEOplayer WEB SDK is located under `web/theoplayer`, then
```yaml
  assets:
    - web/theoplayer/
```

## Browser support

Not all browsers support the Flutter WASM renderer.
Please always check the status of the compatibility [here](https://docs.flutter.dev/platform-integration/web/wasm#learn-more-about-browser-compatibility).

## Host it on a compatible server

Extra [configuration is needed](https://docs.flutter.dev/platform-integration/web/wasm#serve-the-built-output-with-an-http-server) on the server-side to make sure WebAssembly runs properly.

During debugging the `flutter run -d chrome --wasm` command will serve your webapp properly, but once you build a release version and host it on your own server, you need to make sure the server is configured properly.

For example don't expect that any basic web serving command e.g. (`python3 -m http.server 8000`) will just to run with WebAssembly support. 

On the other hand most of the hosting solutions (e.g. Netlify or [Netlify Drop](https://app.netlify.com/drop)) will have this configured out of the box.

Always consult with your hosting provider first!