import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class FlutterIntegrationGoogleImaPlatform extends PlatformInterface {
  /// Constructs a FlutterIntegrationGoogleImaPlatform.
  FlutterIntegrationGoogleImaPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterIntegrationGoogleImaPlatform _instance = NotImplementedFlutterIntegrationGoogleImaPlatform();

  /// The default instance of [FlutterIntegrationGoogleImaPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterIntegrationGoogleIma].
  static FlutterIntegrationGoogleImaPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterIntegrationGoogleImaPlatform] when
  /// they register themselves.
  static set instance(FlutterIntegrationGoogleImaPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}

class NotImplementedFlutterIntegrationGoogleImaPlatform extends FlutterIntegrationGoogleImaPlatform {}
