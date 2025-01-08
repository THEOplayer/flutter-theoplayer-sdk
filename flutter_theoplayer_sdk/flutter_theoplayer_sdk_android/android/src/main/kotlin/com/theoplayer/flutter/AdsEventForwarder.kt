package com.theoplayer.flutter

import com.theoplayer.android.api.ads.Ads
import com.theoplayer.android.api.event.EventListener
import com.theoplayer.android.api.event.ads.AdBeginEvent
import com.theoplayer.android.api.event.ads.AdBreakBeginEvent
import com.theoplayer.android.api.event.ads.AdBreakChangeEvent
import com.theoplayer.android.api.event.ads.AdBreakEndEvent
import com.theoplayer.android.api.event.ads.AdClickedEvent
import com.theoplayer.android.api.event.ads.AdEndEvent
import com.theoplayer.android.api.event.ads.AdErrorEvent
import com.theoplayer.android.api.event.ads.AdFirstQuartileEvent
import com.theoplayer.android.api.event.ads.AdImpressionEvent
import com.theoplayer.android.api.event.ads.AdLoadedEvent
import com.theoplayer.android.api.event.ads.AdMidpointEvent
import com.theoplayer.android.api.event.ads.AdSkipEvent
import com.theoplayer.android.api.event.ads.AdTappedEvent
import com.theoplayer.android.api.event.ads.AdThirdQuartileEvent
import com.theoplayer.android.api.event.ads.AddAdBreakEvent
import com.theoplayer.android.api.event.ads.AddAdEvent
import com.theoplayer.android.api.event.ads.AdsEventTypes
import com.theoplayer.android.api.event.ads.RemoveAdBreakEvent
import com.theoplayer.flutter.pigeon.THEOplayerFlutterAdsAPI
import com.theoplayer.flutter.transformers.AdsTransformer


