package com.theoplayer.flutter.helpers

import android.app.Activity
import android.app.PendingIntent
import android.app.PictureInPictureParams
import android.app.RemoteAction
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.graphics.drawable.Icon
import android.os.Build
import androidx.annotation.RequiresApi
import com.theoplayer.android.R
import com.theoplayer.android.api.event.EventListener
import com.theoplayer.android.api.event.player.PlayerEvent
import com.theoplayer.android.api.event.player.PlayerEventTypes
import com.theoplayer.flutter.BuildConfig
import com.theoplayer.flutter.THEOplayerViewNative
import com.theoplayer.flutter.platform.PlatformActivityService

@RequiresApi(Build.VERSION_CODES.O)
class PiPActionHandler(private val theoPlayerViewNative: THEOplayerViewNative, private val activity: Activity) {

    object Constants {
        object PlayerAction {
            val PLAY = 0
            val PAUSE = 1
        }

        object Intent {
            val ACTION_MEDIA_CONTROL = "media_control"
            val EXTRA_ACTION = "media_control"
        }
    }

    private var stateChangeEventListener = EventListener<PlayerEvent<*>> {
        activity.setPictureInPictureParams(getPipParams(theoPlayerViewNative))
    }

    private var broadcastReceiver: BroadcastReceiver? = null

    fun enterPiP(): Boolean {

        broadcastReceiver = createBroadcastReceiver()

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            activity.registerReceiver(broadcastReceiver, IntentFilter(Constants.Intent.ACTION_MEDIA_CONTROL), Context.RECEIVER_NOT_EXPORTED)
        } else {
            activity.registerReceiver(broadcastReceiver, IntentFilter(Constants.Intent.ACTION_MEDIA_CONTROL))
        }

        Logger.logVerbose(Logger.TAG.PictureInPicture, "Putting Activity into PiP Mode")

        attachStateChangeListeners()

        return activity.enterPictureInPictureMode(getPipParams(player = theoPlayerViewNative))

    }

    fun resetPiP() {
        if (broadcastReceiver != null) {
            activity.unregisterReceiver(broadcastReceiver)
            broadcastReceiver = null
        }
        removeStateChangeListeners()
    }

    private fun attachStateChangeListeners() {
        theoPlayerViewNative.getUnderlyingPlayer().addEventListener(PlayerEventTypes.PLAY, stateChangeEventListener)
        theoPlayerViewNative.getUnderlyingPlayer().addEventListener(PlayerEventTypes.PLAYING, stateChangeEventListener)
        theoPlayerViewNative.getUnderlyingPlayer().addEventListener(PlayerEventTypes.PAUSE, stateChangeEventListener)
        theoPlayerViewNative.getUnderlyingPlayer().addEventListener(PlayerEventTypes.ENDED, stateChangeEventListener)
        theoPlayerViewNative.getUnderlyingPlayer().addEventListener(PlayerEventTypes.SOURCECHANGE, stateChangeEventListener
        )
    }

    private fun removeStateChangeListeners() {
        theoPlayerViewNative.getUnderlyingPlayer().removeEventListener(PlayerEventTypes.PLAY, stateChangeEventListener)
        theoPlayerViewNative.getUnderlyingPlayer().removeEventListener(PlayerEventTypes.PLAYING, stateChangeEventListener)
        theoPlayerViewNative.getUnderlyingPlayer().removeEventListener(PlayerEventTypes.PAUSE, stateChangeEventListener)
        theoPlayerViewNative.getUnderlyingPlayer().removeEventListener(PlayerEventTypes.ENDED, stateChangeEventListener)
        theoPlayerViewNative.getUnderlyingPlayer().removeEventListener(PlayerEventTypes.SOURCECHANGE, stateChangeEventListener)
    }

    fun getPipParams(player: THEOplayerViewNative): PictureInPictureParams {
        val actions = ArrayList<RemoteAction>()

        if (player.isPaused() || player.isEnded()) {
            // if paused or ended, then icon should show the 'play-triangle'.
            actions.add(
                createAction(
                    "Play",
                    "Play content",
                    Constants.PlayerAction.PLAY,
                    R.drawable.quantum_ic_play_arrow_white_24
                )
            )
        } else {
            actions.add(
                createAction(
                    "Pause",
                    "Pause content",
                    Constants.PlayerAction.PAUSE,
                    R.drawable.quantum_ic_pause_white_24
                )
            )
        }

        return PictureInPictureParams.Builder()
            .setActions(actions)
            .build()
    }

    private fun createAction(title: String, contentDescription: String, actionId: Int, iconId: Int): RemoteAction {
        val intent =
            PendingIntent.getBroadcast(
                activity,
                actionId,  // receiver will check this value
                Intent(Constants.Intent.ACTION_MEDIA_CONTROL)
                    .putExtra(Constants.Intent.EXTRA_ACTION, actionId)
                    .setPackage(activity.packageName),  // receiver will listen only to this type (see registerReceiver)
                PendingIntent.FLAG_IMMUTABLE
            )

        val icon: Icon = Icon.createWithResource(activity, iconId)
        return RemoteAction(icon, title, contentDescription, intent)
    }

    private fun createBroadcastReceiver(): BroadcastReceiver {
        return object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {

                when (intent.getIntExtra(Constants.Intent.EXTRA_ACTION, -1)) {
                    Constants.PlayerAction.PLAY -> {
                        Logger.logVerbose(Logger.TAG.PictureInPicture, "Calling play on PiP window")
                        // instead of calling play() here on the native player, we pipe it back to Flutter to trigger the complete flow
                        // TODO: revisit this later
                        PlatformActivityService.INSTANCE.sendPlayActionReceived()
                    }

                    Constants.PlayerAction.PAUSE -> {
                        Logger.logVerbose(Logger.TAG.PictureInPicture, "Calling pause on PiP window")
                        // instead of calling pause() here on the native player, we pipe it back to Flutter to trigger the complete flow
                        // TODO: revisit this later
                        PlatformActivityService.INSTANCE.sendPauseActionReceived()
                    }

                    -1 -> if (BuildConfig.DEBUG) {
                        Logger.logDebug(Logger.TAG.PictureInPicture, "onReceive: Received invalid action code")
                    }
                }
            }
        }
    }
}