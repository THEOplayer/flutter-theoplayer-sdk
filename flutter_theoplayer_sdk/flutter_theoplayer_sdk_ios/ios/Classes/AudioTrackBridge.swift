//
//  AudioTrackBridge.swift
//  flutter_theoplayer_sdk_ios
//
//  Created by Hovig on 27/11/2023.
//

import Foundation
import THEOplayerSDK
import Flutter

class AudioTrackBridge: THEOplayerNativeAudioTracksAPI {
    
    private let theoplayer: THEOplayer
    private let pigeonMessenger: PigeonBinaryMessengerWrapper
    private let flutterAudioTracksAPI: THEOplayerFlutterAudioTracksAPI
    
    private var addAudioTrackListener: EventListener?
    private var removeAudioTrackListener: EventListener?
    private var audioTrackListChangeListener: EventListener?
    
    private let emptyCompletion: (Result<Void, FlutterError>) -> Void = {result in }
    
    init(theoplayer: THEOplayer, pigeonMessenger: PigeonBinaryMessengerWrapper) {
        self.theoplayer = theoplayer
        self.pigeonMessenger = pigeonMessenger
        self.flutterAudioTracksAPI = THEOplayerFlutterAudioTracksAPI(binaryMessenger: pigeonMessenger)
        THEOplayerNativeAudioTracksAPISetup.setUp(binaryMessenger: pigeonMessenger, api: self)
    }
    
    func attachListeners() {
        addAudioTrackListener = theoplayer.audioTracks.addEventListener(type: AudioTrackListEventTypes.ADD_TRACK, listener: { event in
            if let audioTrack = event.track as? AudioTrack {
                self.flutterAudioTracksAPI.onAddAudioTrack(
                    id: audioTrack.id,
                    uid: Int64(audioTrack.uid),
                    label: audioTrack.label,
                    language: audioTrack.language,
                    kind: audioTrack.kind,
                    isEnabled: audioTrack.enabled,
                    completion: self.emptyCompletion)
             
            }
        })
        
        removeAudioTrackListener = theoplayer.audioTracks.addEventListener(type: AudioTrackListEventTypes.REMOVE_TRACK, listener: { event in
            self.flutterAudioTracksAPI.onRemoveAudioTrack(uid: Int64(event.track.uid), completion: self.emptyCompletion)
        })
        
        audioTrackListChangeListener = theoplayer.audioTracks.addEventListener(type: AudioTrackListEventTypes.CHANGE, listener: { event in
            self.flutterAudioTracksAPI.onAudioTrackListChange(uid: Int64(event.track.uid), completion: self.emptyCompletion)
        })
    }
    
    func removeListeners() {
        // TODO: remove force unwraps
        theoplayer.audioTracks.removeEventListener(type: AudioTrackListEventTypes.ADD_TRACK, listener: addAudioTrackListener!)
        theoplayer.audioTracks.removeEventListener(type: AudioTrackListEventTypes.REMOVE_TRACK, listener: removeAudioTrackListener!)
        theoplayer.audioTracks.removeEventListener(type: AudioTrackListEventTypes.CHANGE, listener: audioTrackListChangeListener!)
    }
    
    func setTargetQuality(audioTrackUid: Int64, qualityUid: Int64?) throws {
        // Qualities are not available for iOS
    }
    
    func setTargetQualities(audioTrackUid: Int64, qualitiesUid: [Int64]?) throws {
        // Qualities are not available for iOS
    }
    
    func setEnabled(audioTrackUid: Int64, enabled: Bool) throws {
        for i in 0..<theoplayer.audioTracks.count {
            var track = theoplayer.audioTracks.get(i)
            if (track.uid == audioTrackUid) {
                track.enabled = enabled
            }
        }
    }
    
}
