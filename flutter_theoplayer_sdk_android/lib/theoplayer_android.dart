import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:theoplayer_android/theoplayer_view_controller_android.dart';
import 'package:theoplayer_platform_interface/theopalyer_config.dart';
import 'package:theoplayer_platform_interface/theoplayer_platform_interface.dart';

/// An implementation of [TheoplayerPlatform] that uses method channels.
class THEOplayerAndroid extends TheoplayerPlatform {
  /// Registers this class as the default instance of [TheoplayerPlatform].
  static void registerWith() {
    TheoplayerPlatform.instance = THEOplayerAndroid();
  }

  @override
  Widget buildView(BuildContext context, THEOplayerConfig theoPlayerConfig, THEOplayerViewCreatedCallback createdCallback, int textureId) {
    // This is used in the platform side to register the view.
    const String viewType = 'com.theoplayer/theoplayer-view-native';

    // Pass parameters to the platform side.
    Map<String, dynamic> creationParams = <String, dynamic>{};
    creationParams["playerConfig"] = theoPlayerConfig.toJson();

    if (theoPlayerConfig.androidConfig.viewComposition == AndroidViewComposition.TEXTURE) {
      return Texture(textureId: textureId);
    } else {
      return PlatformViewLink(
        viewType: viewType,
        surfaceFactory: (context, controller) {
          return AndroidViewSurface(
            controller: controller as AndroidViewController,
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (params) {
          late AndroidViewController androidViewController;

          if (theoPlayerConfig.androidConfig.viewComposition == AndroidViewComposition.HYBRID_COMPOSITION) {
            androidViewController = PlatformViewsService.initExpensiveAndroidView(
              id: params.id,
              viewType: viewType,
              layoutDirection: TextDirection.ltr,
              creationParams: creationParams,
              creationParamsCodec: const StandardMessageCodec(),
              onFocus: () {
                params.onFocusChanged(true);
              },
            );
          } else {
            androidViewController = PlatformViewsService.initAndroidView(
              id: params.id,
              viewType: viewType,
              layoutDirection: TextDirection.ltr,
              creationParams: creationParams,
              creationParamsCodec: const StandardMessageCodec(),
              onFocus: () {
                params.onFocusChanged(true);
              },
            );
          }

          return androidViewController
            ..addOnPlatformViewCreatedListener((id) {
              params.onPlatformViewCreated(id);
              createdCallback(THEOplayerViewControllerAndroid(id), context);
            })
            ..create();
          },
      );
    }
  }
}
