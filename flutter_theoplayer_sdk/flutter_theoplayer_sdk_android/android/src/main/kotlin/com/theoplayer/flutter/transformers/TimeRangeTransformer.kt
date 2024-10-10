package com.theoplayer.flutter.transformers

import com.theoplayer.android.api.timerange.TimeRanges

typealias FlutterTimeRange = com.theoplayer.flutter.pigeon.TimeRange

object TimeRangeTransformer {

    fun toFlutterTimeRanges(timeRanges: TimeRanges): List<FlutterTimeRange> {
        return timeRanges.map {
            FlutterTimeRange(it.start, it.end)
        }
    }

}