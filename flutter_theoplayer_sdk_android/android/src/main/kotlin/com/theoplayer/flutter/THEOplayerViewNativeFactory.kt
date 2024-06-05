package com.theoplayer.flutter

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.view.TextureRegistry

class THEOplayerViewNativeFactory(private val messenger: BinaryMessenger) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as? Map<String, Any>
        return THEOplayerViewNative(context, viewId, creationParams, messenger)
    }

    fun createHeadless(context: Context, surfaceEntry: TextureRegistry.TextureEntry, args: Any?): THEOplayerViewNative {
        val creationParams = args as? Map<String, Any>
        val tpv = THEOplayerViewNative(context, surfaceEntry, creationParams, messenger)
        return tpv;
    }

}