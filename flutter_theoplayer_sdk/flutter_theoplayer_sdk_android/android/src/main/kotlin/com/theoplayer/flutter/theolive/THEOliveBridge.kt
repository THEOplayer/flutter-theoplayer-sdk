package com.theoplayer.flutter.theolive

import com.theoplayer.android.api.event.EventListener
import com.theoplayer.android.api.event.player.theolive.IntentToFallbackEvent
import com.theoplayer.android.api.event.player.theolive.PublicationLoadStartEvent
import com.theoplayer.android.api.event.player.theolive.PublicationLoadedEvent
import com.theoplayer.android.api.event.player.theolive.PublicationOfflineEvent
import com.theoplayer.android.api.event.player.theolive.TheoLiveEventTypes
import com.theoplayer.android.api.player.theolive.TheoLive
import com.theoplayer.flutter.PigeonBinaryMessengerWrapper
import com.theoplayer.flutter.pigeon.THEOplayerFlutterTHEOliveAPI
import com.theoplayer.flutter.pigeon.THEOplayerNativeTHEOliveAPI
import com.theoplayer.flutter.pigeon.THEOplayerNativeTHEOliveAPI.Companion.setUp

class THEOliveBridge(private val theoLive: TheoLive, pigeonMessenger: PigeonBinaryMessengerWrapper) : THEOplayerNativeTHEOliveAPI {

    private val flutterTHEOliveAPI = THEOplayerFlutterTHEOliveAPI(pigeonMessenger)
    private val emptyCallback: (Result<Unit>) -> Unit = {}

    init {
        setUp(pigeonMessenger, this)
    }

    private val publicationLoadStartListener = EventListener<PublicationLoadStartEvent> {
        flutterTHEOliveAPI.onPublicationLoadStartEvent(it.getChannelId(), emptyCallback)
    }

    private val publicationLoadedListener = EventListener<PublicationLoadedEvent> {
        flutterTHEOliveAPI.onPublicationLoadedEvent(it.getChannelId(), emptyCallback)
    }

    private val publicationOfflineListener = EventListener<PublicationOfflineEvent> {
        flutterTHEOliveAPI.onPublicationOfflineEvent(it.getChannelId(), emptyCallback)
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
        this.theoLive.addEventListener(TheoLiveEventTypes.PUBLICATIONLOADSTART, publicationLoadStartListener)
        this.theoLive.addEventListener(TheoLiveEventTypes.PUBLICATIONLOADED, publicationLoadedListener)
        this.theoLive.addEventListener(TheoLiveEventTypes.PUBLICATIONOFFLINE, publicationOfflineListener)
        this.theoLive.addEventListener(TheoLiveEventTypes.INTENTTOFALLBACK, intentToFallbackListener)
    }

    fun removeListeners() {
        this.theoLive.removeEventListener(TheoLiveEventTypes.PUBLICATIONLOADSTART, publicationLoadStartListener)
        this.theoLive.removeEventListener(TheoLiveEventTypes.PUBLICATIONLOADED, publicationLoadedListener)
        this.theoLive.removeEventListener(TheoLiveEventTypes.PUBLICATIONOFFLINE, publicationOfflineListener)
        this.theoLive.removeEventListener(TheoLiveEventTypes.INTENTTOFALLBACK, intentToFallbackListener)
    }

}