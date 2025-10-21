//
//  TextTrackBridge.swift
//  flutter_theoplayer_sdk_ios
//
//  Created by Hovig on 15/11/2023.
//

import Foundation
import THEOplayerSDK
import Flutter

class TextTrackBridge: THEOplayerNativeTextTracksAPI {
    
    private let theoplayer: THEOplayer
    private let pigeonMessenger: PigeonBinaryMessengerWrapper
    private let flutterTextTracksAPI: THEOplayerFlutterTextTracksAPI
    
    private var textTrackListDispatchObservers: [DispatchObserver] = []
    private var textTrackDispatchObservers: [DispatchObserver] = []
    private var cueDispatchObservers: [DispatchObserver] = []

    private let emptyCompletion: (Result<Void, FlutterError>) -> Void = {result in }
    
    init(theoplayer: THEOplayer, pigeonMessenger: PigeonBinaryMessengerWrapper) {
        self.theoplayer = theoplayer
        self.pigeonMessenger = pigeonMessenger
        self.flutterTextTracksAPI = THEOplayerFlutterTextTracksAPI(binaryMessenger: pigeonMessenger)
        THEOplayerNativeTextTracksAPISetup.setUp(binaryMessenger: pigeonMessenger, api: self)
    }
    
    func attachListeners() {
        let addTextTrackListener = theoplayer.textTracks.addRemovableEventListener(type: TextTrackListEventTypes.ADD_TRACK, listener: { [weak self] event in
            guard let self else { return }
            if let textTrack = event.track as? TextTrack {
                self.flutterTextTracksAPI.onAddTextTrack(
                    id: textTrack.id,
                    uid: Int64(textTrack.uid),
                    label: textTrack.label,
                    language: textTrack.language,
                    kind: textTrack.kind,
                    inBandMetadataTrackDispatchType: textTrack.inBandMetadataTrackDispatchType,
                    readyState: TextTrackReadyState.loaded,
                    type: TextTrackType.none,
                    source: textTrack.src,
                    isForced: false,
                    mode: TrackTransformer.toFlutterTextTrackMode(mode: textTrack.mode),
                    completion: self.emptyCompletion)
                self.attachTrackListeners(track: textTrack)
            }
        })

        let removeTextTrackListener = theoplayer.textTracks.addRemovableEventListener(type: TextTrackListEventTypes.REMOVE_TRACK, listener: { [weak self] event in
            guard let self else { return }
            self.flutterTextTracksAPI.onRemoveTextTrack(uid: Int64(event.track.uid), completion: self.emptyCompletion)
            
            if let track = event.track as? TextTrack {
                self.removeTrackListeners(track: track)
            }
                        
        })

        let textTrackListChange = theoplayer.textTracks.addRemovableEventListener(type: TextTrackListEventTypes.CHANGE, listener: { [weak self] event in
            guard let self else { return }
            self.flutterTextTracksAPI.onTextTrackListChange(uid: Int64(event.track.uid), completion: self.emptyCompletion)
        })
        
        textTrackListDispatchObservers.append(DispatchObserver(
            dispatcher: theoplayer.textTracks,
            eventListeners: [
                addTextTrackListener,
                removeTextTrackListener,
                textTrackListChange
            ]
        ))
    }
    
    private func removeListeners() {
        for i in 0..<theoplayer.textTracks.count {
            let track = theoplayer.textTracks.get(i)
            removeTrackListeners(track: track)
        }
        
        textTrackListDispatchObservers.removeAll()
        textTrackDispatchObservers.removeAll()
        cueDispatchObservers.removeAll()
    }
    
    func dispose() {
        removeListeners()
        THEOplayerNativeTextTracksAPISetup.setUp(binaryMessenger: pigeonMessenger, api: nil)
    }
    
