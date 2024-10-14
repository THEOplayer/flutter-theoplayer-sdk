package com.theoplayer.flutter

import com.theoplayer.android.api.event.EventListener
import com.theoplayer.android.api.event.player.CanPlayEvent
import com.theoplayer.android.api.event.player.CanPlayThroughEvent
import com.theoplayer.android.api.event.player.DestroyEvent
import com.theoplayer.android.api.event.player.DurationChangeEvent
import com.theoplayer.android.api.event.player.EndedEvent
import com.theoplayer.android.api.event.player.ErrorEvent
import com.theoplayer.android.api.event.player.LoadStartEvent
import com.theoplayer.android.api.event.player.LoadedDataEvent
import com.theoplayer.android.api.event.player.LoadedMetadataEvent
import com.theoplayer.android.api.event.player.PauseEvent
import com.theoplayer.android.api.event.player.PlayEvent
import com.theoplayer.android.api.event.player.PlayerEventTypes
import com.theoplayer.android.api.event.player.PlayingEvent
import com.theoplayer.android.api.event.player.ProgressEvent
import com.theoplayer.android.api.event.player.RateChangeEvent
import com.theoplayer.android.api.event.player.ReadyStateChangeEvent
import com.theoplayer.android.api.event.player.ResizeEvent
import com.theoplayer.android.api.event.player.SeekedEvent
import com.theoplayer.android.api.event.player.SeekingEvent
import com.theoplayer.android.api.event.player.SourceChangeEvent
import com.theoplayer.android.api.event.player.TimeUpdateEvent
import com.theoplayer.android.api.event.player.VolumeChangeEvent
import com.theoplayer.android.api.event.player.WaitingEvent
import com.theoplayer.android.api.player.Player
import com.theoplayer.flutter.pigeon.THEOplayerFlutterAPI
import com.theoplayer.flutter.transformers.PlayerEnumTransformer
import com.theoplayer.flutter.transformers.SourceTransformer

