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
    
    private var distributionLoadStartListener: EventListener?
    private var endpointLoadedListener: EventListener?
    private var distributionOfflineListener: EventListener?
    private var intentToFallbackListener: EventListener?
    
    //experimental
    private var seekingEventListener: EventListener?
    private var seekedEventListener: EventListener?
    
    private let emptyCompletion: (Result<Void, FlutterError>) -> Void = {result in }
    
    init(theoLive: THEOlive, pigeonMessenger: PigeonBinaryMessengerWrapper) {
        self.theoLive = theoLive
        self.pigeonMessenger = pigeonMessenger
        self.flutterTHEOliveAPI = THEOplayerFlutterTHEOliveAPI(binaryMessenger: pigeonMessenger)
        THEOplayerNativeTHEOliveAPISetup.setUp(binaryMessenger: pigeonMessenger, api: self)
    }
    
    func attachListeners() {
        distributionLoadStartListener = theoLive.addEventListener(type: THEOliveEventTypes.DISTRIBUTION_LOAD_START, listener: { [weak self] event in
            guard let welf = self else { return }
            welf.flutterTHEOliveAPI.onDistributionLoadStartEvent(distributionId: event.distributionId, completion: welf.emptyCompletion)
        })
        
        endpointLoadedListener = theoLive.addEventListener(type: THEOliveEventTypes.ENDPOINT_LOADED, listener: { [weak self] event in
            guard let welf = self else { return }
            let endpoint = event.endpoint
            welf.flutterTHEOliveAPI.onEndpointLoadedEvent(
                endpoint: Endpoint(
                    hespSrc: endpoint.hespSrc,
                    hlsSrc: endpoint.hlsSrc,
                    cdn: endpoint.cdn,
                    adSrc: endpoint.adSrc,
                    weight: endpoint.weight,
                    priority: Int64(endpoint.priority)
                ),
                completion: welf.emptyCompletion
            )
        })
        
        distributionOfflineListener = theoLive.addEventListener(type: THEOliveEventTypes.DISTRIBUTION_OFFLINE, listener: { [weak self] event in
            guard let welf = self else { return }
            welf.flutterTHEOliveAPI.onDistributionOfflineEvent(distributionId: event.distributionId, completion: welf.emptyCompletion)
        })
        
        intentToFallbackListener = theoLive.addEventListener(type: THEOliveEventTypes.INTENT_TO_FALLBACK, listener: { [weak self] event in
            guard let welf = self else { return }
            welf.flutterTHEOliveAPI.onIntentToFallbackEvent(completion: welf.emptyCompletion)
        })
        
        seekingEventListener = theoLive.addEventListener(type: PlayerEventTypes.SEEKING, listener: { [weak self] event in
            guard let welf = self else { return }
            //current time is not used
            welf.flutterTHEOliveAPI.onSeeking(currentTime: 0, completion: welf.emptyCompletion)
        })
        
        seekedEventListener = theoLive.addEventListener(type: PlayerEventTypes.SEEKED, listener: { [weak self] event in
            guard let welf = self else { return }
            //current time is not used
            welf.flutterTHEOliveAPI.onSeeked(currentTime: 0, completion: welf.emptyCompletion)
        })
    }
    
    func removeListeners() {
        // TODO: remove force unwraps
        theoLive.removeEventListener(type: THEOliveEventTypes.DISTRIBUTION_LOAD_START, listener: distributionLoadStartListener!)
        theoLive.removeEventListener(type: THEOliveEventTypes.ENDPOINT_LOADED, listener: endpointLoadedListener!)
        theoLive.removeEventListener(type: THEOliveEventTypes.DISTRIBUTION_OFFLINE, listener: distributionOfflineListener!)
        theoLive.removeEventListener(type: THEOliveEventTypes.INTENT_TO_FALLBACK, listener: intentToFallbackListener!)
        theoLive.removeEventListener(type: PlayerEventTypes.SEEKING, listener: seekingEventListener!)
        theoLive.removeEventListener(type: PlayerEventTypes.SEEKED, listener: seekedEventListener!)
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
