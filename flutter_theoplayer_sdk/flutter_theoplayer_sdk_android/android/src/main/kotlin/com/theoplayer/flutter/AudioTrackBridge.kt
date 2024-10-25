package com.theoplayer.flutter

import com.theoplayer.android.api.event.EventListener
import com.theoplayer.android.api.event.track.mediatrack.audio.ActiveQualityChangedEvent
import com.theoplayer.android.api.event.track.mediatrack.audio.AudioTrackEventTypes
import com.theoplayer.android.api.event.track.mediatrack.audio.TargetQualityChangedEvent
import com.theoplayer.android.api.event.track.mediatrack.audio.list.AddTrackEvent
import com.theoplayer.android.api.event.track.mediatrack.audio.list.AudioTrackListEventTypes
import com.theoplayer.android.api.event.track.mediatrack.audio.list.RemoveTrackEvent
import com.theoplayer.android.api.event.track.mediatrack.audio.list.TrackListChangeEvent
import com.theoplayer.android.api.event.track.mediatrack.quality.QualityEventTypes
import com.theoplayer.android.api.event.track.mediatrack.quality.QualityUpdateEvent
import com.theoplayer.android.api.player.Player
import com.theoplayer.android.api.player.track.mediatrack.MediaTrack
import com.theoplayer.android.api.player.track.mediatrack.quality.AudioQuality
import com.theoplayer.flutter.pigeon.THEOplayerFlutterAudioTracksAPI
import com.theoplayer.flutter.pigeon.THEOplayerNativeAudioTracksAPI
import com.theoplayer.flutter.pigeon.THEOplayerNativeAudioTracksAPI.Companion.setUp

class AudioTrackBridge(
    private val player: Player,
    pigeonMessenger: PigeonBinaryMessengerWrapper,
) : THEOplayerNativeAudioTracksAPI {

    private val flutterAudioTracksAPI = THEOplayerFlutterAudioTracksAPI(pigeonMessenger)

    init {
        setUp(pigeonMessenger, this)
    }

    private val emptyCallback: (Result<Unit>) -> Unit = {}

    private val addAudioTrackListener: EventListener<AddTrackEvent> = EventListener {
        flutterAudioTracksAPI.onAddAudioTrack(
            it.track.id,
            it.track.uid.toLong(),
            it.track.label,
            it.track.language,
            it.track.kind,
            it.track.isEnabled,
            emptyCallback
        )

        it.track.qualities?.forEach { quality ->
            flutterAudioTracksAPI.onAudioTrackAddQuality(
                it.track.uid.toLong(),
                quality.id,
                quality.uid.toLong(),
                quality.name,
                quality.bandwidth,
                quality.codecs,
                quality.audioSamplingRate,
                emptyCallback
            )
        }

        attachTrackListeners(it.track)
    }

    private val removeAudioTrackListener = EventListener<RemoveTrackEvent> {
        removeTrackListeners(it.track)
        flutterAudioTracksAPI.onRemoveAudioTrack(it.track.uid.toLong(), emptyCallback)
    }

    private val audioTrackListChangeListener = EventListener<TrackListChangeEvent> {
        flutterAudioTracksAPI.onAudioTrackListChange(it.track.uid.toLong(), emptyCallback)
    }

    private fun audioTrackTargetQualityChangedListener(track: MediaTrack<AudioQuality>) = EventListener<TargetQualityChangedEvent> {
        flutterAudioTracksAPI.onTargetQualityChange(
            track.uid.toLong(),
            it.qualities.map { audioQuality -> audioQuality.uid.toLong() },
            it.quality?.uid?.toLong(),
            emptyCallback
        )
    }

    private fun audioTrackActiveQualityChangedListener(track: MediaTrack<AudioQuality>) = EventListener<ActiveQualityChangedEvent> {
        flutterAudioTracksAPI.onActiveQualityChange(track.uid.toLong(), it.quality.uid.toLong(), emptyCallback)
    }

    private fun audioQualityChangeListener(track: MediaTrack<AudioQuality>, quality: AudioQuality) = EventListener<QualityUpdateEvent> {
        flutterAudioTracksAPI.onQualityUpdate(
            track.uid.toLong(),
            quality.uid.toLong(),
            quality.name,
            quality.bandwidth,
            quality.codecs,
            quality.audioSamplingRate,
            emptyCallback
        )
    }

    fun attachListeners() {
        player.audioTracks.addEventListener(AudioTrackListEventTypes.ADDTRACK, addAudioTrackListener)
        player.audioTracks.addEventListener(AudioTrackListEventTypes.REMOVETRACK, removeAudioTrackListener)
        player.audioTracks.addEventListener(AudioTrackListEventTypes.TRACKLISTCHANGE, audioTrackListChangeListener)
    }

    fun removeListeners() {
        player.audioTracks.removeEventListener(AudioTrackListEventTypes.ADDTRACK, addAudioTrackListener)
        player.audioTracks.removeEventListener(AudioTrackListEventTypes.REMOVETRACK, removeAudioTrackListener)
        player.audioTracks.removeEventListener(AudioTrackListEventTypes.TRACKLISTCHANGE, audioTrackListChangeListener)
        player.audioTracks.forEach { track ->
            removeTrackListeners(track)
        }
    }

    private fun attachTrackListeners(track: MediaTrack<AudioQuality>) {
        track.addEventListener(AudioTrackEventTypes.TARGETQUALITYCHANGEDEVENT, audioTrackTargetQualityChangedListener(track))
        track.addEventListener(AudioTrackEventTypes.ACTIVEQUALITYCHANGEDEVENT, audioTrackActiveQualityChangedListener(track))
        track.qualities?.forEach {
            attachQualityListeners(track, it)
        }
    }

    private fun removeTrackListeners(track: MediaTrack<AudioQuality>) {
        track.removeEventListener(AudioTrackEventTypes.TARGETQUALITYCHANGEDEVENT, audioTrackTargetQualityChangedListener(track))
        track.removeEventListener(AudioTrackEventTypes.ACTIVEQUALITYCHANGEDEVENT, audioTrackActiveQualityChangedListener(track))
        track.qualities?.forEach {
            removeQualityListeners(track, it)
        }
    }

    private fun attachQualityListeners(track: MediaTrack<AudioQuality>, quality: AudioQuality) {
        quality.addEventListener(QualityEventTypes.UPDATE, audioQualityChangeListener(track, quality))
    }

    private fun removeQualityListeners(track: MediaTrack<AudioQuality>, quality: AudioQuality) {
        quality.removeEventListener(QualityEventTypes.UPDATE, audioQualityChangeListener(track, quality))
    }

    override fun setTargetQuality(audioTrackUid: Long, qualityUid: Long?) {
        val audioTrack = player.audioTracks.find { it.uid.toLong() == audioTrackUid }
        val audioQuality = audioTrack?.qualities?.find { it.uid.toLong() == qualityUid }
        audioTrack?.targetQuality = audioQuality
    }

    override fun setTargetQualities(audioTrackUid: Long, qualitiesUid: List<Long>?) {
        val audioTrack = player.audioTracks.find { it.uid.toLong() == audioTrackUid }
        val audioQualities = audioTrack?.qualities?.filter { qualitiesUid?.contains(it.uid.toLong()) == true }
        audioTrack?.setTargetQualities(audioQualities)
    }

    override fun setEnabled(audioTrackUid: Long, enabled: Boolean) {
        val audioTrack = player.audioTracks.find { it.uid.toLong() == audioTrackUid }
        audioTrack?.isEnabled = enabled
    }

}
