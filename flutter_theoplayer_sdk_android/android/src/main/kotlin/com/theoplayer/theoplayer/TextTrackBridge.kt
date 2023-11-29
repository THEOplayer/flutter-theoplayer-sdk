package com.theoplayer.theoplayer

import com.theoplayer.android.api.event.EventListener
import com.theoplayer.android.api.event.track.texttrack.AddCueEvent
import com.theoplayer.android.api.event.track.texttrack.ChangeEvent
import com.theoplayer.android.api.event.track.texttrack.CueChangeEvent
import com.theoplayer.android.api.event.track.texttrack.EnterCueEvent
import com.theoplayer.android.api.event.track.texttrack.ExitCueEvent
import com.theoplayer.android.api.event.track.texttrack.RemoveCueEvent
import com.theoplayer.android.api.event.track.texttrack.TextTrackEventTypes
import com.theoplayer.android.api.event.track.texttrack.list.AddTrackEvent
import com.theoplayer.android.api.event.track.texttrack.list.RemoveTrackEvent
import com.theoplayer.android.api.event.track.texttrack.list.TextTrackListEventTypes
import com.theoplayer.android.api.event.track.texttrack.list.TrackListChangeEvent
import com.theoplayer.android.api.event.track.texttrack.texttrackcue.EnterEvent
import com.theoplayer.android.api.event.track.texttrack.texttrackcue.ExitEvent
import com.theoplayer.android.api.event.track.texttrack.texttrackcue.TextTrackCueEventTypes
import com.theoplayer.android.api.event.track.texttrack.texttrackcue.UpdateEvent
import com.theoplayer.android.api.player.Player
import com.theoplayer.android.api.player.track.texttrack.TextTrack
import com.theoplayer.android.api.player.track.texttrack.cue.TextTrackCue
import com.theoplayer.theoplayer.pigeon.THEOplayerFlutterTextTracksAPI
import com.theoplayer.theoplayer.pigeon.THEOplayerNativeTextTracksAPI
import com.theoplayer.theoplayer.pigeon.THEOplayerNativeTextTracksAPI.Companion.setUp
import com.theoplayer.theoplayer.transformers.FlutterTextTrackMode
import com.theoplayer.theoplayer.transformers.TrackTransformer

