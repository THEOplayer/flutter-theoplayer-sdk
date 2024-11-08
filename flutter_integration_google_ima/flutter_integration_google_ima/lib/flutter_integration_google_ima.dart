import 'package:theoplayer_integration_google_ima_platform_interface/flutter_integration_google_ima_platform_interface.dart';

class FlutterIntegrationGoogleIma {
  Future<String?> getPlatformVersion() {
    return FlutterIntegrationGoogleImaPlatform.instance.getPlatformVersion();
  }
}
