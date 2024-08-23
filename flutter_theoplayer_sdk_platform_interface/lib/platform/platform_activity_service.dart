import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:theoplayer_platform_interface/platform/platform_helper_channels.dart';

/// Provides access to the platform views service.
///
/// This service allows creating and controlling platform-specific views.
class PlatformActivityService {
  PlatformActivityService._() {
    PlatformHelperChannels.activity.setMethodCallHandler(_onMethodCall);
  }

  static final PlatformActivityService instance = PlatformActivityService._();

  final List<PlatformActivityServiceListener> _listeners = <PlatformActivityServiceListener>[];

  void addPlatformActivityServiceListener(PlatformActivityServiceListener listener) {
    _listeners.add(listener);
  }

  void removePlatformActivityServiceListener(PlatformActivityServiceListener listener) {
    _listeners.remove(listener);
  }

  Future<void> _onMethodCall(MethodCall call) {
    switch (call.method) {
      //TODO: streamline message strings with pigeon?
      case 'onUserLeaveHint':
        //final int id = call.arguments as int;
        _listeners.forEach((listener) => listener.onUserLeaveHint());
      case 'onExitPictureInPicture'  :
        //NOTE: instead of passing the player IDs around, we let each player (that implements the listener) to enter or exit
        //TODO: maybe this needs to change on the long term if the architecture requires it

        //final int id = call.arguments as int;
        //_listeners.where((listener) => listener.playerID == id).forEach((listener) => listener.onExitPictureInPicture());
        _listeners.forEach((listener) => listener.onExitPictureInPicture());
      default:
        throw UnimplementedError("${call.method} was invoked but isn't implemented by PlatformActivityService");
    }
    return Future<void>.value();
  }

  Future<void> triggerEnterPictureInPicture() {
    //TODO: do we need to check callback?
    return PlatformHelperChannels.activity.invokeMethod("enterPictureInPicture");
  }

}

abstract class PlatformActivityServiceListener {
  int get playerID;
  void onUserLeaveHint();
  void onExitPictureInPicture();
}