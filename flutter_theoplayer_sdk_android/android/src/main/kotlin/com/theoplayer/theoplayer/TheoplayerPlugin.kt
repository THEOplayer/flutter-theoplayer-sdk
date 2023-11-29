package com.theoplayer.theoplayer

import io.flutter.embedding.engine.plugins.FlutterPlugin

class TheoplayerPlugin : FlutterPlugin {

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        flutterPluginBinding.platformViewRegistry.registerViewFactory(
            "com.theoplayer/theoplayer-view-native",
            THEOplayerViewNativeFactory(flutterPluginBinding.binaryMessenger)
        )
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {

    }
}
