import Flutter
import UIKit

public class TheoplayerPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "theoplayer", binaryMessenger: registrar.messenger())
    let instance = TheoplayerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    
    registrar.register(THEOplayerNativeViewFactory(messenger: registrar.messenger()), withId: "com.theoplayer/theoplayer-view-native")
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
