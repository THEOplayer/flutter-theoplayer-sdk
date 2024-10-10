package com.theoplayer.flutter.platform

import android.os.Build
import android.util.Log
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

interface PlatformActivityServiceCallback {
    fun doEnterPictureInPicture()
}


class PlatformActivityService private constructor(messenger: BinaryMessenger): MethodChannel.MethodCallHandler {

    companion object {
        @Volatile private var privateInstance: PlatformActivityService? = null

        fun ensureInitialized(messenger: BinaryMessenger) {
            synchronized(this) {
                if (privateInstance == null) {
                    privateInstance = PlatformActivityService(messenger)
                }
            }
        }

        val INSTANCE: PlatformActivityService by lazy { privateInstance ?: throw Exception("Call `PlatformActivityService.ensureInitialized` first!") }
    }

    private val callbacks = mutableListOf<PlatformActivityServiceCallback>()
    private val methodChannelPlatformActivityService: MethodChannel = MethodChannel(messenger, "com.theoplayer.global/activity").also {
        it.setMethodCallHandler(this)
    }

    fun addCallback(callback: PlatformActivityServiceCallback) {
        callbacks.add(callback)
    }

    fun removeCallback(callback: PlatformActivityServiceCallback) {
        callbacks.remove(callback)
    }

    fun sendUserLeaveHint() {
        methodChannelPlatformActivityService.invokeMethod("onUserLeaveHint", null);
    }

    fun sendExitPictureInPicture() {
        methodChannelPlatformActivityService.invokeMethod("onExitPictureInPicture", null);
    }

    fun sendPlayActionReceived() {
        methodChannelPlatformActivityService.invokeMethod("playActionReceived", null);
    }

    fun sendPauseActionReceived() {
        methodChannelPlatformActivityService.invokeMethod("pauseActionReceived", null);
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "enterPictureInPicture" -> {
                Log.e("PlatformActivityService", "enterPictureInPicture - onMethodCall - arguments: ${call.arguments}")
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    //NOTE: no playerID is provided here
                    callbacks.forEach { callback ->
                        //NOTE: the other side needs to maintain who is in PiP
                        callback.doEnterPictureInPicture()
                    }
                    result.success(null);
                } else {
                    //TODO: define error codes for future
                    //TODO: we need to make sure that we don't even arrive here at all.
                    result.error("", "NOT_SUPPORTED", null)
                }
            }

            else -> {
                result.notImplemented()
            }
        }
    }

}