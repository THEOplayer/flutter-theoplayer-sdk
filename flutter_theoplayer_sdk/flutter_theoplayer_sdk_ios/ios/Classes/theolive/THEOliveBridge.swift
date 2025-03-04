//
//  THEOliveBridge.swift
//
//  Created by Dallos, Daniel on 04/03/2025.
//


import Foundation
import THEOplayerSDK
import Flutter
import THEOplayerTHEOliveIntegration

class THEOliveBridge: THEOplayerNativeTHEOliveAPI {
    
    private let theoLive: THEOlive
    private let pigeonMessenger: PigeonBinaryMessengerWrapper
    private let flutterTHEOliveAPI: THEOplayerFlutterTHEOliveAPI
    
    private var publicationLoadStartListener: EventListener?
    private var publicationLoadedListener: EventListener?
    private var publicationOfflineListener: EventListener?
    private var intentToFallbackListener: EventListener?
    
    private let emptyCompletion: (Result<Void, FlutterError>) -> Void = {result in }
    
    init(theoLive: THEOlive, pigeonMessenger: PigeonBinaryMessengerWrapper) {
        self.theoLive = theoLive
        self.pigeonMessenger = pigeonMessenger
        self.flutterTHEOliveAPI = THEOplayerFlutterTHEOliveAPI(binaryMessenger: pigeonMessenger)
        THEOplayerNativeTHEOliveAPISetup.setUp(binaryMessenger: pigeonMessenger, api: self)
    }
    
    func attachListeners() {
        publicationLoadStartListener = theoLive.addEventListener(type: THEOliveEventTypes.PUBLICATION_LOAD_START, listener: { [weak self] event in
            guard let welf = self else { return }
            welf.flutterTHEOliveAPI.onPublicationLoadStartEvent(channelId: event.publicationId, completion: welf.emptyCompletion)
        })
        
        publicationLoadedListener = theoLive.addEventListener(type: THEOliveEventTypes.PUBLICATION_LOADED, listener: { [weak self] event in
            guard let welf = self else { return }
            welf.flutterTHEOliveAPI.onPublicationLoadedEvent(channelId: event.publicationId, completion: welf.emptyCompletion)
        })
        
        publicationOfflineListener = theoLive.addEventListener(type: THEOliveEventTypes.PUBLICATION_OFFLINE, listener: { [weak self] event in
            guard let welf = self else { return }
            welf.flutterTHEOliveAPI.onPublicationOfflineEvent(channelId: event.publicationId, completion: welf.emptyCompletion)
        })
        
        intentToFallbackListener = theoLive.addEventListener(type: THEOliveEventTypes.INTENT_TO_FALLBACK, listener: { [weak self] event in
            guard let welf = self else { return }
            welf.flutterTHEOliveAPI.onIntentToFallbackEvent(completion: welf.emptyCompletion)
        })
    }
    
    func removeListeners() {
        // TODO: remove force unwraps
        theoLive.removeEventListener(type: THEOliveEventTypes.PUBLICATION_LOAD_START, listener: publicationLoadStartListener!)
        theoLive.removeEventListener(type: THEOliveEventTypes.PUBLICATION_LOADED, listener: publicationLoadedListener!)
        theoLive.removeEventListener(type: THEOliveEventTypes.PUBLICATION_OFFLINE, listener: publicationOfflineListener!)
        theoLive.removeEventListener(type: THEOliveEventTypes.INTENT_TO_FALLBACK, listener: intentToFallbackListener!)
    }
    
    //MARK: THEOplayerNativeTHEOliveAPI API
    
    func goLive() throws {
        theoLive.goLive()
    }
    
    func preloadChannels(channelIds: [String]?) throws {
        if let channelIds = channelIds {
            theoLive.preloadPublications(publicationIds: channelIds)
        }
    }
}
