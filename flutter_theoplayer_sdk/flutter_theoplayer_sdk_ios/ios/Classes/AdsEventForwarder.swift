//
//  AdsEvenrForwarder.swift
//  Pods
//
//  Created by Dallos, Daniel on 08/01/2025.
//

import Foundation
import Flutter
import THEOplayerSDK

class AdsEventForwarder {
 
    private let ads: Ads
    private let flutterAPI: THEOplayerFlutterAdsAPI
    
    private var adBeginEventListener: EventListener?
    private var adEndEventListener: EventListener?
    private var adErrorEventListener: EventListener?
    private var adFirstQuartileEventListener: EventListener?
    private var adMidpointEventListener: EventListener?
    private var adThirdQuartileEventListener: EventListener?
    private var adLoadedEventListener: EventListener?
    private var adImpressionEventListener: EventListener?
    private var adSkipEventListener: EventListener?
    private var addAdEventListener: EventListener?

    private var adBreakBeginEventListener: EventListener?
    private var adBreakEndEventListener: EventListener?

    private var adTappedEventListener: EventListener?
    private var adClickedEventListener: EventListener?

    private var addAdBreakEventListener: EventListener?
    private var removeAdBreakEventListener: EventListener?
    private var adBreakChangeEventListeners: EventListener?
    
    //TODO: for SGAI
    //private var updateAdEventListener: EventListener?
    //private var updateAdBreakEventListener: EventListener?

    
    
    init(ads: Ads, flutterAPI: THEOplayerFlutterAdsAPI) {
        self.ads = ads
        self.flutterAPI = flutterAPI
    }
    
