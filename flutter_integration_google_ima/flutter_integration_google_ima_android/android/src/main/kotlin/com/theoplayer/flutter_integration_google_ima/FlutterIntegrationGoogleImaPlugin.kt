package com.theoplayer.flutter_integration_google_ima

import com.theoplayer.android.api.ads.ima.GoogleImaIntegrationFactory
import com.theoplayer.flutter.THEOplayerViewNativeFactory
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/** FlutterIntegrationGoogleImaPlugin */
class FlutterIntegrationGoogleImaPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_integration_google_ima")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "getPlatformVersion") {

      //var p = THEOplayerViewNativeFactory.players.get(0)
      //val imaIntegration = GoogleImaIntegrationFactory.createGoogleImaIntegration(THEOplayerViewNativeFactory.players.get(0).getUnderlyingTHEOplayerView())

      //p.addIntegration(imaIntegration)

      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
