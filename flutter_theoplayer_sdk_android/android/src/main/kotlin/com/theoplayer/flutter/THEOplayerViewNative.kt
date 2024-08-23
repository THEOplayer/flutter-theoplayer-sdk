package com.theoplayer.flutter

import android.content.Context
import android.os.Build
import android.util.Log
import android.view.Surface
import android.view.View
import android.view.ViewGroup
import android.widget.LinearLayout
import com.theoplayer.android.api.THEOplayerConfig
import com.theoplayer.android.api.THEOplayerView
import com.theoplayer.android.api.event.EventListener
import com.theoplayer.android.api.event.player.PlayerEventTypes
import com.theoplayer.android.api.event.player.PlayingEvent
import com.theoplayer.android.api.pip.PipConfiguration
import com.theoplayer.flutter.pigeon.THEOplayerFlutterAPI
import com.theoplayer.flutter.pigeon.THEOplayerNativeAPI
import com.theoplayer.flutter.pigeon.THEOplayerNativeAPI.Companion.setUp
import com.theoplayer.flutter.transformers.PlayerEnumTransformer
import com.theoplayer.flutter.transformers.SourceTransformer
import com.theoplayer.flutter.transformers.TimeRangeTransformer
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView
import io.flutter.view.TextureRegistry
import io.flutter.view.TextureRegistry.SurfaceProducer
import io.flutter.view.TextureRegistry.SurfaceTextureEntry
import java.util.Date

typealias FlutterSourceDescription = com.theoplayer.flutter.pigeon.SourceDescription
typealias FlutterReadyState = com.theoplayer.flutter.pigeon.ReadyState
typealias FlutterPreloadType = com.theoplayer.flutter.pigeon.PreloadType
typealias FlutterTimeRange = com.theoplayer.flutter.pigeon.TimeRange

