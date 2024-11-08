import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_integration_google_ima/flutter_integration_google_ima.dart';
import 'package:flutter_integration_google_ima/flutter_integration_google_ima_platform_interface.dart';
import 'package:flutter_integration_google_ima/flutter_integration_google_ima_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterIntegrationGoogleImaPlatform
    with MockPlatformInterfaceMixin
    implements FlutterIntegrationGoogleImaPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterIntegrationGoogleImaPlatform initialPlatform = FlutterIntegrationGoogleImaPlatform.instance;

  test('$MethodChannelFlutterIntegrationGoogleIma is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterIntegrationGoogleIma>());
  });

  test('getPlatformVersion', () async {
    FlutterIntegrationGoogleIma flutterIntegrationGoogleImaPlugin = FlutterIntegrationGoogleIma();
    MockFlutterIntegrationGoogleImaPlatform fakePlatform = MockFlutterIntegrationGoogleImaPlatform();
    FlutterIntegrationGoogleImaPlatform.instance = fakePlatform;

    expect(await flutterIntegrationGoogleImaPlugin.getPlatformVersion(), '42');
  });
}
