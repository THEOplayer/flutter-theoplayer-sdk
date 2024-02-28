<img src="https://raw.githubusercontent.com/THEOplayer/flutter-theoplayer-sdk/main/doc/theoplayer_flutter_sdk_logo.png">

# THEOplayer Flutter SDK

## Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [How to use these guides](#how-to-use-these-guides)
4. [Features](#features)
5. [Getting Started](#getting-started)
6. [Contributing](#contributing)

## Overview

The `theoplayer` package provides a `THEOplayer` component supporting video playback on the
following platforms:

- Android, Android TV & FireTV
- iOS 
- HTML5 (web, mobile web)
- **OUT OF SCOPE**: Tizen and WebOS (smart TVs, set-top boxes and gaming consoles).

This document covers the creation of a minimal app including a `THEOplayer` component,
and an overview of the accompanying example app.

It also gives a description of the properties of the `THEOplayer` component, and
a list of features and known limitations.

## Prerequisites
For each platform, a dependency to the corresponding THEOplayer SDK is included through a dependency manager:

- Gradle & Maven for Android
- Cocoapods for iOS
- npm for Web *

*_the initial version of the SDK relies on a local copy of `THEOplayer.chromeless.js` (and additional modules), so adding it manually is required!_

In order to use one of these THEOplayer SDKs, it is necessary to obtain a valid THEOplayer license for that specific platform,
i.e. HTML5, Android, and/or iOS. You can use your existing THEOplayer SDK license or request a
[free trial account](https://www.theoplayer.com/free-trial-theoplayer?hsLang=en-us).

If you have no previous experience in Flutter, we encourage you to first explore the
[Flutter Documentation](https://docs.flutter.dev/),
as it gives you a good start on one of the most popular app development frameworks.

## How to use these guides

These are guides on how to use the THEOplayer Flutter SDK in your Flutter project(s) and can be used
linearly or by searching the specific section. It is recommended that you have a basic understanding of how
Flutter works to speed up the way of working with THEOplayer Flutter SDK.

## Features

Depending on the platform on which the application is deployed, a different set of features can be available.

If a feature is missing, additional help is needed, or you need to extend the package,
please reach out to us for support.

<img src="https://raw.githubusercontent.com/THEOplayer/flutter-theoplayer-sdk/main/doc/features.svg">


## Getting Started

This section starts with creating a minimal demo app that integrates the `theoplayer` package,
followed by an overview of the available properties and functionality of the THEOplayer component.
A minimal example application including a basic user interface and demo sources is included in [this repository](./flutter_theoplayer_sdk/example),
and discussed in the next section. Finally, an overview of features, limitations and known issues is listed.

- [Creating a minimal demo app](https://github.com/THEOplayer/flutter-theoplayer-sdk/blob/main/doc/creating-minimal-app.md)
    - [Getting started on Android](https://github.com/THEOplayer/flutter-theoplayer-sdk/blob/main/doc/creating-minimal-app.md#getting-started-on-android)
    - [Getting started on iOS](https://github.com/THEOplayer/flutter-theoplayer-sdk/blob/main/doc/creating-minimal-app.md#getting-started-on-ios)
    - [Getting started on Web](https://github.com/THEOplayer/flutter-theoplayer-sdk/blob/main/doc/creating-minimal-app.md#getting-started-on-web)
- [The THEOplayer component](https://github.com/THEOplayer/flutter-theoplayer-sdk/blob/main/doc/theoplayer-component.md)
- Knowledge Base
  - [Using custom DRM connectors](https://github.com/THEOplayer/flutter-theoplayer-sdk/blob/main/doc/custom_drm.md)
  - [Limitations and known issues](https://github.com/THEOplayer/flutter-theoplayer-sdk/blob/main/doc/limitations.md)

## Contributing

All contributions are welcomed!

Please read our [Contribution guide](https://github.com/THEOplayer/flutter-theoplayer-sdk/blob/main/CONTRIBUTING.md) on how to get started!