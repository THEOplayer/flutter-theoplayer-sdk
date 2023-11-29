//
//  SourceTransformer.swift
//  flutter_theoplayer_sdk_ios
//
//  Created by Hovig on 16/10/2023.
//

import Foundation
import THEOplayerSDK

struct SourceTransformer {
    static func toFlutterSourceDescription(source: THEOplayerSDK.SourceDescription?) -> SourceDescription? {
        guard let source = source else {
            return nil
        }
        
        return SourceDescription(
            sources: source.sources.map({ typedSource in
                toFlutterTypedSource(typedSource: typedSource)
            })
        )
    }
    
    static func toFlutterTypedSource(typedSource: THEOplayerSDK.TypedSource?) -> TypedSource? {
        guard let typedSource = typedSource else {
            return nil
        }
        
        var flutterDRMConfiguration: DRMConfiguration?
        if let drmConfiguration = typedSource.drm {
            flutterDRMConfiguration = toFlutterDRMConfiguration(drmConfiguration: drmConfiguration)
        }
        
        return TypedSource(src: typedSource.src.absoluteString, drm: flutterDRMConfiguration)
    }
    
    
    static func toFlutterDRMConfiguration(drmConfiguration: THEOplayerSDK.DRMConfiguration) -> DRMConfiguration {
        var flutterFairplayConfig: FairPlayDRMConfiguration?
        if let fairPlayDRMConfiguration = drmConfiguration as? THEOplayerSDK.FairPlayDRMConfiguration {
            flutterFairplayConfig = FairPlayDRMConfiguration(
                licenseAcquisitionURL: fairPlayDRMConfiguration.fairplay.licenseAcquisitionURL?.absoluteString ?? "",
                certificateURL: fairPlayDRMConfiguration.fairplay.certificateURL?.absoluteString ?? "",
                headers: fairPlayDRMConfiguration.fairplay.headers)
        }

        var flutterWidevineConfig: WidevineDRMConfiguration?
        if let widevineDRMConfiguration = drmConfiguration as? THEOplayerSDK.WidevineDRMConfiguration {
            flutterWidevineConfig = WidevineDRMConfiguration(
                licenseAcquisitionURL: widevineDRMConfiguration.widevine.licenseAcquisitionURL?.absoluteString ?? "",
                headers: widevineDRMConfiguration.widevine.headers)
        }
        
        
        var convertedIntegrationParameters: [String: String]? = nil
        if let integrationParameters = drmConfiguration.integrationParameters as? [String:String] {
            convertedIntegrationParameters = integrationParameters
        } else {
            print("Failed to convert integrationParameters!: ", drmConfiguration.integrationParameters);
        }
        
        return DRMConfiguration(widevine: flutterWidevineConfig, fairplay: flutterFairplayConfig, customIntegrationId: drmConfiguration.customIntegrationId, integrationParameters: convertedIntegrationParameters)
    }
    
    
    static func toSourceDescription(source: SourceDescription?) -> THEOplayerSDK.SourceDescription? {
        guard let source = source else {
            return nil
        }
        
        return THEOplayerSDK.SourceDescription(
            sources: source.sources
                .map({ typedSource in
                    toTypedSource(typedSource: typedSource)
                })
                .compactMap({ $0 })
        )
    }
    
    static func toTypedSource(typedSource: TypedSource?) -> THEOplayerSDK.TypedSource? {
        guard let typedSource = typedSource else {
            return nil
        }
        
        var drm = toDRMConfiguration(flutterDRMConfiguration: typedSource.drm)
        
        return THEOplayerSDK.TypedSource(
            src: typedSource.src,
            type: "",
            drm: drm)
    }
    
    static func toDRMConfiguration(flutterDRMConfiguration: DRMConfiguration?) -> THEOplayerSDK.DRMConfiguration? {
        guard let flutterDRMConfiguration = flutterDRMConfiguration else {
            return nil
        }
        
        if let widevine = flutterDRMConfiguration.widevine {
            var headers: Array<[String : String]> = []
            widevine.headers?.forEach({ header in
                if let key = header.key,
                   let value = header.value {
                    headers.append([key: value])
                }
            })
            
            if let customIntegration = flutterDRMConfiguration.customIntegrationId {
                var integrationParameters: [String : String] = [:]
                flutterDRMConfiguration.integrationParameters?.forEach({ header in
                    if let key = header.key,
                       let value = header.value {
                        integrationParameters[key] = value
                    }
                })
                
                return THEOplayerSDK.WidevineDRMConfiguration(
                    customIntegrationId: customIntegration,
                    licenseAcquisitionURL: widevine.licenseAcquisitionURL,
                    integrationParameters: integrationParameters
                )
            } else {
                return THEOplayerSDK.WidevineDRMConfiguration(
                    licenseAcquisitionURL: widevine.licenseAcquisitionURL,
                    headers: headers
                )
            }

        }
        
        if let fairplay = flutterDRMConfiguration.fairplay {
            var headers: Array<[String : String]> = []
            fairplay.headers?.forEach({ header in
                if let key = header.key,
                   let value = header.value {
                    headers.append([key: value])
                }
            })
            
            if let customIntegration = flutterDRMConfiguration.customIntegrationId {
                var integrationParameters: [String : String] = [:]
                flutterDRMConfiguration.integrationParameters?.forEach({ header in
                    if let key = header.key,
                       let value = header.value {
                        integrationParameters[key] = value
                    }
                })
                return THEOplayerSDK.FairPlayDRMConfiguration(
                    customIntegrationId: customIntegration,
                    licenseAcquisitionURL: fairplay.licenseAcquisitionURL,
                    certificateURL: fairplay.certificateURL,
                    headers: headers,
                    integrationParameters: integrationParameters
                )
            } else {
                return THEOplayerSDK.FairPlayDRMConfiguration(
                    licenseAcquisitionURL: fairplay.licenseAcquisitionURL,
                    certificateURL: fairplay.certificateURL,
                    headers: headers
                )
            }
        }
        
        return nil
        
    }
}
