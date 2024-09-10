package com.theoplayer.flutter

import android.app.Activity
import android.util.Log
import com.theoplayer.flutter.helpers.PipHandler
import com.theoplayer.flutter.platform.PlatformActivityService
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class TheoplayerPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {

    private lateinit var flutterPluginBinding:  FlutterPluginBinding

    private lateinit var theoPlayerViewFactory: THEOplayerViewNativeFactory
    private lateinit var currentActivity: Activity

    private lateinit var pipHandler: PipHandler

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPluginBinding) {

        this.flutterPluginBinding = flutterPluginBinding
        this.theoPlayerViewFactory = THEOplayerViewNativeFactory(flutterPluginBinding.binaryMessenger)

        flutterPluginBinding.platformViewRegistry.registerViewFactory(
            "com.theoplayer/theoplayer-view-native",
            theoPlayerViewFactory
        )

        val methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.theoplayer.global/players")
        methodChannel.setMethodCallHandler(this)

        PlatformActivityService.ensureInitialized(flutterPluginBinding.binaryMessenger)

        pipHandler = PipHandler()
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {

    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        currentActivity = binding.activity;
        pipHandler.attachToActivityBinding(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        pipHandler.detachFromActivityBinding()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        pipHandler.attachToActivityBinding(binding)
    }

    override fun onDetachedFromActivity() {
        pipHandler.detachFromActivityBinding()
    }


    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        Log.d("TheoplayerPlugin", "onMethodCall: ${call.method}")

        when (call.method) {
            "createPlayer" -> {
                Log.d("TheoplayerPlugin", "createPlayer - onMethodCall - arguments: ${call.arguments}")

                //TODO: extract this logic
                val flutterPlayerConfig = (call.arguments as? Map<String, Any>?)?.get("playerConfig") as? Map<*, *>
                val useSurfaceTexture: Boolean = (flutterPlayerConfig?.get("androidConfig") as? Map<*, *>)?.get("viewComposition") as? String == "SURFACE_TEXTURE"

                val entry = if (useSurfaceTexture) this.flutterPluginBinding.textureRegistry.createSurfaceTexture() else this.flutterPluginBinding.textureRegistry.createSurfaceProducer()
                Log.d("TheoplayerPlugin", "createPlayer - entry created: ${entry.id()}")

                val theoplayer = this.theoPlayerViewFactory.createHeadless(flutterPluginBinding.applicationContext, entry, call.arguments);

                result.success(theoplayer.id)
            }

            else -> {
                result.notImplemented()
            }
        }
    }
}
