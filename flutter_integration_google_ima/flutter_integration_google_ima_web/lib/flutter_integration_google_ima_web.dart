// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:theoplayer_integration_google_ima_platform_interface/flutter_integration_google_ima_platform_interface.dart';
import 'package:web/web.dart' as web;

/// A web implementation of the FlutterIntegrationGoogleImaPlatform of the FlutterIntegrationGoogleIma plugin.
class FlutterIntegrationGoogleImaWeb extends FlutterIntegrationGoogleImaPlatform {
  /// Constructs a FlutterIntegrationGoogleImaWeb
  FlutterIntegrationGoogleImaWeb();

  static void registerWith(Registrar registrar) {
    FlutterIntegrationGoogleImaPlatform.instance = FlutterIntegrationGoogleImaWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = web.window.navigator.userAgent;
    return version;
  }
}
