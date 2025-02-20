import UIKit
import Flutter
import THEOplayerSDK

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    THEOplayer.registerContentProtectionIntegration(integrationId: EzdrmDRMIntegration.integrationID , keySystem: .FAIRPLAY, integrationFactory: EzdrmDRMIntegrationFactory())
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
