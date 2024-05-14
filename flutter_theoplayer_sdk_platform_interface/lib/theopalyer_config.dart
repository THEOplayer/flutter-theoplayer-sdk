import 'package:flutter/services.dart';

class THEOplayerConfig {
  String? _license;
  String? _licenseUrl;
  AndroidConfig androidConfig = AndroidConfig();
  FullscreenConfig fullscreenConfig = FullscreenConfig();

  THEOplayerConfig({String? license, String? licenseUrl, AndroidConfig? androidConfiguration, FullscreenConfig? fullscreenConfiguration}) {
    _license = license;
    _licenseUrl = licenseUrl;
    if (androidConfiguration != null) {
      androidConfig = androidConfiguration;
    }
    if (fullscreenConfiguration != null) {
      fullscreenConfig = fullscreenConfiguration;
    }
  }

  String? getLicense() {
    return _license;
  }

  String? getLicenseUrl() {
    return _licenseUrl;
  }

  //TODO: fix this, don't generate JSON manually.
  Map<String, dynamic> toJson() => {
        'license': _license,
        'licenseUrl': _licenseUrl,
        'androidConfig': androidConfig.toJson(),
      };
}

class AndroidConfig {
  final bool useHybridComposition;

  // TODO: revisit this change after THEOplayer Android refactor with Surface.
  // with Flutter 3.19 useHybridComposition is the best way to render video with THEOplayer.
  AndroidConfig({this.useHybridComposition = true});

  Map<String, dynamic> toJson() => {
        'useHybridComposition': useHybridComposition,
      };
}

class FullscreenConfig {
  final List<DeviceOrientation> preferredFullscreenOrientations;
  final List<DeviceOrientation> preferredRestoredOrientations;
  final SystemUiMode fullscreenSystemUiMode;

  FullscreenConfig({
    this.preferredFullscreenOrientations = const [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
    this.preferredRestoredOrientations = const [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    this.fullscreenSystemUiMode = SystemUiMode.immersive
  });
}
