package com.theoplayer.flutter.transformers

import com.theoplayer.android.api.source.SourceDescription
import com.theoplayer.android.api.source.TypedSource
import com.theoplayer.android.api.source.addescription.AdDescription
import com.theoplayer.android.api.source.addescription.GoogleImaAdDescription
import com.theoplayer.android.api.source.drm.DRMConfiguration
import com.theoplayer.android.api.source.drm.FairPlayKeySystemConfiguration
import com.theoplayer.android.api.source.drm.KeySystemConfiguration

typealias FlutterSourceDescription = com.theoplayer.flutter.pigeon.SourceDescription
typealias FlutterTypedSource = com.theoplayer.flutter.pigeon.TypedSource
typealias FlutterAdDescription = com.theoplayer.flutter.pigeon.AdDescription
typealias FlutterDRMConfiguration = com.theoplayer.flutter.pigeon.DRMConfiguration
typealias FlutterWidevineDRMConfiguration = com.theoplayer.flutter.pigeon.WidevineDRMConfiguration
typealias FlutterFairPlayDRMConfiguration = com.theoplayer.flutter.pigeon.FairPlayDRMConfiguration

object SourceTransformer {

    fun toFlutterSourceDescription(sourceDescription: SourceDescription?): FlutterSourceDescription? {
        if (sourceDescription == null) {
            return null
        }

        return FlutterSourceDescription(
            sources = sourceDescription.sources.map { toFlutterTypedSource(it) },
            ads = sourceDescription.ads.map { toFlutterGoogleImaAdDescription(it) }
        )
    }

    fun toFlutterTypedSource(typedSource: TypedSource?): FlutterTypedSource? {
        if (typedSource == null) {
            return null
        }

        val drm = typedSource.drm?.let {
            toFlutterDRMConfiguration(it)
        }

        return FlutterTypedSource(typedSource.src, drm)
    }

    fun toFlutterGoogleImaAdDescription(adDescription: AdDescription?): FlutterAdDescription? {
        if (adDescription == null) {
            return null
        }

        if (adDescription !is GoogleImaAdDescription) {
            return null
        }

        return FlutterAdDescription(adDescription.integration?.name ?: "", adDescription.sources, adDescription.timeOffset ?: "")
    }

    fun toFlutterDRMConfiguration(drmConfiguration: DRMConfiguration): FlutterDRMConfiguration {
        var flutterWidevineConfig: FlutterWidevineDRMConfiguration? = null
        drmConfiguration.widevine?.let {
            flutterWidevineConfig = FlutterWidevineDRMConfiguration(it.licenseAcquisitionURL, it.headers)
        }

        var flutterFairplayConfig: FlutterFairPlayDRMConfiguration? = null
        drmConfiguration.fairplay?.let {
            flutterFairplayConfig = FlutterFairPlayDRMConfiguration(it.licenseAcquisitionURL, it.certificateURL, it.headers)
        }

        var integrationParamaters : MutableMap<String, String>? = null
        drmConfiguration.integrationParameters?.let {
            integrationParamaters = mutableMapOf()
            it.forEach { entry ->
                val value = entry.value
                if (value is String) {
                    integrationParamaters!![entry.key] = value
                }
            }
        }

        return FlutterDRMConfiguration(
            widevine = flutterWidevineConfig,
            fairplay = flutterFairplayConfig,
            customIntegrationId = drmConfiguration.customIntegrationId,
            integrationParameters = integrationParamaters?.toMap()
        )
    }

    fun toSourceDescription(flutterSourceDescription: FlutterSourceDescription?): SourceDescription? {
        if (flutterSourceDescription == null) {
            return null
        }

        return SourceDescription.Builder(
            *flutterSourceDescription.sources
                .map { toTypedSource(it) }
                .toTypedArray())
            .ads(
                *flutterSourceDescription.ads?.map { toGoogleImaAdDescription(it) }?.toTypedArray()
                    ?: emptyArray()
            )
            .build()
    }

    fun toTypedSource(flutterTypedSource: FlutterTypedSource?): TypedSource? {
        if (flutterTypedSource == null) {
            return null
        }

        val typedSourceBuilder = TypedSource.Builder(flutterTypedSource.src)

        flutterTypedSource.drm?.let {
            typedSourceBuilder.drm(toDRMConfiguration(it))
        }

        return typedSourceBuilder.build()
    }

    fun toGoogleImaAdDescription(flutterTypedSource: FlutterAdDescription?): GoogleImaAdDescription? {
        if (flutterTypedSource == null) {
            return null
        }

        val imaBuilder = GoogleImaAdDescription.Builder(flutterTypedSource.source)

        flutterTypedSource.timeOffset?.let {
            imaBuilder.timeOffset(it);
        }

        return imaBuilder.build()
    }

    fun toDRMConfiguration(flutterDRMConfiguration: FlutterDRMConfiguration): DRMConfiguration {
        val drm = DRMConfiguration.Builder()

        flutterDRMConfiguration.widevine?.let { flutterWidevineConfig ->
            val widevineDRMConfiguration = KeySystemConfiguration.Builder(flutterWidevineConfig.licenseAcquisitionURL)
            flutterWidevineConfig.headers?.let {
                widevineDRMConfiguration.headers(it)
            }
            drm.widevine(widevineDRMConfiguration.build())
        }

        flutterDRMConfiguration.fairplay?.let { flutterFairplayConfig ->
            val fairplayDRMConfiguration = FairPlayKeySystemConfiguration.Builder(flutterFairplayConfig.licenseAcquisitionURL, flutterFairplayConfig.certificateURL)
            flutterFairplayConfig.headers?.let {
                fairplayDRMConfiguration.headers(it)
            }
            drm.fairplay(fairplayDRMConfiguration.build())
        }

        flutterDRMConfiguration.customIntegrationId?.let {
            drm.customIntegrationId(it);
        }

        flutterDRMConfiguration.integrationParameters?.let {
            drm.integrationParameters(it)
        }

        return drm.build()
    }

}