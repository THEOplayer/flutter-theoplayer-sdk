package com.theoplayer.flutter

import com.theoplayer.android.api.event.EventListener
import com.theoplayer.android.api.event.track.mediatrack.video.ActiveQualityChangedEvent
import com.theoplayer.android.api.event.track.mediatrack.video.VideoTrackEventTypes
import com.theoplayer.android.api.event.track.mediatrack.video.TargetQualityChangedEvent
import com.theoplayer.android.api.event.track.mediatrack.video.list.AddTrackEvent
import com.theoplayer.android.api.event.track.mediatrack.video.list.VideoTrackListEventTypes
import com.theoplayer.android.api.event.track.mediatrack.video.list.RemoveTrackEvent
import com.theoplayer.android.api.event.track.mediatrack.video.list.TrackListChangeEvent
import com.theoplayer.android.api.event.track.mediatrack.quality.QualityEventTypes
import com.theoplayer.android.api.event.track.mediatrack.quality.QualityUpdateEvent
import com.theoplayer.android.api.player.Player
import com.theoplayer.android.api.player.track.mediatrack.MediaTrack
import com.theoplayer.android.api.player.track.mediatrack.quality.VideoQuality
import com.theoplayer.flutter.pigeon.THEOplayerFlutterVideoTracksAPI
import com.theoplayer.flutter.pigeon.THEOplayerNativeVideoTracksAPI
import com.theoplayer.flutter.pigeon.THEOplayerNativeVideoTracksAPI.Companion.setUp

class VideoTrackBridge(
    private val player: Player,
    pigeonMessenger: PigeonBinaryMessengerWrapper,
) : THEOplayerNativeVideoTracksAPI {

    private val flutterVideoTracksAPI = THEOplayerFlutterVideoTracksAPI(pigeonMessenger)

    init {
        setUp(pigeonMessenger, this)
    }

    private val emptyCallback: (Result<Unit>) -> Unit = {}

    private val addVideoTrackListener: EventListener<AddTrackEvent> = EventListener {
        flutterVideoTracksAPI.onAddVideoTrack(
            it.track.id,
            it.track.uid.toLong(),
            it.track.label,
            it.track.language,
            it.track.kind,
            it.track.isEnabled,
            emptyCallback
        )

        it.track.qualities?.forEach { quality ->
            flutterVideoTracksAPI.onVideoTrackAddQuality(
                it.track.uid.toLong(),
                quality.id,
                quality.uid.toLong(),
                quality.name,
                quality.bandwidth,
                quality.codecs,
                quality.width.toLong(),
                quality.height.toLong(),
                quality.frameRate,
                quality.firstFrame,
                emptyCallback
            )
        }

        attachTrackListeners(it.track)
    }

    private val removeVideoTrackListener = EventListener<RemoveTrackEvent> {
        removeTrackListeners(it.track)
        flutterVideoTracksAPI.onRemoveVideoTrack(it.track.uid.toLong(), emptyCallback)
    }

    private val videoTrackListChangeListener = EventListener<TrackListChangeEvent> {
        flutterVideoTracksAPI.onVideoTrackListChange(it.track.uid.toLong(), emptyCallback)
    }

    private fun videoTrackTargetQualityChangedListener(track: MediaTrack<VideoQuality>) = EventListener<TargetQualityChangedEvent> {
        flutterVideoTracksAPI.onTargetQualityChange(
            track.uid.toLong(),
            it.qualities.map { videoQuality -> videoQuality.uid.toLong() },
            it.quality?.uid?.toLong(),
            emptyCallback
        )
    }

    private fun videoTrackActiveQualityChangedListener(track: MediaTrack<VideoQuality>) = EventListener<ActiveQualityChangedEvent> {
        flutterVideoTracksAPI.onActiveQualityChange(track.uid.toLong(), it.quality.uid.toLong(), emptyCallback)
    }

    private fun videoQualityChangeListener(track: MediaTrack<VideoQuality>, quality: VideoQuality) = EventListener<QualityUpdateEvent> {
        flutterVideoTracksAPI.onQualityUpdate(
            track.uid.toLong(),
            quality.uid.toLong(),
            quality.name,
            quality.bandwidth,
            quality.codecs,
            quality.width.toLong(),
            quality.height.toLong(),
            quality.frameRate,
            quality.firstFrame,
            emptyCallback
        )
    }

    fun attachListeners() {
        player.videoTracks.addEventListener(VideoTrackListEventTypes.ADDTRACK, addVideoTrackListener)
        player.videoTracks.addEventListener(VideoTrackListEventTypes.REMOVETRACK, removeVideoTrackListener)
        player.videoTracks.addEventListener(VideoTrackListEventTypes.TRACKLISTCHANGE, videoTrackListChangeListener)
    }

    fun removeListeners() {
        player.videoTracks.removeEventListener(VideoTrackListEventTypes.ADDTRACK, addVideoTrackListener)
        player.videoTracks.removeEventListener(VideoTrackListEventTypes.REMOVETRACK, removeVideoTrackListener)
        player.videoTracks.removeEventListener(VideoTrackListEventTypes.TRACKLISTCHANGE, videoTrackListChangeListener)
        player.videoTracks.forEach { track ->
            removeTrackListeners(track)
        }
    }

    private fun attachTrackListeners(track: MediaTrack<VideoQuality>) {
        track.addEventListener(VideoTrackEventTypes.TARGETQUALITYCHANGEDEVENT, videoTrackTargetQualityChangedListener(track))
        track.addEventListener(VideoTrackEventTypes.ACTIVEQUALITYCHANGEDEVENT, videoTrackActiveQualityChangedListener(track))
        track.qualities?.forEach {
            attachQualityListeners(track, it)
        }
    }

    private fun removeTrackListeners(track: MediaTrack<VideoQuality>) {
        track.removeEventListener(VideoTrackEventTypes.TARGETQUALITYCHANGEDEVENT, videoTrackTargetQualityChangedListener(track))
        track.removeEventListener(VideoTrackEventTypes.ACTIVEQUALITYCHANGEDEVENT, videoTrackActiveQualityChangedListener(track))
        track.qualities?.forEach {
            removeQualityListeners(track, it)
        }
    }

    private fun attachQualityListeners(track: MediaTrack<VideoQuality>, quality: VideoQuality) {
        quality.addEventListener(QualityEventTypes.UPDATE, videoQualityChangeListener(track, quality))
    }

    private fun removeQualityListeners(track: MediaTrack<VideoQuality>, quality: VideoQuality) {
        quality.removeEventListener(QualityEventTypes.UPDATE, videoQualityChangeListener(track, quality))
    }

    override fun setTargetQuality(videoTrackUid: Long, qualityUid: Long?) {
        val videoTrack = player.videoTracks.find { it.uid.toLong() == videoTrackUid }
        val videoQuality = videoTrack?.qualities?.find { it.uid.toLong() == qualityUid }
        videoTrack?.targetQuality = videoQuality
    }

    override fun setTargetQualities(videoTrackUid: Long, qualitiesUid: List<Long>?) {
        val videoTrack = player.videoTracks.find { it.uid.toLong() == videoTrackUid }
        val videoQualities = videoTrack?.qualities?.filter { qualitiesUid?.contains(it.uid.toLong()) == true }
        videoTrack?.setTargetQualities(videoQualities)
    }

    override fun setEnabled(videoTrackUid: Long, enabled: Boolean) {
        val videoTrack = player.videoTracks.find { it.uid.toLong() == videoTrackUid }
        videoTrack?.isEnabled = enabled
    }

}
