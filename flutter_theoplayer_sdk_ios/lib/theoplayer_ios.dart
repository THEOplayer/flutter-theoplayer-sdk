import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:theoplayer_ios/theoplayer_view_controller_ios.dart';
import 'package:theoplayer_platform_interface/theopalyer_config.dart';
import 'package:theoplayer_platform_interface/theoplayer_platform_interface.dart';

/// An implementation of [TheoplayerPlatform] that uses method channels.
class THEOplayerIOS extends TheoplayerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('theoplayer');

  /// Registers this class as the default instance of [TheoplayerPlatform].
  static void registerWith() {
    TheoplayerPlatform.instance = THEOplayerIOS();
  }

  @override
  void initalize(THEOplayerConfig theoPlayerConfig, InitializeNativeResultCallback callback) {
    callback(TheoplayerPlatform.UNSUPPORTED_TEXTURE_ID);
  }

  @override
  Widget buildView(BuildContext context, THEOplayerConfig theoPlayerConfig, THEOplayerViewCreatedCallback createdCallback, int textureId) {
    // This is used in the platform side to register the view.
    const String viewType = 'com.theoplayer/theoplayer-view-native';

    // Pass parameters to the platform side.
    Map<String, dynamic> creationParams = <String, dynamic>{};
    creationParams["playerConfig"] = theoPlayerConfig.toJson();

    return UiKitView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (id) {
          createdCallback(THEOplayerViewControllerIOS(id), context);
        });
  }
}
