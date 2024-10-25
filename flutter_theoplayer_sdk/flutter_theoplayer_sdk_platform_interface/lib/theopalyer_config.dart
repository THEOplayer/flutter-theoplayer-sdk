import 'package:flutter/services.dart';

class THEOplayerConfig {
  String? _license;
  String? _licenseUrl;
  AndroidConfig _androidConfig = AndroidConfig();
  FullscreenConfig _fullscreenConfig = FullscreenConfig();
  TheoLiveConfiguration? _theoLive = null;

  THEOplayerConfig({String? license, String? licenseUrl, AndroidConfig? androidConfiguration, FullscreenConfig? fullscreenConfiguration, TheoLiveConfiguration? theolive,}) {
    _license = license;
    _licenseUrl = licenseUrl;
    if (androidConfiguration != null) {
      _androidConfig = androidConfiguration;
    }
    if (fullscreenConfiguration != null) {
      _fullscreenConfig = fullscreenConfiguration;
    }
    if (theolive != null) {
      _theoLive = theolive;
    }
  }

  String? get license {
    return _license;
  }

  String? get licenseUrl {
    return _licenseUrl;
  }

  TheoLiveConfiguration? get theoLive {
    return _theoLive;
  }

  FullscreenConfig get fullscreenConfiguration {
    return _fullscreenConfig;
  }

  AndroidConfig get androidConfig {
    return _androidConfig;
  }

  //TODO: fix this, don't generate JSON manually.
  Map<String, dynamic> toJson() => {
        'license': _license,
        'licenseUrl': _licenseUrl,
        'androidConfig': _androidConfig._toJson(),
        'theoLive': _theoLive?._toJson()
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

  Map<String, dynamic> _toJson() => {
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

class TheoLiveConfiguration {
  String? externalSessionId;
  bool? fallbackEnabled;

  TheoLiveConfiguration({this.externalSessionId = null, this.fallbackEnabled = null});

  Map<String, dynamic> _toJson() => {
    'externalSessionId': externalSessionId,
    'fallbackEnabled': fallbackEnabled,
  };
}
