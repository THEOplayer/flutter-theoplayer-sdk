import 'package:flutter/material.dart';
import 'package:theoplayer_platform_interface/theopalyer_config.dart';
import 'package:theoplayer_platform_interface/theoplayer_view_controller_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

typedef THEOplayerViewCreatedCallback = void Function(THEOplayerViewController controller, BuildContext context);
typedef InitializeNativeResultCallback = void Function(int playerId);

abstract class TheoplayerPlatform extends PlatformInterface {
  /// Constructs a TheoplayerPlatform.
  TheoplayerPlatform() : super(token: _token);

  static final int UNSUPPORTED_TEXTURE_ID = -1;
  static final Object _token = Object();

  static TheoplayerPlatform _instance = NotImplementedTHEOplayerPlatform();

  /// The default instance of [TheoplayerPlatform] to use.
  ///
  /// Defaults to [MethodChannelTheoplayer].
  static TheoplayerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TheoplayerPlatform] when
  /// they register themselves.
  static set instance(TheoplayerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Initializes the native player on the underlying platform
  /// - for PlatformViews nothing happens here (yet)
  /// - for Textures the player will be created
  void initalize(THEOplayerConfig theoPlayerConfig, InitializeNativeResultCallback callback) {
    throw UnimplementedError('initalize() has not been implemented.');
  }

  /// Builds the native you on the underlying platform
  /// - for PlatormViews the player initialization happens here too
  /// - for Textures the Texture gets created here based on the work done by the [initalize] call
  Widget buildView(BuildContext context, THEOplayerConfig theoPlayerConfig, THEOplayerViewCreatedCallback createdCallback, int textureId) {
    // TODO: maybe better to split this method for PlatformViews and Textures
    throw UnimplementedError('buildView(BuildContext) has not been implemented.');
  }
}

class NotImplementedTHEOplayerPlatform extends TheoplayerPlatform {}
