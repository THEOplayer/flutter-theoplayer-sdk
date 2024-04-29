import 'package:flutter/services.dart';

class THEOplayerConfig {
  String? _license;
  String? _licenseUrl;
  AndroidConfig androidConfig = AndroidConfig();
  List<DeviceOrientation> preferredFullscreenOrientations = [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight];
  List<DeviceOrientation> preferredRestoredOrientations = [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight, DeviceOrientation.portraitUp, DeviceOrientation.portraitDown];
  SystemUiMode fullscreenSystemUiMode = SystemUiMode.immersive;

  THEOplayerConfig({String? license, String? licenseUrl, AndroidConfig? androidConfiguration}) {
    _license = license;
    _licenseUrl = licenseUrl;
    if (androidConfiguration != null) {
      androidConfig = androidConfiguration;
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
