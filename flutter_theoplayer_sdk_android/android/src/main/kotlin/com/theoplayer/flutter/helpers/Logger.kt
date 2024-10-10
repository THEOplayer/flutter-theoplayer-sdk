package com.theoplayer.flutter.helpers

import android.util.Log
import com.theoplayer.flutter.BuildConfig

object Logger {

    object TAG {
        const val PictureInPicture: String = "THEO_PictureInPicture_Flutter"
    }

    fun logVerbose(tag: String, msg: String) {
        if (BuildConfig.DEBUG) {
            Log.v(tag, msg)
        }
    }

    fun logDebug(tag: String, msg: String) {
        if (BuildConfig.DEBUG) {
            Log.d(tag, msg)
        }
    }
}