class PlayerEventForwarder(
    private val player: Player,
    private val flutterAPI: THEOplayerFlutterAPI
) {
    private val emptyCallback: (Result<Unit>) -> Unit = {}

    private val sourceChangeEventListener = EventListener<SourceChangeEvent> {
        flutterAPI.onSourceChange(SourceTransformer.toFlutterSourceDescription(it.source), emptyCallback)
    }

    private val playEventListener = EventListener<PlayEvent> {
        flutterAPI.onPlay(it.currentTime, emptyCallback)
    }

    private val playingEventListener = EventListener<PlayingEvent> {
        flutterAPI.onPlaying(it.currentTime, emptyCallback)
    }

    private val pauseEventListener = EventListener<PauseEvent> {
        flutterAPI.onPause(it.currentTime, emptyCallback)
    }

    private val waitingEventListener = EventListener<WaitingEvent> {
        flutterAPI.onWaiting(it.currentTime.toDouble(), emptyCallback)
    }

    private val durationChangeEventListener = EventListener<DurationChangeEvent> {
        flutterAPI.onDurationChange(it.duration, emptyCallback)
    }

    private val progressEventListener = EventListener<ProgressEvent> {
        flutterAPI.onProgress(it.currentTime, emptyCallback)
    }

    private val timeUpdateEventListener = EventListener<TimeUpdateEvent> {
        flutterAPI.onTimeUpdate(it.currentTime, it.currentProgramDateTime?.time, emptyCallback)
    }

    private val rateChangeEventListener = EventListener<RateChangeEvent> {
        flutterAPI.onRateChange(it.currentTime, it.playbackRate, emptyCallback)
    }

    private val seekingEventListener = EventListener<SeekingEvent> {
        flutterAPI.onSeeking(it.currentTime, emptyCallback)
    }

    private val seekedEventListener = EventListener<SeekedEvent> {
        flutterAPI.onSeeked(it.currentTime, emptyCallback)
    }

    private val volumeChangeEventListener = EventListener<VolumeChangeEvent> {
        flutterAPI.onVolumeChange(it.currentTime, it.volume, emptyCallback)
    }

    private val resizeEventListener = EventListener<ResizeEvent> {
        flutterAPI.onResize(it.currentTime, it.width.toLong(), it.height.toLong(), emptyCallback)
    }

    private val endedEventListener = EventListener<EndedEvent> {
        flutterAPI.onEnded(it.currentTime, emptyCallback)
    }

    private val errorEventListener = EventListener<ErrorEvent> {
        flutterAPI.onError(it.errorObject.toString(), emptyCallback)
    }

    private val destroyEventListener = EventListener<DestroyEvent> {
        flutterAPI.onDestroy(emptyCallback)
    }

    private val readyStateChangeEventListener = EventListener<ReadyStateChangeEvent> {
        flutterAPI.onReadyStateChange(it.currentTime, PlayerEnumTransformer.toFlutterReadyState(it.readyState), emptyCallback)
    }

    private val loadStartEventListener = EventListener<LoadStartEvent> {
        flutterAPI.onLoadStart(emptyCallback)
    }

    private val loadedMetadataEventListener = EventListener<LoadedMetadataEvent> {
        flutterAPI.onLoadedMetadata(it.currentTime, emptyCallback)
    }

    private val loadedDataEventListener = EventListener<LoadedDataEvent> {
        flutterAPI.onLoadedData(it.currentTime.toDouble(), emptyCallback)
    }

    private val canPlayEventListener = EventListener<CanPlayEvent> {
        flutterAPI.onCanPlay(it.currentTime, emptyCallback)
    }

    private val canPlayThroughEventListener = EventListener<CanPlayThroughEvent> {
        flutterAPI.onCanPlayThrough(it.currentTime, emptyCallback)
    }

    fun attachListeners() {
        player.addEventListener(PlayerEventTypes.SOURCECHANGE, sourceChangeEventListener)
        player.addEventListener(PlayerEventTypes.PLAY, playEventListener)
        player.addEventListener(PlayerEventTypes.PLAYING, playingEventListener)
        player.addEventListener(PlayerEventTypes.PAUSE, pauseEventListener)
        player.addEventListener(PlayerEventTypes.WAITING, waitingEventListener)
        player.addEventListener(PlayerEventTypes.DURATIONCHANGE, durationChangeEventListener)
        player.addEventListener(PlayerEventTypes.PROGRESS, progressEventListener)
        player.addEventListener(PlayerEventTypes.TIMEUPDATE, timeUpdateEventListener)
        player.addEventListener(PlayerEventTypes.RATECHANGE, rateChangeEventListener)
        player.addEventListener(PlayerEventTypes.SEEKING, seekingEventListener)
        player.addEventListener(PlayerEventTypes.SEEKED, seekedEventListener)
        player.addEventListener(PlayerEventTypes.VOLUMECHANGE, volumeChangeEventListener)
        player.addEventListener(PlayerEventTypes.RESIZE, resizeEventListener)
        player.addEventListener(PlayerEventTypes.ENDED, endedEventListener)
        player.addEventListener(PlayerEventTypes.ERROR, errorEventListener)
        player.addEventListener(PlayerEventTypes.DESTROY, destroyEventListener)
        player.addEventListener(PlayerEventTypes.READYSTATECHANGE, readyStateChangeEventListener)
        player.addEventListener(PlayerEventTypes.LOADSTART, loadStartEventListener)
        player.addEventListener(PlayerEventTypes.LOADEDMETADATA, loadedMetadataEventListener)
        player.addEventListener(PlayerEventTypes.LOADEDDATA, loadedDataEventListener)
        player.addEventListener(PlayerEventTypes.CANPLAY, canPlayEventListener)
        player.addEventListener(PlayerEventTypes.CANPLAYTHROUGH, canPlayThroughEventListener)
    }

    fun removeListeners() {
        player.removeEventListener(PlayerEventTypes.SOURCECHANGE, sourceChangeEventListener)
        player.removeEventListener(PlayerEventTypes.PLAY, playEventListener)
        player.removeEventListener(PlayerEventTypes.PLAYING, playingEventListener)
        player.removeEventListener(PlayerEventTypes.PAUSE, pauseEventListener)
        player.removeEventListener(PlayerEventTypes.WAITING, waitingEventListener)
        player.removeEventListener(PlayerEventTypes.DURATIONCHANGE, durationChangeEventListener)
        player.removeEventListener(PlayerEventTypes.PROGRESS, progressEventListener)
        player.removeEventListener(PlayerEventTypes.TIMEUPDATE, timeUpdateEventListener)
        player.removeEventListener(PlayerEventTypes.RATECHANGE, rateChangeEventListener)
        player.removeEventListener(PlayerEventTypes.SEEKING, seekingEventListener)
        player.removeEventListener(PlayerEventTypes.SEEKED, seekedEventListener)
        player.removeEventListener(PlayerEventTypes.VOLUMECHANGE, volumeChangeEventListener)
        player.removeEventListener(PlayerEventTypes.RESIZE, resizeEventListener)
        player.removeEventListener(PlayerEventTypes.ENDED, endedEventListener)
        player.removeEventListener(PlayerEventTypes.ERROR, errorEventListener)
        player.removeEventListener(PlayerEventTypes.DESTROY, destroyEventListener)
        player.removeEventListener(PlayerEventTypes.READYSTATECHANGE, readyStateChangeEventListener)
        player.removeEventListener(PlayerEventTypes.LOADSTART, loadStartEventListener)
        player.removeEventListener(PlayerEventTypes.LOADEDMETADATA, loadedMetadataEventListener)
        player.removeEventListener(PlayerEventTypes.LOADEDDATA, loadedDataEventListener)
        player.removeEventListener(PlayerEventTypes.CANPLAY, canPlayEventListener)
        player.removeEventListener(PlayerEventTypes.CANPLAYTHROUGH, canPlayThroughEventListener)
    }
}