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
