package com.theoplayer.flutter.transformers

import com.theoplayer.android.api.ads.CompanionAd
import com.theoplayer.android.api.event.ads.AdIntegrationKind
import com.theoplayer.flutter.pigeon.Ad
import com.theoplayer.flutter.pigeon.AdBreak
import com.theoplayer.flutter.pigeon.IntegrationKind

typealias FlutterAd = Ad
typealias FlutterAdBreak = AdBreak
typealias FlutterCompanionAd = com.theoplayer.flutter.pigeon.CompanionAd

object AdsTransformer {

    fun toFlutterAd(ad: com.theoplayer.android.api.ads.Ad?): FlutterAd? {
        if (ad == null) {
            return null
        }

        return FlutterAd(
            id = ad.id,
            companions = ad.companions.map { toFlutterCompaionAd(it) },
            adBreak = ad.adBreak?.let { toFlutterAdBreak(it) },
            skipOffset = ad.skipOffset.toLong(),
            integration = toFlutterIntegrationKind(ad.integration),
            customIntegration = ad.customIntegration,
            customData = ad.customData,
        )
    }

    fun toFlutterAdBreak(adBreak: com.theoplayer.android.api.ads.AdBreak): FlutterAdBreak {
       return FlutterAdBreak(
           ads = adBreak.ads.map { toFlutterAd(it) },
           maxDuration = adBreak.maxDuration.toLong(),
           maxRemainingDuration = adBreak.maxRemainingDuration.toLong(),
           integration = toFlutterIntegrationKind(adBreak.integration),
           timeOffset = adBreak.timeOffset.toLong(),
           customIntegration = adBreak.customIntegration,
           customData = adBreak.customData
       )
    }

    fun toFlutterIntegrationKind(integration: AdIntegrationKind): IntegrationKind {
        return when (integration) {
            AdIntegrationKind.THEO_ADS -> IntegrationKind.THEOADS
            AdIntegrationKind.GOOGLE_IMA -> IntegrationKind.GOOGLE_IMA
            AdIntegrationKind.GOOGLE_DAI -> IntegrationKind.GOOGLE_DAI
            AdIntegrationKind.MEDIATAILOR -> IntegrationKind.MEDIATAILOR
            AdIntegrationKind.CUSTOM -> IntegrationKind.CUSTOM
        }
    }
    
    fun toFlutterCompaionAd(companionAd: CompanionAd): FlutterCompanionAd {
        return FlutterCompanionAd(
            adSlotId = companionAd.adSlotId,
            altText = companionAd.altText,
            clickThrough = companionAd.clickThrough,
            height = companionAd.height.toLong(),
            width = companionAd.width.toLong(),
            resourceURI = companionAd.resourceURI,
            type = companionAd.type
        )
    }

}