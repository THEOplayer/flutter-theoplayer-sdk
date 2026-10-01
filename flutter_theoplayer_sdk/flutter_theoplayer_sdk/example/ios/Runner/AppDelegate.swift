import UIKit
import Flutter
import THEOplayerSDK

@main
// FlutterImplicitEngineDelegate registers plugins after the implicit engine initializes, as required by the UIScene lifecycle.
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    THEOplayer.registerContentProtectionIntegration(integrationId: EzdrmDRMIntegration.integrationID , keySystem: .FAIRPLAY, integrationFactory: EzdrmDRMIntegrationFactory())
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
