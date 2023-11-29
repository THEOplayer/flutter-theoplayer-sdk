package com.theoplayer.theoplayer.transformers

import com.theoplayer.android.api.timerange.TimeRanges

typealias FlutterTimeRange = com.theoplayer.theoplayer.pigeon.TimeRange

object TimeRangeTransformer {

    fun toFlutterTimeRanges(timeRanges: TimeRanges): List<FlutterTimeRange> {
        return timeRanges.map {
            FlutterTimeRange(it.start, it.end)
        }
    }

}