class TextTrackBridge(
    private val player: Player,
    pigeonMessenger: PigeonBinaryMessengerWrapper,
) : THEOplayerNativeTextTracksAPI {

    private val flutterTextTracksAPI = THEOplayerFlutterTextTracksAPI(pigeonMessenger)

    init {
        setUp(pigeonMessenger, this)
    }

    private val emptyCallback: (Result<Unit>) -> Unit = {}

    private val addTextTrackListener: EventListener<AddTrackEvent> = EventListener {
        flutterTextTracksAPI.onAddTextTrack(
            it.track.id,
            it.track.uid.toLong(),
            it.track.label,
            it.track.language,
            it.track.kind,
            it.track.inBandMetadataTrackDispatchType,
            TrackTransformer.toFlutterTextTrackReadyState(it.track.readyState),
            TrackTransformer.toFlutterTextTrackType(it.track.type),
            it.track.source,
            it.track.isForced,
            TrackTransformer.toFlutterTextTrackMode(it.track.mode),
            emptyCallback
        )
        attachTrackListeners(it.track)
    }

    private val removeTextTrackListener = EventListener<RemoveTrackEvent> {
        removeTrackListeners(it.track)
        flutterTextTracksAPI.onRemoveTextTrack(it.track.uid.toLong(), emptyCallback)
    }

    private val textTrackListChangeListener = EventListener<TrackListChangeEvent> {
        flutterTextTracksAPI.onTextTrackListChange(it.track.uid.toLong(), emptyCallback)
    }

    private val textTrackAddCueListener = EventListener<AddCueEvent> {
        flutterTextTracksAPI.onTextTrackAddCue(it.track.uid.toLong(), it.cue.id, it.cue.uid, it.cue.startTime, it.cue.endTime, it.cue.content.toString(), emptyCallback)
        attachCueListeners(it.track, it.cue)
    }

    private val textTrackRemoveCueListener = EventListener<RemoveCueEvent> {
        removeCueListeners(it.track, it.cue)
        flutterTextTracksAPI.onTextTrackRemoveCue(it.track.uid.toLong(), it.cue.uid, emptyCallback)
    }

    private fun textTrackEnterCueListener(track: TextTrack) = EventListener<EnterCueEvent> {
        flutterTextTracksAPI.onTextTrackEnterCue(track.uid.toLong(), it.cue.uid, emptyCallback)
    }

    private fun textTrackExitCueListener(track: TextTrack) = EventListener<ExitCueEvent> {
        flutterTextTracksAPI.onTextTrackExitCue(track.uid.toLong(), it.cue.uid, emptyCallback)
    }

    private val textTrackCueChangeListener = EventListener<CueChangeEvent> {
        flutterTextTracksAPI.onTextTrackCueChange(it.textTrack.uid.toLong(), emptyCallback)
    }

    private val textTrackChangeListener = EventListener<ChangeEvent> {
        flutterTextTracksAPI.onTextTrackChange(it.track.uid.toLong(), emptyCallback)
    }

    private fun cueEnterListener(track: TextTrack) = EventListener<EnterEvent> {
        flutterTextTracksAPI.onCueEnter(track.uid.toLong(), it.cue.uid, emptyCallback)
    }

    private fun cueExitListener(track: TextTrack) = EventListener<ExitEvent> {
        flutterTextTracksAPI.onCueExit(track.uid.toLong(), it.cue.uid, emptyCallback)
    }

    private fun cueUpdateListener(track: TextTrack) = EventListener<UpdateEvent> {
        flutterTextTracksAPI.onCueUpdate(track.uid.toLong(), it.cue.uid, it.cue.endTime, it.cue.content.toString(), emptyCallback)
    }

    fun attachListeners() {
        player.textTracks.addEventListener(TextTrackListEventTypes.ADDTRACK, addTextTrackListener)
        player.textTracks.addEventListener(TextTrackListEventTypes.REMOVETRACK, removeTextTrackListener)
        player.textTracks.addEventListener(TextTrackListEventTypes.TRACKLISTCHANGE, textTrackListChangeListener)
    }

    fun removeListeners() {
        player.textTracks.removeEventListener(TextTrackListEventTypes.ADDTRACK, addTextTrackListener)
        player.textTracks.removeEventListener(TextTrackListEventTypes.REMOVETRACK, removeTextTrackListener)
        player.textTracks.removeEventListener(TextTrackListEventTypes.TRACKLISTCHANGE, textTrackListChangeListener)

        player.textTracks.forEach { track ->
            removeTrackListeners(track)
        }
    }

    private fun attachTrackListeners(track: TextTrack) {
        track.addEventListener(TextTrackEventTypes.ADDCUE, textTrackAddCueListener)
        track.addEventListener(TextTrackEventTypes.REMOVECUE, textTrackRemoveCueListener)
        track.addEventListener(TextTrackEventTypes.ENTERCUE, textTrackEnterCueListener(track))
        track.addEventListener(TextTrackEventTypes.EXITCUE, textTrackExitCueListener(track))
        track.addEventListener(TextTrackEventTypes.CUECHANGE, textTrackCueChangeListener)
        track.addEventListener(TextTrackEventTypes.CHANGE, textTrackChangeListener)
    }

    private fun removeTrackListeners(track: TextTrack) {
        track.removeEventListener(TextTrackEventTypes.ADDCUE, textTrackAddCueListener)
        track.removeEventListener(TextTrackEventTypes.REMOVECUE, textTrackRemoveCueListener)
        track.removeEventListener(TextTrackEventTypes.ENTERCUE, textTrackEnterCueListener(track))
        track.removeEventListener(TextTrackEventTypes.EXITCUE, textTrackExitCueListener(track))
        track.removeEventListener(TextTrackEventTypes.CUECHANGE, textTrackCueChangeListener)
        track.removeEventListener(TextTrackEventTypes.CHANGE, textTrackChangeListener)
        track.cues?.forEach { cue ->
            removeCueListeners(track, cue)
        }
    }

    private fun attachCueListeners(track: TextTrack, cue: TextTrackCue) {
        cue.addEventListener(TextTrackCueEventTypes.ENTER, cueEnterListener(track))
        cue.addEventListener(TextTrackCueEventTypes.EXIT, cueExitListener(track))
        cue.addEventListener(TextTrackCueEventTypes.UPDATE, cueUpdateListener(track))
    }

    private fun removeCueListeners(track: TextTrack, cue: TextTrackCue) {
        cue.removeEventListener(TextTrackCueEventTypes.ENTER, cueEnterListener(track))
        cue.removeEventListener(TextTrackCueEventTypes.EXIT, cueExitListener(track))
        cue.removeEventListener(TextTrackCueEventTypes.UPDATE, cueUpdateListener(track))
    }

    override fun setMode(textTrackUid: Long, mode: FlutterTextTrackMode) {
        player.textTracks
            .first { it.uid == textTrackUid.toInt() }
            .mode = TrackTransformer.toTextTrackMode(mode)
    }

}