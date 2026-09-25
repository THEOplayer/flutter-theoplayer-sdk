import Flutter
import UIKit

public class TheoplayerPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "theoplayer", binaryMessenger: registrar.messenger())
    let instance = TheoplayerPlugin()
    
    let messenger = registrar.messenger()
      
    PlatformActivityService.ensureInitialized(messenger: messenger)

    registrar.addMethodCallDelegate(instance, channel: channel)
    registrar.register(THEOplayerNativeViewFactory(messenger: messenger), withId: "com.theoplayer/theoplayer-view-native")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
