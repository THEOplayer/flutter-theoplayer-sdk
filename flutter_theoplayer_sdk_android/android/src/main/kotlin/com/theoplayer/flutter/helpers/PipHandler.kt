package com.theoplayer.flutter.helpers

import android.content.ComponentCallbacks2
import android.content.res.Configuration
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.core.util.forEach
import com.theoplayer.flutter.THEOplayerViewNativeFactory
import com.theoplayer.flutter.platform.PlatformActivityService
import com.theoplayer.flutter.platform.PlatformActivityServiceCallback
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry.UserLeaveHintListener

class PipHandler {
    private val NO_PLAYER_IN_PIP = -1

    private var activityBinding: ActivityPluginBinding? = null
    private var didEnteredPiP = false;
    private var playerInPip: Int = NO_PLAYER_IN_PIP

    private var pipActionHandler: PiPActionHandler? = null

    private val componentCallback = object : ComponentCallbacks2 {
        override fun onConfigurationChanged(newConfig: Configuration) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val isInPictureInPictureMode = activityBinding?.activity?.isInPictureInPictureMode ?: false
                Log.d("PipHandler", "onConfigurationChanged: didEnter: $didEnteredPiP, inPiP: $isInPictureInPictureMode")
                if (didEnteredPiP) {
                    if (!isInPictureInPictureMode) {
                        PlatformActivityService.INSTANCE.sendExitPictureInPicture()
                        exitPip(playerInPip, null);
                    } else {
                        //NOTE: we could trigger enterPiP from here too, e.g. this happens when the transition finished.
                        //PlatformActivityService.INSTANCE.sendUserLeaveHint()
                    }
                }
            }
        }

        override fun onLowMemory() {
        }

        override fun onTrimMemory(level: Int) {
        }
    }

    /**
     * Gets triggered when the user presses the home button
     */
    private val userLeaveHintListener = UserLeaveHintListener {
        Log.d("PipHandler", "userLeaveHintListener")
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            enterPipIfPossible()
        }
    }

    /**
     * Gets triggered if we receive a manual action from Flutter
     * NOTE: currently disabled due to differences in iOS and Android PiP
     */
    private val pipCallback = object : PlatformActivityServiceCallback {
        override fun doEnterPictureInPicture() {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                enterPipIfPossible()
            }
        }
    }

    fun attachToActivityBinding(activityBinding: ActivityPluginBinding) {
        this.activityBinding = activityBinding
        activityBinding.addOnUserLeaveHintListener(userLeaveHintListener)
        activityBinding.activity.registerComponentCallbacks(componentCallback)
        PlatformActivityService.INSTANCE.addCallback(pipCallback)
    }

    fun detachFromActivityBinding() {
        PlatformActivityService.INSTANCE.removeCallback(pipCallback)
        activityBinding?.removeOnUserLeaveHintListener(userLeaveHintListener)
        activityBinding?.activity?.unregisterComponentCallbacks(componentCallback)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun enterPipIfPossible() {
        findFirstPlayerThatCanEnterIntoPip()?.let {
            PlatformActivityService.INSTANCE.sendUserLeaveHint()
            Handler(Looper.getMainLooper()).post {
                enterPip(it, null)
            }
        }
    }

    private fun findFirstPlayerThatCanEnterIntoPip() : Int? {
        THEOplayerViewNativeFactory.players.forEach { id, player ->
            if (player.allowAutomaticPictureInPicture()) {
                return id
            }
        }
        return null
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun enterPip(playerID: Int, result: MethodChannel.Result?) {
        Log.d("PipHandler", "enterPip")

        val activity = activityBinding?.activity
        if (activity == null) {
            Log.w("PipHandler", "Activity is null, cannot enter PiP")
            result?.success(false);
            return
        }

        val player = THEOplayerViewNativeFactory.players[playerID]
        if ( player == null) {
            Log.w("PipHandler", "Player with $playerID is not available anymore, cannot enter PiP")
            result?.success(false);
            return
        }

        pipActionHandler = PiPActionHandler(player, activity)
        val didEnter = pipActionHandler!!.enterPiP()
        Log.d("PipHandler", "enterPip: didEnter: $didEnter")

        if (didEnter) {
            playerInPip = playerID
        } else {
            pipActionHandler!!.resetPiP()
        }

        didEnteredPiP = didEnter
        result?.success(didEnter);
    }

    @RequiresApi(Build.VERSION_CODES.O)
    fun exitPip(playerID: Int, result: MethodChannel.Result?) {
        Log.d("PipHandler", "exitPip");
        pipActionHandler?.resetPiP()
        didEnteredPiP = false
        playerInPip = NO_PLAYER_IN_PIP
    }
}
