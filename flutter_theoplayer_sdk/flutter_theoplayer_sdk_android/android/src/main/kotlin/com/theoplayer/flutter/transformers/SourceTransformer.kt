package com.theoplayer.flutter.transformers

import com.theoplayer.android.api.source.PlaybackPipeline
import com.theoplayer.android.api.source.SourceDescription
import com.theoplayer.android.api.source.TypedSource
import com.theoplayer.android.api.source.drm.DRMConfiguration
import com.theoplayer.android.api.source.drm.FairPlayKeySystemConfiguration
import com.theoplayer.android.api.source.drm.KeySystemConfiguration
import com.theoplayer.android.api.theolive.TheoLiveSource
import com.theoplayer.flutter.pigeon.FairPlayDRMConfiguration
import com.theoplayer.flutter.pigeon.SourceIntegrationId
import com.theoplayer.flutter.pigeon.WidevineDRMConfiguration

typealias FlutterSourceDescription = com.theoplayer.flutter.pigeon.SourceDescription
typealias FlutterTypedSource = com.theoplayer.flutter.pigeon.PigeonTypedSource
typealias FlutterDRMConfiguration = com.theoplayer.flutter.pigeon.DRMConfiguration
typealias FlutterWidevineDRMConfiguration = WidevineDRMConfiguration
typealias FlutterFairPlayDRMConfiguration = FairPlayDRMConfiguration
typealias FlutterPlaybackPipeline = com.theoplayer.flutter.pigeon.PlaybackPipeline

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
        val playbackPipeline = if (typedSource.playbackPipeline == PlaybackPipeline.LEGACY) FlutterPlaybackPipeline.LEGACY else FlutterPlaybackPipeline.MEDIA3

        return FlutterTypedSource(
            src = typedSource.src,
            drm = drm,
            integration = integrationID,
            playbackPipeline = playbackPipeline,
            headers = typedSource.headers as Map<String?, String?>?
        )
    }

    fun toFlutterDRMConfiguration(drmConfiguration: DRMConfiguration): FlutterDRMConfiguration {
        var flutterWidevineConfig: FlutterWidevineDRMConfiguration? = null
        drmConfiguration.widevine?.let { widevine ->
            flutterWidevineConfig = FlutterWidevineDRMConfiguration(
                widevine.licenseAcquisitionURL,
                //TODO: clean-up these mappings
                widevine.headers.mapKeys { it.key as String? }.mapValues { it.value as String? }
            )
        }

        var flutterFairplayConfig: FlutterFairPlayDRMConfiguration? = null
        drmConfiguration.fairplay?.let { fairplay ->
            flutterFairplayConfig = FlutterFairPlayDRMConfiguration(
                fairplay.licenseAcquisitionURL,
                fairplay.certificateURL,
                fairplay.headers.mapKeys { it.key as String? }.mapValues { it.value as String? }
            )
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
                .filterNotNull()
                .map { toTypedSource(it) as TypedSource}
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
                typedSourceBuilder.playbackPipeline(toPlaybackPipeline(flutterTypedSource.playbackPipeline));
                flutterTypedSource.drm?.let {
                    typedSourceBuilder.drm(toDRMConfiguration(it))
                }

                //clean headers
                flutterTypedSource.headers
                    ?.filter { it.key != null && it.value != null }
                    ?.map { it.key!! to it.value!! }
                    ?.toMap()
                    ?.let {
                        typedSourceBuilder.headers(it)
                    }


                return typedSourceBuilder.build()
            }
        }
    }

    private fun toPlaybackPipeline(playbackPipeline: FlutterPlaybackPipeline): PlaybackPipeline {
        return when(playbackPipeline) {
            FlutterPlaybackPipeline.LEGACY -> PlaybackPipeline.LEGACY
            else -> PlaybackPipeline.MEDIA3
        }
    }

    fun toDRMConfiguration(flutterDRMConfiguration: FlutterDRMConfiguration): DRMConfiguration {
        val drm = DRMConfiguration.Builder()

        flutterDRMConfiguration.widevine?.let { flutterWidevineConfig ->
            val widevineDRMConfiguration = KeySystemConfiguration.Builder(flutterWidevineConfig.licenseAcquisitionURL)
            flutterWidevineConfig.headers?.let { widevine ->
                widevineDRMConfiguration.headers(
                    widevine.mapKeys { it.key as String }.mapValues { it.value as String}
                )
            }
            drm.widevine(widevineDRMConfiguration.build())
        }

        flutterDRMConfiguration.fairplay?.let { flutterFairplayConfig ->
            val fairplayDRMConfiguration = FairPlayKeySystemConfiguration.Builder(flutterFairplayConfig.licenseAcquisitionURL, flutterFairplayConfig.certificateURL)
            flutterFairplayConfig.headers?.let { fairplay ->
                fairplayDRMConfiguration.headers(
                    fairplay.mapKeys { it.key as String }.mapValues { it.value as String}
                )
            }
            drm.fairplay(fairplayDRMConfiguration.build())
        }

        flutterDRMConfiguration.customIntegrationId?.let {
            drm.customIntegrationId(it);
        }

        flutterDRMConfiguration.integrationParameters?.let { integrationParams ->
            drm.integrationParameters(
                integrationParams.mapKeys { it.key as String }.mapValues { it.value}
            )
        }

        return drm.build()
    }

}