    private func attachTrackListeners(track: TextTrack) {
        let textTrackAddCueListener = track.addRemovableEventListener(type: TextTrackEventTypes.ADD_CUE, listener: { [weak self] event in
            guard let self else { return }
            self.flutterTextTracksAPI.onTextTrackAddCue(
                textTrackUid: Int64(track.uid),
                id: event.cue.id,
                uid: Int64(event.cue.uid),
                startTime: event.cue.startTime ?? 0,
                endTime: event.cue.endTime ?? 0,
                content: event.cue.contentString ?? "",
                completion: self.emptyCompletion)
            self.attachCueListeners(track: track, cue: event.cue)
        })
        let textTrackRemoveCueListener = track.addRemovableEventListener(type: TextTrackEventTypes.REMOVE_CUE, listener: { [weak self] event in
            guard let self else { return }
            self.flutterTextTracksAPI.onTextTrackRemoveCue(textTrackUid: Int64(track.uid), cueUid: Int64(event.cue.uid), completion: self.emptyCompletion)
            
            self.removeCueListeners(track: track, cue: event.cue)
        })
        let textTrackEnterCueListener = track.addRemovableEventListener(type: TextTrackEventTypes.ENTER_CUE, listener: { [weak self] event in
            guard let self else { return }
            self.flutterTextTracksAPI.onTextTrackEnterCue(textTrackUid: Int64(track.uid), cueUid: Int64(event.cue.uid), completion: self.emptyCompletion)
        })
        let textTrackExitCueListener = track.addRemovableEventListener(type: TextTrackEventTypes.EXIT_CUE, listener: { [weak self] event in
            guard let self else { return }
            self.flutterTextTracksAPI.onTextTrackExitCue(textTrackUid: Int64(track.uid), cueUid: Int64(event.cue.uid), completion: self.emptyCompletion)
        })
        let textTrackCueChangeListener = track.addRemovableEventListener(type: TextTrackEventTypes.CUE_CHANGE, listener: { [weak self] event in
            guard let self else { return }
            self.flutterTextTracksAPI.onTextTrackCueChange(textTrackUid: Int64(track.uid), completion: self.emptyCompletion)
        })
        
        textTrackDispatchObservers.append(DispatchObserver(
            dispatcher: track,
            eventListeners: [
                textTrackAddCueListener,
                textTrackRemoveCueListener,
                textTrackEnterCueListener,
                textTrackExitCueListener,
                textTrackCueChangeListener
            ]
        ))
    }
    
    private func removeTrackListeners(track: TextTrack) {
        textTrackDispatchObservers.removeAll { dpo in
            track.id == (dpo._dispatcher as? TextTrack)?.id
        }
        track.cues.forEach { cue in
            removeCueListeners(track: track, cue: cue)
        }
    }
    
    private func attachCueListeners(track: TextTrack, cue: TextTrackCue) {
        let cueEnterListener = cue.addRemovableEventListener(type: TextTrackCueEventTypes.ENTER, listener: { [weak self] event in
            guard let self else { return }
            self.flutterTextTracksAPI.onCueEnter(textTrackUid: Int64(track.uid), cueUid: Int64(cue.uid), completion: self.emptyCompletion)

        })
        let cueExitListener = cue.addRemovableEventListener(type: TextTrackCueEventTypes.EXIT, listener: { [weak self] event in
            guard let self else { return }
            self.flutterTextTracksAPI.onCueExit(textTrackUid: Int64(track.uid), cueUid: Int64(cue.uid), completion: self.emptyCompletion)
        })
        let cueUpdateListener = cue.addRemovableEventListener(type: TextTrackCueEventTypes.UPDATE, listener: { [weak self] event in
            guard let self else { return }
            self.flutterTextTracksAPI.onCueUpdate(
                textTrackUid: Int64(track.uid),
                cueUid: Int64(cue.uid),
                endTime: event.cue.endTime ?? 0,
                content: event.cue.contentString ?? "",
                completion: self.emptyCompletion)
        })
        
        cueDispatchObservers.append(DispatchObserver(dispatcher: cue, eventListeners: [
            cueEnterListener,
            cueExitListener,
            cueUpdateListener
        ]))
    }
    
    private func removeCueListeners(track: TextTrack, cue: TextTrackCue) {
        cueDispatchObservers.removeAll { dpo in
            cue.id == (dpo._dispatcher as? TextTrackCue)?.id
        }
    }
    
    func setMode(textTrackUid: Int64, mode: TextTrackMode) {
        for i in 0..<theoplayer.textTracks.count {
            var track = theoplayer.textTracks.get(i)
            if (track.uid == textTrackUid) {
                track.mode = TrackTransformer.toTextTrackMode(mode: mode)
            }
        }
    }
    
}
