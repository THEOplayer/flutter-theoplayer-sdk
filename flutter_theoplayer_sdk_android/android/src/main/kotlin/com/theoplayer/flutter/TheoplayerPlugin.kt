package com.theoplayer.flutter

import android.util.Log
import android.util.LongSparseArray
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.TextureRegistry

class TheoplayerPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {

    private lateinit var flutterPluginBinding:  FlutterPluginBinding

    private val theoPlayers = LongSparseArray<THEOplayerViewNative>()
    private val surfaces = LongSparseArray<TextureRegistry.TextureEntry>()

    private lateinit var theoPlayerViewFactory: THEOplayerViewNativeFactory;

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding
        this.theoPlayerViewFactory = THEOplayerViewNativeFactory(flutterPluginBinding.binaryMessenger)

        flutterPluginBinding.platformViewRegistry.registerViewFactory(
            "com.theoplayer/theoplayer-view-native",
            theoPlayerViewFactory
        )

        val methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.theoplayer.global/players")
        methodChannel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {

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

                val theoplayer = this.theoPlayerViewFactory.createHeadless(flutterPluginBinding.applicationContext, entry, null);

                theoplayer.destroyListener = THEOplayerViewNative.DestroyListener {
                    Log.e("TheoplayerPlugin", "destroyListener - entry: ${entry.id()}")
                    theoPlayers.remove(entry.id());
                    surfaces.remove(entry.id());
                    theoplayer.destroyListener = null;
                }

                theoPlayers.put(entry.id(), theoplayer);
                surfaces.put(entry.id(), entry);

                result.success(entry.id())
            }

            else -> {
                result.notImplemented()
            }
        }
    }
}
