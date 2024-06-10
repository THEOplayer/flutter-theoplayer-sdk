import 'package:flutter/services.dart';

abstract final class PlatformHelperChannels {
  /// A [MethodChannel] for controlling the presenting activity/view controller.
  ///
  /// See also:
  ///
  ///  * [PlatformActivityService] for the available operations on this channel.
  static const MethodChannel activity = MethodChannel(
    'com.theoplayer.global/activity',
  );

  //TODO: revisit later
  /// A [MethodChannel] for controlling headless/textureview player creation.
  ///
  /// See also:
  ///
  ///  * [PlatformPlayersService] for the available operations on this channel.
  static const MethodChannel players = MethodChannel(
    'com.theoplayer.global/players',
  );

}