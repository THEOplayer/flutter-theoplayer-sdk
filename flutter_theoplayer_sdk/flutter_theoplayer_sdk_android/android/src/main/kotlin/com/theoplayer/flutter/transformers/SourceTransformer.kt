package com.theoplayer.flutter.transformers

import com.theoplayer.android.api.source.SourceDescription
import com.theoplayer.android.api.source.TypedSource
import com.theoplayer.android.api.source.drm.DRMConfiguration
import com.theoplayer.android.api.source.drm.FairPlayKeySystemConfiguration
import com.theoplayer.android.api.source.drm.KeySystemConfiguration
import com.theoplayer.android.api.theolive.TheoLiveSource
import com.theoplayer.flutter.pigeon.SourceIntegrationId

typealias FlutterSourceDescription = com.theoplayer.flutter.pigeon.SourceDescription
typealias FlutterTypedSource = com.theoplayer.flutter.pigeon.TypedSource
typealias FlutterDRMConfiguration = com.theoplayer.flutter.pigeon.DRMConfiguration
typealias FlutterWidevineDRMConfiguration = com.theoplayer.flutter.pigeon.WidevineDRMConfiguration
typealias FlutterFairPlayDRMConfiguration = com.theoplayer.flutter.pigeon.FairPlayDRMConfiguration

object SourceTransformer {

    fun toFlutterSourceDescription(sourceDescription: SourceDescription?): FlutterSourceDescription? {
        if (sourceDescription == null) {
            return null
        }

        return FlutterSourceDescription(sourceDescription.sources
            .map { toFlutterTypedSource(it) }
        )
    }

    fun toFlutterTypedSource(typedSource: TypedSource?): FlutterTypedSource? {
        if (typedSource == null) {
            return null
        }

        val drm = typedSource.drm?.let {
            toFlutterDRMConfiguration(it)
        }

        val integrationID = if (typedSource is TheoLiveSource) SourceIntegrationId.THEOLIVE else null
        return FlutterTypedSource(typedSource.src, drm, integration = integrationID)
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
            .build()
    }

    fun toTypedSource(flutterTypedSource: FlutterTypedSource?): TypedSource? {
        if (flutterTypedSource == null) {
            return null
        }

        when(flutterTypedSource.integration) {
            SourceIntegrationId.THEOLIVE -> {
                return TheoLiveSource(flutterTypedSource.src)
            }
            else -> {
                val typedSourceBuilder = TypedSource.Builder(flutterTypedSource.src)

                flutterTypedSource.drm?.let {
                    typedSourceBuilder.drm(toDRMConfiguration(it))
                }

                return typedSourceBuilder.build()
            }
        }
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