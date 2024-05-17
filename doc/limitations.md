# Limitations and Known Issues

This sections lists any limitations and known issues in the current package version.

## Platform support
THEOplayer Flutter SDK is capable of running on

- iOS 12 and above
- Android 5 and above
- Mainstream web browsers (Firefox 120+, Chrome 119+, Safari 17+, Microsoft Edge 119+)

However, it is not optimized for those devices.

**For the best experience, we suggest to target**
- iOS 14 and above
- Android 10 and above

In a later phase, we will optimize the SDKs for lower operating system versions as much as possible.

## Platform differences

The underlying native platform SDKs have different feature set.
First check the Dart documentation if you see behaviour differences on certain platforms.
We try to keep the documentation in sync as much as possible.
If you see no difference mentioned in behaviour, please consult with the [native SDK documentations](https://www.theoplayer.com/docs/theoplayer/).

## Version limitations

THEOplayer Flutter SDK only compatible with THEOplayer 6.x and above.

## Fullscreen and Picture-in-picture

THEOplayer Flutter SDK doesn't have a built-in presentation mode switch, 
so only in-app Fullscreen and Picture-and-Picture mode can be achieved by implementing the logic on app-level.

The example project within the SDK package contains an example use-case for Fullscreen.

## UI
Currently, THEOplayer Flutter SDK is completely chromeless, the UI needs to be implemented on top of the public APIs on the Flutter level.

## Missing features
THEOplayer Flutter SDK is not in feature parity yet with the native SDKs, new features will be added continuously.

For the current feature list, please visit the [README](../flutter_theoplayer_sdk/README.md) page.
