//
//  TimeRangeTransformer.swift
//  flutter_theoplayer_sdk_ios
//
//  Created by Hovig on 17/10/2023.
//

import Foundation
import THEOplayerSDK

struct TimeRangeTransformer {
    
    static func toFlutterTimeRanges(timeRanges:[THEOplayerSDK.TimeRange]) -> [TimeRange] {
        timeRanges.map { timeRange in
            TimeRange(start: timeRange.start, end: timeRange.end)
        }
    }
}
