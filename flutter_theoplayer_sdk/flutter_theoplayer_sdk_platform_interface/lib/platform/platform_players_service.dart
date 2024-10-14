import 'package:flutter/services.dart';
import 'package:theoplayer_platform_interface/helpers/logger.dart';
import 'package:theoplayer_platform_interface/platform/platform_helper_channels.dart';

/// Provides access to the platform views service.
///
/// This service allows creating and controlling platform-specific views.
class PlatformPlayersService {
  PlatformPlayersService._() {
    PlatformHelperChannels.players.setMethodCallHandler(_onMethodCall);
  }

  static final PlatformPlayersService instance = PlatformPlayersService._();

  Future<void> _onMethodCall(MethodCall call) {
    switch (call.method) {
      default:
        throw UnimplementedError("${call.method} was invoked but isn't implemented by PlatformPlayersService");
    }
  }

  Future<int> createPlayer(Map<String, dynamic> creationParams) async {
    var id = await PlatformHelperChannels.players.invokeMethod("createPlayer", creationParams);
    debugLog("[PlatformPlayersService] createPlayer - created: $id");
    return Future.value(id);
  }

}