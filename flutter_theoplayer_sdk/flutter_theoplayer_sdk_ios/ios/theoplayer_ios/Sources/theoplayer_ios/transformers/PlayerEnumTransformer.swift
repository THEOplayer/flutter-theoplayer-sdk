//
//  PlayerEnumTransformer.swift
//  flutter_theoplayer_sdk_ios
//
//  Created by Hovig on 16/10/2023.
//

import Foundation
import THEOplayerSDK

struct PlayerEnumTransformer {
    
    static func toFlutterReadyState(readyState: THEOplayerSDK.ReadyState) -> ReadyState {
        switch(readyState) {
        case .HAVE_NOTHING:
            return .haveNothing
        case .HAVE_METADATA:
            return .haveMetadata
        case .HAVE_CURRENT_DATA:
            return .haveCurrentData
        case .HAVE_FUTURE_DATA:
            return .haveFutureData
        case .HAVE_ENOUGH_DATA:
            return .haveEnoughData
        default:
            return .haveNothing
        }
    }
    
    static func toFlutterPreloadType(preload: THEOplayerSDK.Preload) -> PreloadType {
        switch(preload) {
        case .none:
            return .none
        case .auto:
            return .auto
        case .metadata:
            return .metadata
        default:
            return .none
        }
    }
    
    static func toPreloadType(preload: PreloadType) -> THEOplayerSDK.Preload {
        switch(preload) {
        case .none:
            return .none
        case .auto:
            return .auto
        case .metadata:
            return .metadata
        }
    }
    
}
