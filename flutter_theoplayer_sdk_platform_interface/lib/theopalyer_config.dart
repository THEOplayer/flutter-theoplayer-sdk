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
  @Deprecated("Use [viewComposition]")
  late final bool useHybridComposition;
  late final AndroidViewComposition viewComposition;

  // TODO: revisit this change after THEOplayer Android refactor with Surface.
  // with Flutter 3.19 useHybridComposition is the best way to render video with THEOplayer.
  @Deprecated("Use [AndroidConfig.create]")
  AndroidConfig({this.useHybridComposition = true}) {
    viewComposition = useHybridComposition ? AndroidViewComposition.HYBRID_COMPOSITION : AndroidViewComposition.TEXTURE_LAYER;
  }

  AndroidConfig.create({this.viewComposition = AndroidViewComposition.SURFACE_TEXTURE}) {
    useHybridComposition = false;
  }

  Map<String, dynamic> toJson() => {
        'viewComposition': viewComposition.name.toUpperCase(),
      };
}
/// https://github.com/flutter/flutter/wiki/Android-Platform-Views
/// TODO: move to pigeons
enum AndroidViewComposition {

  /// initExpensiveAndroidView - using PlatformView to render the video
  HYBRID_COMPOSITION(true),
  /// initAndroidView - PlatformView - using PlatformView to render the video
  TEXTURE_LAYER(true),

  /// uses Texture instead of PlatformView
  SURFACE_TEXTURE(false),

  /// uses Texture(instead of PlatformView) with SurfaceProducer, works with Impeller too from Flutter 3.22
  /// https://docs.flutter.dev/release/breaking-changes/android-surface-plugins
  SURFACE_PRODUCER(false);

  final bool isPlatformView;
  const AndroidViewComposition(bool this.isPlatformView);

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
