import 'package:flutter/services.dart';
import 'package:theoplayer_platform_interface/platform/platform_helper_channels.dart';

/// Provides access to the platform views service.
///
/// This service allows creating and controlling platform-specific views.
class PlatformActivityService {
  PlatformActivityService._() {
    PlatformHelperChannels.activity.setMethodCallHandler(_onMethodCall);
  }

  static final PlatformActivityService instance = PlatformActivityService._();

  Future<void> _onMethodCall(MethodCall call) {
    switch (call.method) {
      //TODO: streamline message strings with pigeon?
      case 'onUserLeaveHint':
        final int id = call.arguments as int;
      default:
        throw UnimplementedError("${call.method} was invoked but isn't implemented by PlatformActivityService");
    }
    return Future<void>.value();
  }

  void triggerEnterPictureInPicture() {
    //TODO: check callback
    PlatformHelperChannels.activity.invokeMethod("enterPictureInPicture");
  }

}