class AdsEventForwarder(
    private val ads: Ads,
    private val flutterAPI: THEOplayerFlutterAdsAPI
) {
    private val emptyCallback: (Result<Unit>) -> Unit = {}

    private val adBeginEvent = EventListener<AdBeginEvent> {
        flutterAPI.onAdBegin(
            adArg = AdsTransformer.toFlutterAd(it.ad),
            currentAdsArg = ads.currentAds.map { AdsTransformer.toFlutterAd(it)!! }, // if the param is not null, the return is never null
            currentAdBreakArg = ads.currentAdBreak?.let { AdsTransformer.toFlutterAdBreak(it) },
            scheduledAdsArg = ads.scheduledAds.map { AdsTransformer.toFlutterAd(it)!! }, // if the param is not null, the return is never null
            callback = emptyCallback,
        )
    }

    private val adEndEvent = EventListener<AdEndEvent> {
        flutterAPI.onAdEnd(
            adArg = AdsTransformer.toFlutterAd(it.ad),
            currentAdsArg = ads.currentAds.map { AdsTransformer.toFlutterAd(it)!! },
            currentAdBreakArg = ads.currentAdBreak?.let { AdsTransformer.toFlutterAdBreak(it) },
            scheduledAdsArg = ads.scheduledAds.map { AdsTransformer.toFlutterAd(it)!! },
            callback = emptyCallback,
        )
    }


    private val adErrorEvent = EventListener<AdErrorEvent> {
        flutterAPI.onAdError(
            adArg = AdsTransformer.toFlutterAd(it.ad),
            currentAdsArg = ads.currentAds.map { AdsTransformer.toFlutterAd(it)!! },
            currentAdBreakArg = ads.currentAdBreak?.let { AdsTransformer.toFlutterAdBreak(it) },
            scheduledAdsArg = ads.scheduledAds.map { AdsTransformer.toFlutterAd(it)!! },
            callback = emptyCallback,
        )
    }

    private val adMidpointEvent = EventListener<AdMidpointEvent> {
        flutterAPI.onAdMidpoint(
            adArg = AdsTransformer.toFlutterAd(it.ad),
            currentAdsArg = ads.currentAds.map { AdsTransformer.toFlutterAd(it)!! },
            currentAdBreakArg = ads.currentAdBreak?.let { AdsTransformer.toFlutterAdBreak(it) },
            scheduledAdsArg = ads.scheduledAds.map { AdsTransformer.toFlutterAd(it)!! },
            callback = emptyCallback,
        )
    }

    private val adAddedEvent = EventListener<AddAdEvent> {
        flutterAPI.onAddAd(
            adArg = AdsTransformer.toFlutterAd(it.ad),
            currentAdsArg = ads.currentAds.map { AdsTransformer.toFlutterAd(it)!! },
            currentAdBreakArg = ads.currentAdBreak?.let { AdsTransformer.toFlutterAdBreak(it) },
            scheduledAdsArg = ads.scheduledAds.map { AdsTransformer.toFlutterAd(it)!! },
            callback = emptyCallback,
        )
    }


    private val adSkipEvent = EventListener<AdSkipEvent> {
        flutterAPI.onAdSkip(
            adArg = AdsTransformer.toFlutterAd(it.ad),
            currentAdsArg = ads.currentAds.map { AdsTransformer.toFlutterAd(it)!! },
            currentAdBreakArg = ads.currentAdBreak?.let { AdsTransformer.toFlutterAdBreak(it) },
            scheduledAdsArg = ads.scheduledAds.map { AdsTransformer.toFlutterAd(it)!! },
            callback = emptyCallback,
        )
    }

    private val adLoadedEvent = EventListener<AdLoadedEvent> {
        flutterAPI.onAdLoaded(
            adArg = AdsTransformer.toFlutterAd(it.ad),
            currentAdsArg = ads.currentAds.map { AdsTransformer.toFlutterAd(it)!! },
            currentAdBreakArg = ads.currentAdBreak?.let { AdsTransformer.toFlutterAdBreak(it) },
            scheduledAdsArg = ads.scheduledAds.map { AdsTransformer.toFlutterAd(it)!! },
            callback = emptyCallback,
        )
    }

    private val adTappedEvent = EventListener<AdTappedEvent> {
        flutterAPI.onAdTapped(
            adArg = AdsTransformer.toFlutterAd(it.ad),
            currentAdsArg = ads.currentAds.map { AdsTransformer.toFlutterAd(it)!! },
            currentAdBreakArg = ads.currentAdBreak?.let { AdsTransformer.toFlutterAdBreak(it) },
            scheduledAdsArg = ads.scheduledAds.map { AdsTransformer.toFlutterAd(it)!! },
            callback = emptyCallback,
        )
    }

    private val adClickedEvent = EventListener<AdClickedEvent> {
        flutterAPI.onAdClicked(
            adArg = AdsTransformer.toFlutterAd(it.ad),
            currentAdsArg = ads.currentAds.map { AdsTransformer.toFlutterAd(it)!! },
            currentAdBreakArg = ads.currentAdBreak?.let { AdsTransformer.toFlutterAdBreak(it) },
            scheduledAdsArg = ads.scheduledAds.map { AdsTransformer.toFlutterAd(it)!! },
            callback = emptyCallback,
        )
    }

    private val adFirstQuartileEvent = EventListener<AdFirstQuartileEvent> {
        flutterAPI.onAdFirstQuartile(
            adArg = AdsTransformer.toFlutterAd(it.ad),
            currentAdsArg = ads.currentAds.map { AdsTransformer.toFlutterAd(it)!! },
            currentAdBreakArg = ads.currentAdBreak?.let { AdsTransformer.toFlutterAdBreak(it) },
            scheduledAdsArg = ads.scheduledAds.map { AdsTransformer.toFlutterAd(it)!! },
            callback = emptyCallback,
        )
    }

    private val adThirdQuartileEvent = EventListener<AdThirdQuartileEvent> {
        flutterAPI.onAdThirdQuartile(
            adArg = AdsTransformer.toFlutterAd(it.ad),
            currentAdsArg = ads.currentAds.map { AdsTransformer.toFlutterAd(it)!! },
            currentAdBreakArg = ads.currentAdBreak?.let { AdsTransformer.toFlutterAdBreak(it) },
            scheduledAdsArg = ads.scheduledAds.map { AdsTransformer.toFlutterAd(it)!! },
            callback = emptyCallback,
        )
    }

    private val adImpressionEvent = EventListener<AdImpressionEvent> {
        flutterAPI.onAdImpression(
            adArg = AdsTransformer.toFlutterAd(it.ad),
            currentAdsArg = ads.currentAds.map { AdsTransformer.toFlutterAd(it)!! },
            currentAdBreakArg = ads.currentAdBreak?.let { AdsTransformer.toFlutterAdBreak(it) },
            scheduledAdsArg = ads.scheduledAds.map { AdsTransformer.toFlutterAd(it)!! },
            callback = emptyCallback,
        )
    }


    private val adBreakEndEvent = EventListener<AdBreakEndEvent> {
        flutterAPI.onAdBreakEnd(
            AdsTransformer.toFlutterAdBreak(it.adBreak),
            currentAdsArg = ads.currentAds.map { AdsTransformer.toFlutterAd(it)!! },
            currentAdBreakArg = ads.currentAdBreak?.let { AdsTransformer.toFlutterAdBreak(it) },
            scheduledAdsArg = ads.scheduledAds.map { AdsTransformer.toFlutterAd(it)!! },
            callback = emptyCallback,
        )
    }

    private val adBreakBeginEvent = EventListener<AdBreakBeginEvent> {
        flutterAPI.onAdBreakBegin(
            AdsTransformer.toFlutterAdBreak(it.adBreak),
            currentAdsArg = ads.currentAds.map { AdsTransformer.toFlutterAd(it)!! }, // if the param is not null, the return is never null
            currentAdBreakArg = ads.currentAdBreak?.let { AdsTransformer.toFlutterAdBreak(it) },
            scheduledAdsArg = ads.scheduledAds.map { AdsTransformer.toFlutterAd(it)!! }, // if the param is not null, the return is never null
            callback = emptyCallback,
        )
    }

    private val addAdBreakEvent = EventListener<AddAdBreakEvent> {
        flutterAPI.onAddAdBreak(
            AdsTransformer.toFlutterAdBreak(it.adBreak),
            currentAdsArg = ads.currentAds.map { AdsTransformer.toFlutterAd(it)!! }, // if the param is not null, the return is never null
            currentAdBreakArg = ads.currentAdBreak?.let { AdsTransformer.toFlutterAdBreak(it) },
            scheduledAdsArg = ads.scheduledAds.map { AdsTransformer.toFlutterAd(it)!! }, // if the param is not null, the return is never null
            callback = emptyCallback,
        )
    }

    private val adBreakChangeEvent = EventListener<AdBreakChangeEvent> {
        flutterAPI.onAdBreakChange(
            AdsTransformer.toFlutterAdBreak(it.adBreak),
            currentAdsArg = ads.currentAds.map { AdsTransformer.toFlutterAd(it)!! },
            currentAdBreakArg = ads.currentAdBreak?.let { AdsTransformer.toFlutterAdBreak(it) },
            scheduledAdsArg = ads.scheduledAds.map { AdsTransformer.toFlutterAd(it)!! },
            callback = emptyCallback,
        )
    }

    private val adBreakRemoveEvent = EventListener<RemoveAdBreakEvent> {
        flutterAPI.onRemoveAdBreak(
            AdsTransformer.toFlutterAdBreak(it.adBreak),
            currentAdsArg = ads.currentAds.map { AdsTransformer.toFlutterAd(it)!! },
            currentAdBreakArg = ads.currentAdBreak?.let { AdsTransformer.toFlutterAdBreak(it) },
            scheduledAdsArg = ads.scheduledAds.map { AdsTransformer.toFlutterAd(it)!! },
            callback = emptyCallback,
        )
    }


    fun attachListeners() {
        ads.addEventListener(AdsEventTypes.ADD_AD, adAddedEvent)
        ads.addEventListener(AdsEventTypes.AD_BEGIN, adBeginEvent)
        ads.addEventListener(AdsEventTypes.AD_END, adEndEvent)
        ads.addEventListener(AdsEventTypes.AD_ERROR, adErrorEvent)
        ads.addEventListener(AdsEventTypes.AD_MIDPOINT, adMidpointEvent)
        ads.addEventListener(AdsEventTypes.AD_SKIP, adSkipEvent)
        ads.addEventListener(AdsEventTypes.AD_LOADED, adLoadedEvent)
        ads.addEventListener(AdsEventTypes.AD_TAPPED, adTappedEvent)
        ads.addEventListener(AdsEventTypes.AD_CLICKED, adClickedEvent)
        ads.addEventListener(AdsEventTypes.AD_FIRST_QUARTILE, adFirstQuartileEvent)
        ads.addEventListener(AdsEventTypes.AD_THIRD_QUARTILE, adThirdQuartileEvent)
        ads.addEventListener(AdsEventTypes.AD_IMPRESSION, adImpressionEvent)

        ads.addEventListener(AdsEventTypes.AD_BREAK_END, adBreakEndEvent)
        ads.addEventListener(AdsEventTypes.AD_BREAK_BEGIN, adBreakBeginEvent)
        ads.addEventListener(AdsEventTypes.ADD_AD_BREAK, addAdBreakEvent)
        ads.addEventListener(AdsEventTypes.AD_BREAK_CHANGE, adBreakChangeEvent)
        ads.addEventListener(AdsEventTypes.REMOVE_AD_BREAK, adBreakRemoveEvent)


    }

    fun removeListeners() {
        ads.removeEventListener(AdsEventTypes.ADD_AD, adAddedEvent)
        ads.removeEventListener(AdsEventTypes.AD_BEGIN, adBeginEvent)
        ads.removeEventListener(AdsEventTypes.AD_END, adEndEvent)
        ads.removeEventListener(AdsEventTypes.AD_ERROR, adErrorEvent)
        ads.removeEventListener(AdsEventTypes.AD_MIDPOINT, adMidpointEvent)
        ads.removeEventListener(AdsEventTypes.AD_SKIP, adSkipEvent)
        ads.removeEventListener(AdsEventTypes.AD_LOADED, adLoadedEvent)
        ads.removeEventListener(AdsEventTypes.AD_TAPPED, adTappedEvent)
        ads.removeEventListener(AdsEventTypes.AD_CLICKED, adClickedEvent)
        ads.removeEventListener(AdsEventTypes.AD_FIRST_QUARTILE, adFirstQuartileEvent)
        ads.removeEventListener(AdsEventTypes.AD_THIRD_QUARTILE, adThirdQuartileEvent)
        ads.removeEventListener(AdsEventTypes.AD_IMPRESSION, adImpressionEvent)

        ads.removeEventListener(AdsEventTypes.AD_BREAK_END, adBreakEndEvent)
        ads.removeEventListener(AdsEventTypes.AD_BREAK_BEGIN, adBreakBeginEvent)
        ads.removeEventListener(AdsEventTypes.ADD_AD_BREAK, addAdBreakEvent)
        ads.removeEventListener(AdsEventTypes.AD_BREAK_CHANGE, adBreakChangeEvent)
        ads.removeEventListener(AdsEventTypes.REMOVE_AD_BREAK, adBreakRemoveEvent)

    }


}