class THEOplayerViewNative(
    context: Context,
    val id: Int,
    creationParams: Map<String, Any>?,
    messenger: BinaryMessenger
) : PlatformView, THEOplayerNativeAPI {

    constructor(context: Context, entry: TextureRegistry.TextureEntry, creationParams: Map<String, Any>?, messenger: BinaryMessenger) : this(context, entry.id().toInt(), creationParams, messenger) {
        surfaceEntry = entry;
    }

    private var surfaceEntry: TextureRegistry.TextureEntry? = null

    private val theoplayerWrapper: LinearLayout
    private val tpv: THEOplayerView
    private val pigeonMessenger: PigeonBinaryMessengerWrapper
    private val flutterAPI: THEOplayerFlutterAPI
    private val playerEventForwarder: PlayerEventForwarder
    private val textTrackBridge: TextTrackBridge
    private val audioTrackBridge: AudioTrackBridge
    private val videoTrackBridge: VideoTrackBridge

    private var surface: Surface? = null;

    var destroyListener: DestroyListener? = null;

    // Workaround to eliminate the initial transparent layout with initExpensiveAndroidView
    // TODO: remove it once initExpensiveAndroidView is not used.
    private var useHybridComposition: Boolean = false
    private var isFirstPlaying: Boolean = false
        set(value) {
            if (!useHybridComposition) {
                return
            }

            if (value) {
                tpv.visibility = View.VISIBLE
            } else {
                tpv.visibility = View.INVISIBLE
            }
            field = value
        }

    private val playingEventListener = EventListener<PlayingEvent> {
        if (!isFirstPlaying) {
            isFirstPlaying = true
        }
    }

    init {
        val flutterPlayerConfig = creationParams?.get("playerConfig") as? Map<*, *>
        val license = flutterPlayerConfig?.get("license") as? String
        val licenseUrl = flutterPlayerConfig?.get("licenseUrl") as? String
        useHybridComposition =
            (flutterPlayerConfig?.get("androidConfig") as? Map<*, *>)?.get("viewComposition") as? String == "HYBRID_COMPOSITION"

        val playerConfigBuilder = THEOplayerConfig.Builder()
        license?.let { playerConfigBuilder.license(it) }
        licenseUrl?.let { playerConfigBuilder.licenseUrl(it) }
        playerConfigBuilder.pipConfiguration(PipConfiguration.Builder().build())

        theoplayerWrapper = LinearLayout(context)
        theoplayerWrapper.layoutParams = ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
        if (BuildConfig.DEBUG) {
            theoplayerWrapper.setBackgroundColor(android.graphics.Color.BLUE)
        } else {
            theoplayerWrapper.setBackgroundColor(android.graphics.Color.BLACK)
        }

        tpv = THEOplayerView(context, playerConfigBuilder.build())
        isFirstPlaying = false
        tpv.player.addEventListener(PlayerEventTypes.PLAYING, playingEventListener)
        theoplayerWrapper.addView(tpv)

        pigeonMessenger = PigeonBinaryMessengerWrapper(messenger, "id_$id")
        setUp(pigeonMessenger, this)

        flutterAPI = THEOplayerFlutterAPI(pigeonMessenger)
        playerEventForwarder = PlayerEventForwarder(tpv.player, flutterAPI)
        playerEventForwarder.attachListeners()

        textTrackBridge = TextTrackBridge(tpv.player, pigeonMessenger)
        textTrackBridge.attachListeners()

        audioTrackBridge = AudioTrackBridge(tpv.player, pigeonMessenger)
        audioTrackBridge.attachListeners()

        videoTrackBridge = VideoTrackBridge(tpv.player, pigeonMessenger)
        videoTrackBridge.attachListeners()
    }

    override fun getView(): View {
        return theoplayerWrapper
    }

    override fun dispose() {
        tpv.player.removeEventListener(PlayerEventTypes.PLAYING, playingEventListener)
        playerEventForwarder.removeListeners()
        textTrackBridge.removeListeners()
        audioTrackBridge.removeListeners()
        videoTrackBridge.removeListeners()
        tpv.onDestroy()
        destroyListener?.onDestroyed();
    }

    // activity lifecycle events
    override fun onLifecycleResume() {
        tpv.onResume()
    }

    override fun onLifecyclePause() {
        tpv.onPause()
    }

    override fun configureSurface(surfaceId: Long, width: Long, height: Long) {

        if (surface == null) {

            surface = when(surfaceEntry) {
                is SurfaceTextureEntry -> Surface((surfaceEntry as SurfaceTextureEntry).surfaceTexture())
                is SurfaceProducer -> (surfaceEntry as SurfaceProducer).surface
                else -> {
                    throw Exception("Unsupported surface: $surfaceEntry");
                }
            }
        }
        Log.d("[THEOplayerViewNative]", "setCustomSurface: " + surface + ", valid: " + surface!!.isValid + ", w: " + width + ", h: " + height );
        tpv.player.setCustomSurface(surface, width.toInt(), height.toInt());
    }

    override fun setSource(source: FlutterSourceDescription?) {
        isFirstPlaying = false
        tpv.player.source = SourceTransformer.toSourceDescription(source)

    }

    override fun getSource(): FlutterSourceDescription? {
        return SourceTransformer.toFlutterSourceDescription(tpv.player.source)
    }

    override fun setAutoplay(autoplay: Boolean) {
        tpv.player.isAutoplay = true
    }

    override fun isAutoplay(): Boolean {
        return tpv.player.isAutoplay
    }

    override fun play() {
        tpv.player.play()
    }

    override fun pause() {
        tpv.player.pause()
    }

    override fun isPaused(): Boolean {
        return tpv.player.isPaused
    }

    override fun setCurrentTime(currentTime: Double) {
        tpv.player.currentTime = currentTime
    }

    override fun getCurrentTime(): Double {
        return tpv.player.currentTime
    }

    override fun setCurrentProgramDateTime(currentProgramDateTime: Long) {
        tpv.player.currentProgramDateTime = Date(currentProgramDateTime)
    }

    override fun getCurrentProgramDateTime(): Long? {
        return tpv.player.currentProgramDateTime?.time
    }

    override fun getDuration(): Double {
        return tpv.player.duration
    }

    override fun setPlaybackRate(playbackRate: Double) {
        tpv.player.playbackRate = playbackRate
    }

    override fun getPlaybackRate(): Double {
        return tpv.player.playbackRate
    }

    override fun setVolume(volume: Double) {
        tpv.player.volume = volume
    }

    override fun getVolume(): Double {
        return tpv.player.volume
    }

    override fun setMuted(muted: Boolean) {
        tpv.player.isMuted = muted
    }

    override fun isMuted(): Boolean {
        return tpv.player.isMuted
    }

    override fun setPreload(preload: FlutterPreloadType) {
        tpv.player.preload = PlayerEnumTransformer.toPreloadType(preload)
    }

    override fun getPreload(): FlutterPreloadType {
        return PlayerEnumTransformer.toFlutterPreloadType(tpv.player.preload)
    }

    override fun setAllowBackgroundPlayback(allowBackgroundPlayback: Boolean) {
        tpv.settings.setAllowBackgroundPlayback(allowBackgroundPlayback)
    }

    override fun allowBackgroundPlayback(): Boolean {
        return tpv.settings.allowBackgroundPlayback()
    }

    override fun getReadyState(): FlutterReadyState {
        return PlayerEnumTransformer.toFlutterReadyState(tpv.player.readyState)
    }

    override fun isSeeking(): Boolean {
        return tpv.player.isSeeking
    }

    override fun isEnded(): Boolean {
        return tpv.player.isEnded
    }

    override fun getVideoWidth(): Long {
        return tpv.player.videoWidth.toLong()
    }

    override fun getVideoHeight(): Long {
        return tpv.player.videoHeight.toLong()
    }

    override fun getBuffered(): List<FlutterTimeRange> {
        return TimeRangeTransformer.toFlutterTimeRanges(tpv.player.buffered)
    }

    override fun getSeekable(): List<FlutterTimeRange> {
        return TimeRangeTransformer.toFlutterTimeRanges(tpv.player.seekable)
    }

    override fun getPlayed(): List<FlutterTimeRange> {
        return TimeRangeTransformer.toFlutterTimeRanges(tpv.player.played)
    }

    override fun getError(): String? {
        return tpv.player.error
    }

    override fun stop() {
        isFirstPlaying = false
        tpv.player.stop()
    }

    fun interface DestroyListener {
        fun onDestroyed()
    }
}