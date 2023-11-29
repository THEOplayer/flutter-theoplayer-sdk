//
//  PlayerEventForwarder.swift
//  flutter_theoplayer_sdk_ios
//
//  Created by Hovig on 18/10/2023.
//

import Foundation
import THEOplayerSDK
import Flutter

class PlayerEventForwarder {
    
    private let theoplayer: THEOplayer
    private let flutterAPI: THEOplayerFlutterAPI
    
    private var sourceChangeEventListener: EventListener?
    private var playEventListener: EventListener?
    private var playingEventListener: EventListener?
    private var pauseEventListener: EventListener?
    private var waitingEventListener: EventListener?
    private var durationChangeEventListener: EventListener?
    private var progressEventListener: EventListener?
    private var timeUpdateEventListener: EventListener?
    private var rateChangeEventListener: EventListener?
    private var seekingEventListener: EventListener?
    private var seekedEventListener: EventListener?
    private var volumeChangeEventListener: EventListener?
    private var resizeEventListener: EventListener?
    private var endedEventListener: EventListener?
    private var errorEventListener: EventListener?
    private var destroyEventListener: EventListener?
    private var readyStateChangeEventListener: EventListener?
    private var loadStartEventListener: EventListener?
    private var loadedMetadataEventListener: EventListener?
    private var loadedDataEventListener: EventListener?
    private var canPlayEventListener: EventListener?
    private var canPlayThroughEventListener: EventListener?
    
    private let emptyCompletion: (Result<Void, FlutterError>) -> Void = {result in }
    
    init(theoplayer: THEOplayer, flutterAPI: THEOplayerFlutterAPI) {
        self.theoplayer = theoplayer
        self.flutterAPI = flutterAPI
    }
    
    func attachListeners() {
        sourceChangeEventListener = theoplayer.addEventListener(type: PlayerEventTypes.SOURCE_CHANGE, listener: {event in
            self.flutterAPI.onSourceChange(source: SourceTransformer.toFlutterSourceDescription(source: event.source), completion: self.emptyCompletion)
        })
        
        playEventListener = theoplayer.addEventListener(type: PlayerEventTypes.PLAY, listener: {event in
            self.flutterAPI.onPlay(currentTime: event.currentTime, completion: self.emptyCompletion)
        })
        
        playingEventListener = theoplayer.addEventListener(type: PlayerEventTypes.PLAYING, listener: {event in
            self.flutterAPI.onPlaying(currentTime: event.currentTime, completion: self.emptyCompletion)
        })
        
        pauseEventListener = theoplayer.addEventListener(type: PlayerEventTypes.PAUSE, listener: {event in
            self.flutterAPI.onPause(currentTime: event.currentTime, completion: self.emptyCompletion)
        })
        
        waitingEventListener = theoplayer.addEventListener(type: PlayerEventTypes.WAITING, listener: {event in
            self.flutterAPI.onWaiting(currentTime: event.currentTime, completion: self.emptyCompletion)
        })
        
        durationChangeEventListener = theoplayer.addEventListener(type: PlayerEventTypes.DURATION_CHANGE, listener: {event in
            self.flutterAPI.onDurationChange(duration: event.duration ?? 0, completion: self.emptyCompletion)
        })
        
        progressEventListener = theoplayer.addEventListener(type: PlayerEventTypes.PROGRESS, listener: {event in
            self.flutterAPI.onProgress(currentTime: event.currentTime, completion: self.emptyCompletion)
        })
        
        timeUpdateEventListener = theoplayer.addEventListener(type: PlayerEventTypes.TIME_UPDATE, listener: {event in
            var currentProgramDateTime: Int64?;
            if let timeIntervalSince1970 = event.currentProgramDateTime?.timeIntervalSince1970 {
                currentProgramDateTime = Int64(timeIntervalSince1970)
            }
            
            self.flutterAPI.onTimeUpdate(currentTime: event.currentTime, currentProgramDateTime: currentProgramDateTime, completion: self.emptyCompletion)
        })
        
        rateChangeEventListener = theoplayer.addEventListener(type: PlayerEventTypes.RATE_CHANGE, listener: {event in
            self.flutterAPI.onRateChange(currentTime: event.currentTime, playbackRate: event.playbackRate, completion: self.emptyCompletion)
        })
        
        seekingEventListener = theoplayer.addEventListener(type: PlayerEventTypes.SEEKING, listener: {event in
            self.flutterAPI.onSeeking(currentTime: event.currentTime, completion: self.emptyCompletion)
        })
        
        seekedEventListener = theoplayer.addEventListener(type: PlayerEventTypes.SEEKED, listener: {event in
            self.flutterAPI.onSeeked(currentTime: event.currentTime, completion: self.emptyCompletion)
        })
        
        volumeChangeEventListener = theoplayer.addEventListener(type: PlayerEventTypes.VOLUME_CHANGE, listener: {event in
            self.flutterAPI.onVolumeChange(currentTime: event.currentTime, volume: Double(event.volume), completion: self.emptyCompletion)
        })
        
        resizeEventListener = theoplayer.addEventListener(type: PlayerEventTypes.RESIZE, listener: {event in
            self.flutterAPI.onResize(
                currentTime: self.theoplayer.currentTime,
                width: Int64(self.theoplayer.videoWidth),
                height: Int64(self.theoplayer.videoHeight),
                completion: self.emptyCompletion)
        })
        
        endedEventListener = theoplayer.addEventListener(type: PlayerEventTypes.ENDED, listener: {event in
            self.flutterAPI.onEnded(currentTime: event.currentTime, completion: self.emptyCompletion)
        })
        
        errorEventListener = theoplayer.addEventListener(type: PlayerEventTypes.ERROR, listener: {event in
            self.flutterAPI.onError(error: event.error, completion: self.emptyCompletion)
        })
        
        destroyEventListener = theoplayer.addEventListener(type: PlayerEventTypes.DESTROY, listener: {event in
            self.flutterAPI.onDestroy(completion: self.emptyCompletion)
        })
        
        readyStateChangeEventListener = theoplayer.addEventListener(type: PlayerEventTypes.READY_STATE_CHANGE, listener: {event in
            self.flutterAPI.onReadyStateChange(currentTime: event.currentTime, readyState: PlayerEnumTransformer.toFlutterReadyState(readyState: event.readyState), completion: self.emptyCompletion)
        })
        
        loadStartEventListener = theoplayer.addEventListener(type: PlayerEventTypes.LOAD_START, listener: {event in
            self.flutterAPI.onLoadStart(completion: self.emptyCompletion)
        })
        
        loadedMetadataEventListener = theoplayer.addEventListener(type: PlayerEventTypes.LOADED_META_DATA, listener: {event in
            self.flutterAPI.onLoadedMetadata(currentTime: event.currentTime, completion: self.emptyCompletion)
        })
        
        loadedDataEventListener = theoplayer.addEventListener(type: PlayerEventTypes.LOADED_DATA, listener: {event in
            self.flutterAPI.onLoadedData(currentTime: event.currentTime, completion: self.emptyCompletion)
        })
        
        canPlayEventListener = theoplayer.addEventListener(type: PlayerEventTypes.CAN_PLAY, listener: {event in
            self.flutterAPI.onCanPlay(currentTime: event.currentTime, completion: self.emptyCompletion)
        })
        
        canPlayThroughEventListener = theoplayer.addEventListener(type: PlayerEventTypes.CAN_PLAY_THROUGH, listener: {event in
            self.flutterAPI.onCanPlayThrough(currentTime: event.currentTime, completion: self.emptyCompletion)
        })
    }
    
