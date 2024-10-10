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
    
    private var addTextTrackListener: EventListener?
    private var removeTextTrackListener: EventListener?
    private var textTrackListChange: EventListener?
    
    private var textTrackAddCueListener: EventListener?
    private var textTrackRemoveCueListener: EventListener?
    private var textTrackEnterCueListener: EventListener?
    private var textTrackExitCueListener: EventListener?
    private var textTrackCueChangeListener: EventListener?
    private var textTrackChangeListener: EventListener?
    
    private var cueEnterListener: EventListener?
    private var cueExitListener: EventListener?
    private var cueUpdateListener: EventListener?
    
    private let emptyCompletion: (Result<Void, FlutterError>) -> Void = {result in }
    
    init(theoplayer: THEOplayer, pigeonMessenger: PigeonBinaryMessengerWrapper) {
        self.theoplayer = theoplayer
        self.pigeonMessenger = pigeonMessenger
        self.flutterTextTracksAPI = THEOplayerFlutterTextTracksAPI(binaryMessenger: pigeonMessenger)
        THEOplayerNativeTextTracksAPISetup.setUp(binaryMessenger: pigeonMessenger, api: self)
    }
    
    func attachListeners() {
        addTextTrackListener = theoplayer.textTracks.addEventListener(type: TextTrackListEventTypes.ADD_TRACK, listener: { event in
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
        
        removeTextTrackListener = theoplayer.textTracks.addEventListener(type: TextTrackListEventTypes.REMOVE_TRACK, listener: { event in
            self.flutterTextTracksAPI.onRemoveTextTrack(uid: Int64(event.track.uid), completion: self.emptyCompletion)
        })
        
        textTrackListChange = theoplayer.textTracks.addEventListener(type: TextTrackListEventTypes.CHANGE, listener: { event in
            self.flutterTextTracksAPI.onTextTrackListChange(uid: Int64(event.track.uid), completion: self.emptyCompletion)
        })
    }
    
    func removeListeners() {
        // TODO: remove force unwraps
        theoplayer.textTracks.removeEventListener(type: TextTrackListEventTypes.ADD_TRACK, listener: addTextTrackListener!)
        theoplayer.textTracks.removeEventListener(type: TextTrackListEventTypes.REMOVE_TRACK, listener: removeTextTrackListener!)
        theoplayer.textTracks.removeEventListener(type: TextTrackListEventTypes.CHANGE, listener: textTrackListChange!)
        
        for i in 0..<theoplayer.textTracks.count {
            let track = theoplayer.textTracks.get(i)
            removeTrackListeners(track: track)
            track.cues.forEach { cue in
                removeCueListeners(track: track, cue: cue)
            }
        }
    }
    
    private func attachTrackListeners(track: TextTrack) {
        textTrackAddCueListener = track.addEventListener(type: TextTrackEventTypes.ADD_CUE, listener: { event in
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
        textTrackRemoveCueListener = track.addEventListener(type: TextTrackEventTypes.REMOVE_CUE, listener: { event in
            self.flutterTextTracksAPI.onTextTrackRemoveCue(textTrackUid: Int64(track.uid), cueUid: Int64(event.cue.uid), completion: self.emptyCompletion)
        })
        textTrackEnterCueListener = track.addEventListener(type: TextTrackEventTypes.ENTER_CUE, listener: { event in
            self.flutterTextTracksAPI.onTextTrackEnterCue(textTrackUid: Int64(track.uid), cueUid: Int64(event.cue.uid), completion: self.emptyCompletion)
        })
        textTrackExitCueListener = track.addEventListener(type: TextTrackEventTypes.EXIT_CUE, listener: { event in
            self.flutterTextTracksAPI.onTextTrackExitCue(textTrackUid: Int64(track.uid), cueUid: Int64(event.cue.uid), completion: self.emptyCompletion)
        })
        textTrackCueChangeListener = track.addEventListener(type: TextTrackEventTypes.CUE_CHANGE, listener: { event in
            self.flutterTextTracksAPI.onTextTrackCueChange(textTrackUid: Int64(track.uid), completion: self.emptyCompletion)
        })
    }
    
    private func removeTrackListeners(track: TextTrack) {
        track.removeEventListener(type: TextTrackEventTypes.ADD_CUE, listener: textTrackAddCueListener!)
        track.removeEventListener(type: TextTrackEventTypes.REMOVE_CUE, listener: textTrackRemoveCueListener!)
        track.removeEventListener(type: TextTrackEventTypes.ENTER_CUE, listener: textTrackEnterCueListener!)
        track.removeEventListener(type: TextTrackEventTypes.EXIT_CUE, listener: textTrackExitCueListener!)
        track.removeEventListener(type: TextTrackEventTypes.CUE_CHANGE, listener: textTrackCueChangeListener!)
    }
    
    private func attachCueListeners(track: TextTrack, cue: TextTrackCue) {
        cueEnterListener = cue.addEventListener(type: TextTrackCueEventTypes.ENTER, listener: {event in
            self.flutterTextTracksAPI.onCueEnter(textTrackUid: Int64(track.uid), cueUid: Int64(cue.uid), completion: self.emptyCompletion)
        })
        cueExitListener = cue.addEventListener(type: TextTrackCueEventTypes.EXIT, listener: {event in
            self.flutterTextTracksAPI.onCueExit(textTrackUid: Int64(track.uid), cueUid: Int64(cue.uid), completion: self.emptyCompletion)
        })
        cueUpdateListener = cue.addEventListener(type: TextTrackCueEventTypes.UPDATE, listener: {event in
            self.flutterTextTracksAPI.onCueUpdate(
                textTrackUid: Int64(track.uid),
                cueUid: Int64(cue.uid),
                endTime: event.cue.endTime ?? 0,
                content: event.cue.contentString ?? "",
                completion: self.emptyCompletion)
        })
    }
    
    private func removeCueListeners(track: TextTrack, cue: TextTrackCue) {
        cue.removeEventListener(type: TextTrackCueEventTypes.ENTER, listener: cueEnterListener!)
        cue.removeEventListener(type: TextTrackCueEventTypes.EXIT, listener: cueExitListener!)
        cue.removeEventListener(type: TextTrackCueEventTypes.UPDATE, listener: cueUpdateListener!)
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