    func attachListeners() {
        
        let emptyCompletion: (Result<Void, FlutterError>) -> Void = {result in }

        adBeginEventListener = ads.addEventListener(type: AdsEventTypes.AD_BEGIN) { [weak self] event in
            guard let welf = self else { return }
            
            welf.flutterAPI.onAdBegin(
                ad: AdsTransformer.toFlutterAd(ad: event.ad),
                currentAds: welf.ads.currentAds.map({ ad in
                    AdsTransformer.toFlutterAd(ad: ad)! // parameter can not be null, so the return will be never null
                }),
                currentAdBreak: AdsTransformer.toFlutterAdBreak(adBreak: welf.ads.currentAdBreak),
                scheduledAds: welf.ads.scheduledAds.map({ ad in
                    AdsTransformer.toFlutterAd(ad: ad)! // parameter can not be null, so the return will be never null
                }),
                completion: emptyCompletion)
        }
        
        adEndEventListener = ads.addEventListener(type: AdsEventTypes.AD_END) { [weak self] event in
            guard let welf = self else { return }
            
            welf.flutterAPI.onAdEnd(
                ad: AdsTransformer.toFlutterAd(ad: event.ad),
                currentAds: welf.ads.currentAds.map({ ad in
                    AdsTransformer.toFlutterAd(ad: ad)! // parameter can not be null, so the return will be never null
                }),
                currentAdBreak: AdsTransformer.toFlutterAdBreak(adBreak: welf.ads.currentAdBreak),
                scheduledAds: welf.ads.scheduledAds.map({ ad in
                    AdsTransformer.toFlutterAd(ad: ad)! // parameter can not be null, so the return will be never null
                }),
                completion: emptyCompletion)
        }
        
        adErrorEventListener = ads.addEventListener(type: AdsEventTypes.AD_ERROR) { [weak self] event in
            guard let welf = self else { return }
            
            welf.flutterAPI.onAdError(
                ad: AdsTransformer.toFlutterAd(ad: event.ad),
                currentAds: welf.ads.currentAds.map({ ad in
                    AdsTransformer.toFlutterAd(ad: ad)! // parameter can not be null, so the return will be never null
                }),
                currentAdBreak: AdsTransformer.toFlutterAdBreak(adBreak: welf.ads.currentAdBreak),
                scheduledAds: welf.ads.scheduledAds.map({ ad in
                    AdsTransformer.toFlutterAd(ad: ad)! // parameter can not be null, so the return will be never null
                }),
                completion: emptyCompletion)
        }

        adFirstQuartileEventListener = ads.addEventListener(type: AdsEventTypes.AD_FIRST_QUARTILE) { [weak self] event in
            guard let welf = self else { return }
            
            welf.flutterAPI.onAdFirstQuartile(
                ad: AdsTransformer.toFlutterAd(ad: event.ad),
                currentAds: welf.ads.currentAds.map({ ad in
                    AdsTransformer.toFlutterAd(ad: ad)! // parameter can not be null, so the return will be never null
                }),
                currentAdBreak: AdsTransformer.toFlutterAdBreak(adBreak: welf.ads.currentAdBreak),
                scheduledAds: welf.ads.scheduledAds.map({ ad in
                    AdsTransformer.toFlutterAd(ad: ad)! // parameter can not be null, so the return will be never null
                }),
                completion: emptyCompletion)
        }
        
        adMidpointEventListener = ads.addEventListener(type: AdsEventTypes.AD_MIDPOINT) { [weak self] event in
            guard let welf = self else { return }
            
            welf.flutterAPI.onAdMidpoint(
                ad: AdsTransformer.toFlutterAd(ad: event.ad),
                currentAds: welf.ads.currentAds.map({ ad in
                    AdsTransformer.toFlutterAd(ad: ad)! // parameter can not be null, so the return will be never null
                }),
                currentAdBreak: AdsTransformer.toFlutterAdBreak(adBreak: welf.ads.currentAdBreak),
                scheduledAds: welf.ads.scheduledAds.map({ ad in
                    AdsTransformer.toFlutterAd(ad: ad)! // parameter can not be null, so the return will be never null
                }),
                completion: emptyCompletion)
        }

        adThirdQuartileEventListener = ads.addEventListener(type: AdsEventTypes.AD_THIRD_QUARTILE) { [weak self] event in
            guard let welf = self else { return }
            
            welf.flutterAPI.onAdThirdQuartile(
                ad: AdsTransformer.toFlutterAd(ad: event.ad),
                currentAds: welf.ads.currentAds.map({ ad in
                    AdsTransformer.toFlutterAd(ad: ad)! // parameter can not be null, so the return will be never null
                }),
                currentAdBreak: AdsTransformer.toFlutterAdBreak(adBreak: welf.ads.currentAdBreak),
                scheduledAds: welf.ads.scheduledAds.map({ ad in
                    AdsTransformer.toFlutterAd(ad: ad)! // parameter can not be null, so the return will be never null
                }),
                completion: emptyCompletion)
        }

        adLoadedEventListener = ads.addEventListener(type: AdsEventTypes.AD_LOADED) { [weak self] event in
            guard let welf = self else { return }
            
            welf.flutterAPI.onAdLoaded(
                ad: AdsTransformer.toFlutterAd(ad: event.ad),
                currentAds: welf.ads.currentAds.map({ ad in
                    AdsTransformer.toFlutterAd(ad: ad)! // parameter can not be null, so the return will be never null
                }),
                currentAdBreak: AdsTransformer.toFlutterAdBreak(adBreak: welf.ads.currentAdBreak),
                scheduledAds: welf.ads.scheduledAds.map({ ad in
                    AdsTransformer.toFlutterAd(ad: ad)! // parameter can not be null, so the return will be never null
                }),
                completion: emptyCompletion)
        }
        
        adImpressionEventListener = ads.addEventListener(type: AdsEventTypes.AD_IMPRESSION) { [weak self] event in
            guard let welf = self else { return }
            
            welf.flutterAPI.onAdImpression(
                ad: AdsTransformer.toFlutterAd(ad: event.ad),
                currentAds: welf.ads.currentAds.map({ ad in
                    AdsTransformer.toFlutterAd(ad: ad)! // parameter can not be null, so the return will be never null
                }),
                currentAdBreak: AdsTransformer.toFlutterAdBreak(adBreak: welf.ads.currentAdBreak),
                scheduledAds: welf.ads.scheduledAds.map({ ad in
                    AdsTransformer.toFlutterAd(ad: ad)! // parameter can not be null, so the return will be never null
                }),
                completion: emptyCompletion)
        }

        adSkipEventListener = ads.addEventListener(type: AdsEventTypes.AD_SKIP) { [weak self] event in
            guard let welf = self else { return }
            
            welf.flutterAPI.onAdSkip(
                ad: AdsTransformer.toFlutterAd(ad: event.ad),
                currentAds: welf.ads.currentAds.map({ ad in
                    AdsTransformer.toFlutterAd(ad: ad)! // parameter can not be null, so the return will be never null
                }),
                currentAdBreak: AdsTransformer.toFlutterAdBreak(adBreak: welf.ads.currentAdBreak),
                scheduledAds: welf.ads.scheduledAds.map({ ad in
                    AdsTransformer.toFlutterAd(ad: ad)! // parameter can not be null, so the return will be never null
                }),
                completion: emptyCompletion)
        }
        
        adTappedEventListener = ads.addEventListener(type: AdsEventTypes.AD_TAPPED) { [weak self] event in
            guard let welf = self else { return }
            
            welf.flutterAPI.onAdTapped(
                ad: AdsTransformer.toFlutterAd(ad: event.ad),
                currentAds: welf.ads.currentAds.map({ ad in
                    AdsTransformer.toFlutterAd(ad: ad)! // parameter can not be null, so the return will be never null
                }),
                currentAdBreak: AdsTransformer.toFlutterAdBreak(adBreak: welf.ads.currentAdBreak),
                scheduledAds: welf.ads.scheduledAds.map({ ad in
                    AdsTransformer.toFlutterAd(ad: ad)! // parameter can not be null, so the return will be never null
                }),
                completion: emptyCompletion)
        }

        adClickedEventListener = ads.addEventListener(type: AdsEventTypes.AD_CLICKED) { [weak self] event in
            guard let welf = self else { return }

            welf.flutterAPI.onAdClicked(
                ad: AdsTransformer.toFlutterAd(ad: event.ad),
                currentAds: welf.ads.currentAds.map({ ad in
                    AdsTransformer.toFlutterAd(ad: ad)! // parameter can not be null, so the return will be never null
                }),
                currentAdBreak: AdsTransformer.toFlutterAdBreak(adBreak: welf.ads.currentAdBreak),
                scheduledAds: welf.ads.scheduledAds.map({ ad in
                    AdsTransformer.toFlutterAd(ad: ad)! // parameter can not be null, so the return will be never null
                }),
                completion: emptyCompletion)
        }
        
        addAdEventListener = ads.addEventListener(type: AdsEventTypes.ADD_AD) { [weak self] event in
            guard let welf = self else { return }
            
            welf.flutterAPI.onAddAd(
                ad: AdsTransformer.toFlutterAd(ad: event.ad),
                currentAds: welf.ads.currentAds.map({ ad in
                    AdsTransformer.toFlutterAd(ad: ad)! // parameter can not be null, so the return will be never null
                }),
                currentAdBreak: AdsTransformer.toFlutterAdBreak(adBreak: welf.ads.currentAdBreak),
                scheduledAds: welf.ads.scheduledAds.map({ ad in
                    AdsTransformer.toFlutterAd(ad: ad)! // parameter can not be null, so the return will be never null
                }),
                completion: emptyCompletion)
        }
        
        adBreakBeginEventListener = ads.addEventListener(type: AdsEventTypes.AD_BREAK_BEGIN) { [weak self] event in
            guard let welf = self else { return }
            
            welf.flutterAPI.onAdBreakBegin(
                adbreak: AdsTransformer.toFlutterAdBreak(adBreak: event.ad)!,
                currentAds: welf.ads.currentAds.map({ ad in
                    AdsTransformer.toFlutterAd(ad: ad)! // parameter can not be null, so the return will be never null
                }),
                currentAdBreak: AdsTransformer.toFlutterAdBreak(adBreak: welf.ads.currentAdBreak),
                scheduledAds: welf.ads.scheduledAds.map({ ad in
                    AdsTransformer.toFlutterAd(ad: ad)! // parameter can not be null, so the return will be never null
                }),
                completion: emptyCompletion)
        }

        adBreakEndEventListener = ads.addEventListener(type: AdsEventTypes.AD_BREAK_END) { [weak self] event in
            guard let welf = self else { return }
            
            welf.flutterAPI.onAdBreakEnd(
                adbreak: AdsTransformer.toFlutterAdBreak(adBreak: event.ad)!,
                currentAds: welf.ads.currentAds.map({ ad in
                    AdsTransformer.toFlutterAd(ad: ad)! // parameter can not be null, so the return will be never null
                }),
                currentAdBreak: AdsTransformer.toFlutterAdBreak(adBreak: welf.ads.currentAdBreak),
                scheduledAds: welf.ads.scheduledAds.map({ ad in
                    AdsTransformer.toFlutterAd(ad: ad)! // parameter can not be null, so the return will be never null
                }),
                completion: emptyCompletion)
        }
        
        addAdBreakEventListener = ads.addEventListener(type: AdsEventTypes.ADD_AD_BREAK) { [weak self] event in
            guard let welf = self else { return }
            
            welf.flutterAPI.onAddAdBreak(
                adbreak: AdsTransformer.toFlutterAdBreak(adBreak: event.ad)!,
                currentAds: welf.ads.currentAds.map({ ad in
                    AdsTransformer.toFlutterAd(ad: ad)! // parameter can not be null, so the return will be never null
                }),
                currentAdBreak: AdsTransformer.toFlutterAdBreak(adBreak: welf.ads.currentAdBreak),
                scheduledAds: welf.ads.scheduledAds.map({ ad in
                    AdsTransformer.toFlutterAd(ad: ad)! // parameter can not be null, so the return will be never null
                }),
                completion: emptyCompletion)
        }
        
        removeAdBreakEventListener = ads.addEventListener(type: AdsEventTypes.REMOVE_AD_BREAK) { [weak self] event in
            guard let welf = self else { return }
            
            welf.flutterAPI.onRemoveAdBreak(
                adbreak: AdsTransformer.toFlutterAdBreak(adBreak: event.ad)!,
                currentAds: welf.ads.currentAds.map({ ad in
                    AdsTransformer.toFlutterAd(ad: ad)! // parameter can not be null, so the return will be never null
                }),
                currentAdBreak: AdsTransformer.toFlutterAdBreak(adBreak: welf.ads.currentAdBreak),
                scheduledAds: welf.ads.scheduledAds.map({ ad in
                    AdsTransformer.toFlutterAd(ad: ad)! // parameter can not be null, so the return will be never null
                }),
                completion: emptyCompletion)
        }

        adBreakChangeEventListeners = ads.addEventListener(type: AdsEventTypes.AD_BREAK_CHANGE) { [weak self] event in
            guard let welf = self else { return }
            
            welf.flutterAPI.onAdBreakChange(
                adbreak: AdsTransformer.toFlutterAdBreak(adBreak: event.ad)!,
                currentAds: welf.ads.currentAds.map({ ad in
                    AdsTransformer.toFlutterAd(ad: ad)! // parameter can not be null, so the return will be never null
                }),
                currentAdBreak: AdsTransformer.toFlutterAdBreak(adBreak: welf.ads.currentAdBreak),
                scheduledAds: welf.ads.scheduledAds.map({ ad in
                    AdsTransformer.toFlutterAd(ad: ad)! // parameter can not be null, so the return will be never null
                }),
                completion: emptyCompletion)
        }

    }
        
