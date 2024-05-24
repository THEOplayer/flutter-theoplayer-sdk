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
  @Deprecated("Use ")
  late final bool useHybridComposition;
  late final AndroidViewComposition viewComposition;

  // TODO: revisit this change after THEOplayer Android refactor with Surface.
  // with Flutter 3.19 useHybridComposition is the best way to render video with THEOplayer.
  @Deprecated("Use ")
  AndroidConfig({this.useHybridComposition = true}) {
    viewComposition = useHybridComposition ? AndroidViewComposition.HYBRID_COMPOSITION : AndroidViewComposition.TEXTURE_LAYER;
  }

  AndroidConfig.create({this.viewComposition = AndroidViewComposition.HYBRID_COMPOSITION}) {
    useHybridComposition = false;
  }

  Map<String, dynamic> toJson() => {
        'viewComposition': viewComposition.name.toUpperCase(),
      };
}
/// https://github.com/flutter/flutter/wiki/Android-Platform-Views
/// TODO: move to pigeons
enum AndroidViewComposition {
  /// initExpensiveAndroidView
  HYBRID_COMPOSITION,
  /// initAndroidView
  TEXTURE_LAYER,
  /// uses Texture
  TEXTURE

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