    // TODO: remove force unwraps
    func removeListeners() {
        theoplayer.removeEventListener(type: PlayerEventTypes.SOURCE_CHANGE, listener: sourceChangeEventListener!)
        theoplayer.removeEventListener(type: PlayerEventTypes.PLAY, listener: playEventListener!)
        theoplayer.removeEventListener(type: PlayerEventTypes.PLAYING, listener: playingEventListener!)
        theoplayer.removeEventListener(type: PlayerEventTypes.PAUSE, listener: pauseEventListener!)
        theoplayer.removeEventListener(type: PlayerEventTypes.WAITING, listener: waitingEventListener!)
        theoplayer.removeEventListener(type: PlayerEventTypes.DURATION_CHANGE, listener: durationChangeEventListener!)
        theoplayer.removeEventListener(type: PlayerEventTypes.PROGRESS, listener: progressEventListener!)
        theoplayer.removeEventListener(type: PlayerEventTypes.TIME_UPDATE, listener: timeUpdateEventListener!)
        theoplayer.removeEventListener(type: PlayerEventTypes.RATE_CHANGE, listener: rateChangeEventListener!)
        theoplayer.removeEventListener(type: PlayerEventTypes.SEEKING, listener: seekingEventListener!)
        theoplayer.removeEventListener(type: PlayerEventTypes.SEEKED, listener: seekedEventListener!)
        theoplayer.removeEventListener(type: PlayerEventTypes.VOLUME_CHANGE, listener: volumeChangeEventListener!)
        theoplayer.removeEventListener(type: PlayerEventTypes.RESIZE, listener: resizeEventListener!)
        theoplayer.removeEventListener(type: PlayerEventTypes.ENDED, listener: endedEventListener!)
        theoplayer.removeEventListener(type: PlayerEventTypes.ERROR, listener: errorEventListener!)
        theoplayer.removeEventListener(type: PlayerEventTypes.DESTROY, listener: destroyEventListener!)
        theoplayer.removeEventListener(type: PlayerEventTypes.READY_STATE_CHANGE, listener: readyStateChangeEventListener!)
        theoplayer.removeEventListener(type: PlayerEventTypes.LOAD_START, listener: loadStartEventListener!)
        theoplayer.removeEventListener(type: PlayerEventTypes.LOADED_META_DATA, listener: loadedMetadataEventListener!)
        theoplayer.removeEventListener(type: PlayerEventTypes.LOADED_DATA, listener: loadedDataEventListener!)
        theoplayer.removeEventListener(type: PlayerEventTypes.CAN_PLAY, listener: canPlayEventListener!)
        theoplayer.removeEventListener(type: PlayerEventTypes.CAN_PLAY_THROUGH, listener: canPlayThroughEventListener!)
    }
    
}
