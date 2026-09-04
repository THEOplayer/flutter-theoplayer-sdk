package com.theoplayer.flutter.transformers

import com.theoplayer.flutter.pigeon.TypedSourcePigeon as FlutterTypedSource
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertNull

internal class SourceTransformerTest {

    private fun typedSource(hlsDateRange: Boolean?) = FlutterTypedSource(
        src = "https://example.com/stream.m3u8",
        hlsDateRange = hlsDateRange,
    )

    @Test
    fun sourceLevelHlsDateRangeOverridesDefault() {
        val source = SourceTransformer.toTypedSource(typedSource(hlsDateRange = false), defaultHlsDateRange = true)
        assertEquals(false, source?.hlsDateRange)
    }

    @Test
    fun playerLevelDefaultAppliesWhenSourceDoesNotSetIt() {
        val source = SourceTransformer.toTypedSource(typedSource(hlsDateRange = null), defaultHlsDateRange = true)
        assertEquals(true, source?.hlsDateRange)
    }

    @Test
    fun hlsDateRangeStaysUnsetWhenNeitherIsConfigured() {
        val source = SourceTransformer.toTypedSource(typedSource(hlsDateRange = null), defaultHlsDateRange = null)
        assertNull(source?.hlsDateRange)
    }
}
