//
//  AdsTransformer.swift
//  theoplayer_ios
//
//  Created by Dallos, Daniel on 15/01/2025.
//

import Foundation
import THEOplayerSDK

struct AdsTransformer {

    static func toFlutterAd(ad: THEOplayerSDK.Ad?) -> Ad? {
        guard let ad = ad else {
            return nil
        }
        
        return Ad(
            id: ad.id ?? "",
            companions: ad.companions.map({ companion in
                toFlutterCompanionAd(companionAd: companion)
            }),
            skipOffset: Int64(ad.skipOffset ?? 0),
            integration: toFlutterIntegrationKind(integration: ad.integration))
    }

    static func toFlutterAdBreak(adBreak: THEOplayerSDK.AdBreak?) -> AdBreak? {
        guard let adBreak = adBreak else {
            return nil
        }
        
        return AdBreak(
            ads: adBreak.ads.map({ ad in
                toFlutterAd(ad: ad)
            }),
            maxDuration: Int64(adBreak.maxDuration),
            maxRemainingDuration: Int64(adBreak.maxRemainingDuration),
            timeOffset: Int64(adBreak.timeOffset),
            integration: toFlutterIntegrationKind(integration: adBreak.integration)
        )
    }

    static func toFlutterIntegrationKind(integration: THEOplayerSDK.AdIntegrationKind) -> IntegrationKind {
        switch integration {
        case .theoads:
            return .theoads
        case .google_ima:
            return .googleIma
        case .google_dai:
            return .googleDai
        //case .mediaTailor:
        //    return .mediaTailor
        case .custom:
            return .custom
        @unknown default:
            fatalError("Unhandled AdIntegrationKind: \(integration)")
        }
    }

    static func toFlutterCompanionAd(companionAd: THEOplayerSDK.CompanionAd) -> CompanionAd {
        return CompanionAd(adSlotId: companionAd.adSlotId ?? "", altText: companionAd.altText ?? "", clickThrough: companionAd.clickThrough ?? "", height: Int64(companionAd.height), width: Int64(companionAd.width), resourceURI: companionAd.resourceURI!, type: companionAd.type)
    }
}
