package com.theoplayer.flutter.helpers

import android.content.ComponentCallbacks2
import android.content.res.Configuration
import android.graphics.Rect
import android.os.Build
import android.util.Log
import androidx.annotation.RequiresApi
import com.theoplayer.flutter.THEOplayerViewNative
import com.theoplayer.flutter.THEOplayerViewNativeFactory
import com.theoplayer.flutter.platform.PlatformActivityService
import com.theoplayer.flutter.platform.PlatformActivityServiceCallback
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry.UserLeaveHintListener

class PipHandler(pipChangeListener: PiPChangeListener) {

    private val NO_PLAYER_IN_PIP = -1

    private var activityBinding: ActivityPluginBinding? = null
    private var didEnteredPiP = false;
    private var playerInPip: Int = NO_PLAYER_IN_PIP

    private val componentCallback = object : ComponentCallbacks2 {
        override fun onConfigurationChanged(newConfig: Configuration) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                val isInPictureInPictureMode = activityBinding?.activity?.isInPictureInPictureMode ?: false
                Log.d("PipHandler", "onConfigurationChanged: didEnter: $didEnteredPiP, inPiP: $isInPictureInPictureMode")
                if (didEnteredPiP) {
                    if (!isInPictureInPictureMode) {
                        PlatformActivityService.INSTANCE.sendExitPictureInPicture()
                        exitPip(playerInPip, null);
                        pipChangeListener.onExitPiP(playerInPip)
                    } else {
                        //NOTE: we could trigger enterPiP from here too, e.g. this happens when the transition finished.
                        //PlatformActivityService.INSTANCE.sendUserLeaveHint()
                        //pipChangeListener.onEnterPiP(playerInPip)
                    }
                }
            }
        }

        override fun onLowMemory() {
        }

        override fun onTrimMemory(level: Int) {
        }
    }

    private val userLeaveHintListener = UserLeaveHintListener {
        Log.d("PipHandler", "userLeaveHintListener")
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) { //TODO: O
            PlatformActivityService.INSTANCE.sendUserLeaveHint()
            enterPip(-1, null)
        }
    }

    private val pipCallback = object : PlatformActivityServiceCallback {
        override fun doEnterPictureInPicture() {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) { //O
                //TODO: fix ID
                PlatformActivityService.INSTANCE.sendUserLeaveHint()
                enterPip(-1, null)
            }
        }
    }

    fun attachToActivityBinding(activityBinding: ActivityPluginBinding) {
        this.activityBinding = activityBinding
        activityBinding.addOnUserLeaveHintListener(userLeaveHintListener)
        activityBinding.addOnWindowFocusChangedListener { Log.d("PipHandler", "onWindowFocusChangedListener") }
        activityBinding.activity.registerComponentCallbacks(componentCallback)
        PlatformActivityService.INSTANCE.addCallback(pipCallback)
    }

    fun detachFromActivityBinding() {
        PlatformActivityService.INSTANCE.removeCallback(pipCallback)
        activityBinding?.removeOnUserLeaveHintListener(userLeaveHintListener)
        activityBinding?.activity?.unregisterComponentCallbacks(componentCallback)
    }


    @RequiresApi(Build.VERSION_CODES.O) //TODO: O
    fun enterPip(playerID: Int, result: MethodChannel.Result?) {
        Log.d("PipHandler", "enterPip")
        val didEnter = this.activityBinding?.activity?.enterPictureInPictureMode(
            android.app.PictureInPictureParams.Builder()
                .setSourceRectHint(Rect(100, 100, 100, 100))
                .build()
        ) ?: false

        //val tpv = THEOplayerViewNativeFactory.players[0];
        //Log.d("PipHandler", "enterPip: tpv: ${tpv.view.height}, ${tpv.view.width}, ${tpv.view.x}, ${tpv.view.y}")

        Log.d("PipHandler", "enterPip: didEnter: $didEnter")
        didEnteredPiP = didEnter
        playerInPip = playerID
        result?.success(didEnter);
    }

    fun exitPip(playerID: Int, result: MethodChannel.Result?) {
        Log.d("PipHandler", "exitPip");
        didEnteredPiP = false
        playerInPip = NO_PLAYER_IN_PIP
    }


}

interface PiPChangeListener {
    fun onEnterPiP(playerID: Int)
    fun onExitPiP(playerID: Int)
}