import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:theoplayer_integration_google_ima_platform_interface/flutter_integration_google_ima_platform_interface.dart';

/// An implementation of [FlutterIntegrationGoogleImaPlatform] that uses method channels.
class MethodChannelFlutterIntegrationGoogleImaAndroid extends FlutterIntegrationGoogleImaPlatform {

  /// Registers this class as the default instance of [FlutterIntegrationGoogleImaPlatform].
  static void registerWith() {
    FlutterIntegrationGoogleImaPlatform.instance = MethodChannelFlutterIntegrationGoogleImaAndroid();
  }


  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_integration_google_ima');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
