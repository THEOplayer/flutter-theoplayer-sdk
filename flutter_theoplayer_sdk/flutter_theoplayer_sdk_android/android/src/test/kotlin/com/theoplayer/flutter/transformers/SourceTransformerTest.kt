package com.theoplayer.flutter.transformers

import com.theoplayer.android.api.theolive.TheoLiveSource
import com.theoplayer.flutter.pigeon.SourceIntegrationId
import com.theoplayer.flutter.pigeon.SourceLatencyConfiguration as FlutterSourceLatencyConfiguration
import com.theoplayer.flutter.pigeon.TypedSourcePigeon as FlutterTypedSource
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertNull

internal class SourceTransformerTest {

    private fun typedSource(
        hlsDateRange: Boolean? = null,
        lowLatency: Boolean? = null,
        latencyConfiguration: FlutterSourceLatencyConfiguration? = null,
        integration: SourceIntegrationId? = null,
    ) = FlutterTypedSource(
        src = "https://example.com/stream.m3u8",
        hlsDateRange = hlsDateRange,
        lowLatency = lowLatency,
        latencyConfiguration = latencyConfiguration,
        integration = integration,
    )

    @Test
    fun sourceLevelHlsDateRangeOverridesDefault() {
        val source = SourceTransformer.toTypedSource(typedSource(hlsDateRange = false), defaultHlsDateRange = true)
        assertEquals(false, source?.hlsDateRange)
    }

    @Test
    fun playerLevelDefaultAppliesWhenSourceDoesNotSetIt() {
        val source = SourceTransformer.toTypedSource(typedSource(), defaultHlsDateRange = true)
        assertEquals(true, source?.hlsDateRange)
    }

    @Test
    fun hlsDateRangeStaysUnsetWhenNeitherIsConfigured() {
        val source = SourceTransformer.toTypedSource(typedSource(), defaultHlsDateRange = null)
        assertNull(source?.hlsDateRange)
    }

    @Test
    fun mapsEveryLatencyControl() {
        val source = SourceTransformer.toTypedSource(
            typedSource(
                lowLatency = true,
                latencyConfiguration = FlutterSourceLatencyConfiguration(
                    targetOffset = 3.0,
                    minimumOffset = 2.0,
                    maximumOffset = 4.0,
                    forceSeekOffset = 10.0,
                    minimumPlaybackRate = 0.95,
                    maximumPlaybackRate = 1.05,
                ),
            )
        )!!
        val latencyConfiguration = source.latencyConfiguration!!

        assertEquals(3.0, latencyConfiguration.targetOffset)
        assertEquals(2.0, latencyConfiguration.minimumOffset)
        assertEquals(4.0, latencyConfiguration.maximumOffset)
        assertEquals(10.0, latencyConfiguration.forceSeekOffset)
        assertEquals(0.95, latencyConfiguration.minimumPlaybackRate)
        assertEquals(1.05, latencyConfiguration.maximumPlaybackRate)
        assertNull(source.lowLatency)
    }

    @Test
    fun preservesNativeDefaultsForOmittedLatencyControls() {
        val source = SourceTransformer.toTypedSource(
            typedSource(latencyConfiguration = FlutterSourceLatencyConfiguration(targetOffset = 3.0))
        )!!
        val latencyConfiguration = source.latencyConfiguration!!

        assertEquals(3.0, latencyConfiguration.targetOffset)
        assertEquals(1.98, latencyConfiguration.minimumOffset)
        assertEquals(4.5, latencyConfiguration.maximumOffset)
        assertEquals(9.0, latencyConfiguration.forceSeekOffset)
        assertEquals(0.92, latencyConfiguration.minimumPlaybackRate)
        assertEquals(1.08, latencyConfiguration.maximumPlaybackRate)
    }

    @Test
    fun mapsTheoLiveLatencyConfiguration() {
        val source = SourceTransformer.toTypedSource(
            typedSource(
                integration = SourceIntegrationId.THEOLIVE,
                latencyConfiguration = FlutterSourceLatencyConfiguration(targetOffset = 2.0),
            )
        ) as TheoLiveSource

        assertEquals(2.0, source.latencyConfiguration?.targetOffset)
    }
}
