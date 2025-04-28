package com.theoplayer.flutter.transformers

import com.theoplayer.android.api.player.track.texttrack.TextTrackMode
import com.theoplayer.android.api.player.track.texttrack.TextTrackReadyState
import com.theoplayer.android.api.player.track.texttrack.TextTrackType

typealias FlutterTextTrackMode = com.theoplayer.flutter.pigeon.TextTrackMode
typealias FlutterTextTrackType = com.theoplayer.flutter.pigeon.TextTrackType
typealias FlutterTextTrackReadyState = com.theoplayer.flutter.pigeon.TextTrackReadyState

object TrackTransformer {

    fun toFlutterTextTrackMode(mode: TextTrackMode): FlutterTextTrackMode {
        return when (mode) {
            TextTrackMode.DISABLED -> FlutterTextTrackMode.DISABLED
            TextTrackMode.HIDDEN -> FlutterTextTrackMode.HIDDEN
            TextTrackMode.SHOWING -> FlutterTextTrackMode.SHOWING
        }
    }

    fun toTextTrackMode(mode: FlutterTextTrackMode): TextTrackMode {
        return when (mode) {
            FlutterTextTrackMode.DISABLED -> TextTrackMode.DISABLED
            FlutterTextTrackMode.HIDDEN -> TextTrackMode.HIDDEN
            FlutterTextTrackMode.SHOWING -> TextTrackMode.SHOWING
        }
    }

    fun toFlutterTextTrackType(type: TextTrackType): FlutterTextTrackType {
        return when (type) {
            TextTrackType.NONE -> FlutterTextTrackType.NONE
            TextTrackType.SRT -> FlutterTextTrackType.SRT
            TextTrackType.TTML -> FlutterTextTrackType.TTML
            TextTrackType.WEBVTT -> FlutterTextTrackType.WEBVTT
            TextTrackType.EMSG -> FlutterTextTrackType.EMSG
            TextTrackType.EVENTSTREAM -> FlutterTextTrackType.EVENTSTREAM
            TextTrackType.ID3 -> FlutterTextTrackType.ID3
            TextTrackType.CEA608 -> FlutterTextTrackType.CEA608
            TextTrackType.DATERANGE -> FlutterTextTrackType.DATERANGE
            TextTrackType.TIMECODE -> FlutterTextTrackType.TIMECODE
        }
    }

    fun toFlutterTextTrackReadyState(readyState: TextTrackReadyState): FlutterTextTrackReadyState {
        return when (readyState) {
            TextTrackReadyState.NONE -> FlutterTextTrackReadyState.NONE
            TextTrackReadyState.LOADING -> FlutterTextTrackReadyState.LOADING
            TextTrackReadyState.LOADED -> FlutterTextTrackReadyState.LOADED
            TextTrackReadyState.ERROR -> FlutterTextTrackReadyState.ERROR
        }
    }

}