package com.theoplayer.flutter

import android.content.Context
import android.util.Log
import android.util.SparseArray
import androidx.core.util.forEach
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.view.TextureRegistry

class THEOplayerViewNativeFactory(private val messenger: BinaryMessenger) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    companion object {
        val players = SparseArray<THEOplayerViewNative>()
        val surfaces = SparseArray<TextureRegistry.TextureEntry>()

        fun findFirstPlayerThatCanEnterIntoPip() : Int? {
            players.forEach { id, player ->
                if (player.allowAutomaticPictureInPicture()) {
                    return id
                }
            }
            return null
        }
    }

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as? Map<String, Any>
        val tpv = THEOplayerViewNative(context, viewId, creationParams, messenger)

        savePlayer(tpv)

        return tpv
    }

    private fun savePlayer(tpv: THEOplayerViewNative) {
        players.put(tpv.id, tpv)

        tpv.destroyListener = THEOplayerViewNative.DestroyListener {
            Log.e("TheoplayerPlugin", "destroyListener - entry: ${tpv.id}")
            players.remove(tpv.id);
            surfaces.remove(tpv.id);
            tpv.destroyListener = null;
        }
    }

    fun createHeadless(context: Context, surfaceEntry: TextureRegistry.TextureEntry, args: Any?): THEOplayerViewNative {
        val creationParams = args as? Map<String, Any>
        val tpv = THEOplayerViewNative(context, surfaceEntry, creationParams, messenger)

        savePlayer(tpv)
        surfaces.put(tpv.id, surfaceEntry);

        return tpv;
    }
}