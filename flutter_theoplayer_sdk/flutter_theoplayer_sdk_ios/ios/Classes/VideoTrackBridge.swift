//
//  VideoTrackBridge.swift
//  flutter_theoplayer_sdk_ios
//
//  Created by Hovig on 27/11/2023.
//

import Foundation
import THEOplayerSDK
import Flutter

class VideoTrackBridge: THEOplayerNativeVideoTracksAPI {
    
    private let theoplayer: THEOplayer
    private let pigeonMessenger: PigeonBinaryMessengerWrapper
    private let flutterVideoTracksAPI: THEOplayerFlutterVideoTracksAPI
    
    private var addVideoTrackListener: EventListener?
    private var removeVideoTrackListener: EventListener?
    private var videoTrackListChangeListener: EventListener?
    
    private let emptyCompletion: (Result<Void, FlutterError>) -> Void = {result in }
    
    init(theoplayer: THEOplayer, pigeonMessenger: PigeonBinaryMessengerWrapper) {
        self.theoplayer = theoplayer
        self.pigeonMessenger = pigeonMessenger
        self.flutterVideoTracksAPI = THEOplayerFlutterVideoTracksAPI(binaryMessenger: pigeonMessenger)
        THEOplayerNativeVideoTracksAPISetup.setUp(binaryMessenger: pigeonMessenger, api: self)
    }
    
    func attachListeners() {
        addVideoTrackListener = theoplayer.videoTracks.addEventListener(type: VideoTrackListEventTypes.ADD_TRACK, listener: { [weak self] event in
            guard let self else { return }
            if let videoTrack = event.track as? VideoTrack {
                self.flutterVideoTracksAPI.onAddVideoTrack(
                    id: videoTrack.id,
                    uid: Int64(videoTrack.uid),
                    label: videoTrack.label,
                    language: videoTrack.language,
                    kind: videoTrack.kind,
                    isEnabled: videoTrack.enabled,
                    completion: self.emptyCompletion)

            }
        })

        removeVideoTrackListener = theoplayer.videoTracks.addEventListener(type: VideoTrackListEventTypes.REMOVE_TRACK, listener: { [weak self] event in
            guard let self else { return }
            self.flutterVideoTracksAPI.onRemoveVideoTrack(uid: Int64(event.track.uid), completion: self.emptyCompletion)
        })

        videoTrackListChangeListener = theoplayer.videoTracks.addEventListener(type: VideoTrackListEventTypes.CHANGE, listener: { [weak self] event in
            guard let self else { return }
            self.flutterVideoTracksAPI.onVideoTrackListChange(uid: Int64(event.track.uid), completion: self.emptyCompletion)
        })
    }
    
    private func removeListeners() {
        // TODO: remove force unwraps
        theoplayer.videoTracks.removeEventListener(type: VideoTrackListEventTypes.ADD_TRACK, listener: addVideoTrackListener!)
        theoplayer.videoTracks.removeEventListener(type: VideoTrackListEventTypes.REMOVE_TRACK, listener: removeVideoTrackListener!)
        theoplayer.videoTracks.removeEventListener(type: VideoTrackListEventTypes.CHANGE, listener: videoTrackListChangeListener!)
    }
    
    func dispose() {
        removeListeners()
        THEOplayerNativeVideoTracksAPISetup.setUp(binaryMessenger: pigeonMessenger, api: nil)
    }
    
    func setTargetQuality(videoTrackUid: Int64, qualityUid: Int64?) throws {
        // Qualities are not available for iOS
    }
    
    func setTargetQualities(videoTrackUid: Int64, qualitiesUid: [Int64]?) throws {
        // Qualities are not available for iOS
    }
    
    func setEnabled(videoTrackUid: Int64, enabled: Bool) throws {
        for i in 0..<theoplayer.videoTracks.count {
            var track = theoplayer.videoTracks.get(i)
            if (track.uid == videoTrackUid) {
                track.enabled = enabled
            }
        }
    }
    
}
