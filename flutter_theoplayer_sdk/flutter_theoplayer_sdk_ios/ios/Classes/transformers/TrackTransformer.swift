//
//  TrackTransformer.swift
//  flutter_theoplayer_sdk_ios
//
//  Created by Hovig on 16/11/2023.
//

import Foundation
import THEOplayerSDK

struct TrackTransformer {
    
    static func toFlutterTextTrackMode(mode: THEOplayerSDK.TextTrackMode) -> TextTrackMode {
        switch(mode) {
        case .disabled:
            return .disabled
        case .hidden:
            return .hidden
        case .showing:
            return .showing
        default:
            return .disabled
        }
    }
    
    static func toFlutterTextTrackType(type: String) -> TextTrackType {
        switch(type) {
        case "srt":
            return .srt
        case "ttml":
            return .ttml
        case "webvtt":
            return .webvtt
        case "emsg":
            return .emsg
        case "eventstream":
            return .eventstream
        case "id3":
            return .id3
        case "cea608":
            return .cea608
        case "daterange":
            return .daterange
        case "timecode":
            return .timecode
        default:
            return .none
        }
    }

    static func toTextTrackMode(mode: TextTrackMode) -> THEOplayerSDK.TextTrackMode {
        switch(mode) {
        case .disabled:
            return .disabled
        case .hidden:
            return .hidden
        case .showing:
            return .showing
        }
    }
    
}
