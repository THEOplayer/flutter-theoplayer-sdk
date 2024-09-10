//
//  PlatformActivityService.swift
//  Pods
//
//  Created by Daniel on 03/09/2024.
//

import Foundation
import Flutter

class PlatformActivityService {
    static func shared() -> PlatformActivityService {
        if let instance = _instance {
            return instance
        }
        
        preconditionFailure("Call `PlatformActivityService.ensureInitialized` first!")
    }
    
    private static var _instance: PlatformActivityService?
    private let _methodChannel: FlutterMethodChannel

    private init(messenger: FlutterBinaryMessenger) {
        _methodChannel = FlutterMethodChannel(name: "com.theoplayer.global/activity", binaryMessenger: messenger)
    }
    
    static func ensureInitialized(messenger: FlutterBinaryMessenger) {
       _instance = PlatformActivityService(messenger: messenger)
    }
    
    func sendUserLeaveHint() {
        _methodChannel.invokeMethod("onUserLeaveHint", arguments: nil)
    }

    func sendExitPictureInPicture() {
        _methodChannel.invokeMethod("onExitPictureInPicture", arguments: nil);
    }
    
    
}
