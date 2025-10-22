package com.theoplayer.flutter.theolive

import com.theoplayer.android.api.event.EventListener
import com.theoplayer.android.api.event.player.theolive.DistributionLoadStartEvent
import com.theoplayer.android.api.event.player.theolive.DistributionOfflineEvent
import com.theoplayer.android.api.event.player.theolive.EndpointLoadedEvent
import com.theoplayer.android.api.event.player.theolive.IntentToFallbackEvent
import com.theoplayer.android.api.event.player.theolive.TheoLiveEventTypes
import com.theoplayer.android.api.player.theolive.TheoLive
import com.theoplayer.flutter.PigeonBinaryMessengerWrapper
import com.theoplayer.flutter.pigeon.Endpoint
import com.theoplayer.flutter.pigeon.THEOplayerFlutterTHEOliveAPI
import com.theoplayer.flutter.pigeon.THEOplayerNativeTHEOliveAPI
import com.theoplayer.flutter.pigeon.THEOplayerNativeTHEOliveAPI.Companion.setUp

class THEOliveBridge(private val theoLive: TheoLive, pigeonMessenger: PigeonBinaryMessengerWrapper) : THEOplayerNativeTHEOliveAPI {

    private val flutterTHEOliveAPI = THEOplayerFlutterTHEOliveAPI(pigeonMessenger)
    private val emptyCallback: (Result<Unit>) -> Unit = {}

    init {
        setUp(pigeonMessenger, this)
    }

    private val distributionLoadStartListener = EventListener<DistributionLoadStartEvent> {
        flutterTHEOliveAPI.onDistributionLoadStartEvent(it.getDistributionId(), emptyCallback)
    }

    private val endpointLoadedListener = EventListener<EndpointLoadedEvent> {
        val eventEndpoint = it.getEndpoint()
        val endpoint = Endpoint(
            eventEndpoint.hespSrc,
            eventEndpoint.hlsSrc,
            null,
            eventEndpoint.adSrc,
            eventEndpoint.weight.toDouble(),
            eventEndpoint.priority.toLong()
        )
        flutterTHEOliveAPI.onEndpointLoadedEvent(endpoint, emptyCallback)
    }

    private val distributionOfflineListener = EventListener<DistributionOfflineEvent> {
        flutterTHEOliveAPI.onDistributionOfflineEvent(it.getDistributionId(), emptyCallback)
    }

    private val intentToFallbackListener = EventListener<IntentToFallbackEvent> {
        flutterTHEOliveAPI.onIntentToFallbackEvent(emptyCallback)
    }

    override fun goLive() {
        this.theoLive.goLive()
    }

    override fun preloadChannels(channelIds: List<String>?) {
        if (channelIds != null) {
            this.theoLive.preloadChannels(channelIds)
        }
    }

    fun attachListeners() {
        this.theoLive.addEventListener(TheoLiveEventTypes.DISTRIBUTIONLOADSTART, distributionLoadStartListener)
        this.theoLive.addEventListener(TheoLiveEventTypes.ENDPOINTLOADED, endpointLoadedListener)
        this.theoLive.addEventListener(TheoLiveEventTypes.DISTRIBUTIONOFFLINE, distributionOfflineListener)
        this.theoLive.addEventListener(TheoLiveEventTypes.INTENTTOFALLBACK, intentToFallbackListener)
    }

    fun removeListeners() {
        this.theoLive.removeEventListener(TheoLiveEventTypes.DISTRIBUTIONLOADSTART, distributionLoadStartListener)
        this.theoLive.removeEventListener(TheoLiveEventTypes.ENDPOINTLOADED, endpointLoadedListener)
        this.theoLive.removeEventListener(TheoLiveEventTypes.DISTRIBUTIONOFFLINE, distributionOfflineListener)
        this.theoLive.removeEventListener(TheoLiveEventTypes.INTENTTOFALLBACK, intentToFallbackListener)
    }

}