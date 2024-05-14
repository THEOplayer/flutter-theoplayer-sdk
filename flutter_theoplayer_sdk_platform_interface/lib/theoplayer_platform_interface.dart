import 'package:flutter/material.dart';
import 'package:theoplayer_platform_interface/theopalyer_config.dart';
import 'package:theoplayer_platform_interface/theoplayer_view_controller_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

typedef THEOplayerViewCreatedCallback = void Function(THEOplayerViewController controller, BuildContext context);

abstract class TheoplayerPlatform extends PlatformInterface {
  /// Constructs a TheoplayerPlatform.
  TheoplayerPlatform() : super(token: _token);

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

  Widget buildView(BuildContext context, THEOplayerConfig theoPlayerConfig, THEOplayerViewCreatedCallback createdCallback) {
    throw UnimplementedError('buildView(BuildContext) has not been implemented.');
  }
}

class NotImplementedTHEOplayerPlatform extends TheoplayerPlatform {}