    func detachListeners(){
        ads.removeEventListener(type: AdsEventTypes.AD_BEGIN, listener: adBeginEventListener!)
        ads.removeEventListener(type: AdsEventTypes.AD_END, listener: adEndEventListener!)
        ads.removeEventListener(type: AdsEventTypes.AD_ERROR, listener: adErrorEventListener!)
        ads.removeEventListener(type: AdsEventTypes.AD_FIRST_QUARTILE, listener: adFirstQuartileEventListener!)
        ads.removeEventListener(type: AdsEventTypes.AD_MIDPOINT, listener: adMidpointEventListener!)
        ads.removeEventListener(type: AdsEventTypes.AD_THIRD_QUARTILE, listener: adThirdQuartileEventListener!)
        ads.removeEventListener(type: AdsEventTypes.AD_LOADED, listener: adLoadedEventListener!)
        ads.removeEventListener(type: AdsEventTypes.AD_IMPRESSION, listener: adImpressionEventListener!)
        ads.removeEventListener(type: AdsEventTypes.AD_SKIP, listener: adSkipEventListener!)
        ads.removeEventListener(type: AdsEventTypes.AD_BREAK_BEGIN, listener: adBreakBeginEventListener!)
        ads.removeEventListener(type: AdsEventTypes.AD_BREAK_END, listener: adBreakEndEventListener!)
        ads.removeEventListener(type: AdsEventTypes.AD_TAPPED, listener: adTappedEventListener!)
        ads.removeEventListener(type: AdsEventTypes.AD_CLICKED, listener: adClickedEventListener!)
        ads.removeEventListener(type: AdsEventTypes.ADD_AD_BREAK, listener: addAdBreakEventListener!)
        ads.removeEventListener(type: AdsEventTypes.REMOVE_AD_BREAK, listener: removeAdBreakEventListener!)
    }
    
}
