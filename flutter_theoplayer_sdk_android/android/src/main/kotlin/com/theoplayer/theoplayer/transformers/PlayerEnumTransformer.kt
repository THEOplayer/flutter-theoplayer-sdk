package com.theoplayer.theoplayer.transformers

import com.theoplayer.android.api.player.PreloadType
import com.theoplayer.android.api.player.ReadyState

typealias FlutterReadyState = com.theoplayer.theoplayer.pigeon.ReadyState
typealias FlutterPreloadType = com.theoplayer.theoplayer.pigeon.PreloadType

object PlayerEnumTransformer {

    fun toFlutterReadyState(readyState: ReadyState): FlutterReadyState {
        return when (readyState) {
            ReadyState.HAVE_NOTHING -> FlutterReadyState.HAVE_NOTHING
            ReadyState.HAVE_METADATA -> FlutterReadyState.HAVE_METADATA
            ReadyState.HAVE_CURRENT_DATA -> FlutterReadyState.HAVE_CURRENT_DATA
            ReadyState.HAVE_FUTURE_DATA -> FlutterReadyState.HAVE_FUTURE_DATA
            ReadyState.HAVE_ENOUGH_DATA -> FlutterReadyState.HAVE_ENOUGH_DATA
        }
    }

    fun toFlutterPreloadType(preload: PreloadType): FlutterPreloadType {
        return when (preload) {
            PreloadType.NONE -> FlutterPreloadType.NONE
            PreloadType.AUTO -> FlutterPreloadType.AUTO
            PreloadType.METADATA -> FlutterPreloadType.METADATA
        }
    }

    fun toPreloadType(preload: FlutterPreloadType): PreloadType {
        return when (preload) {
            FlutterPreloadType.NONE -> PreloadType.NONE
            FlutterPreloadType.AUTO -> PreloadType.AUTO
            FlutterPreloadType.METADATA -> PreloadType.METADATA
        }
    }
}