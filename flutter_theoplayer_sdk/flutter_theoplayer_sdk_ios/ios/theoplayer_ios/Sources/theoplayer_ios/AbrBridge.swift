//
//  AbrBridge.swift
//
//  Bridge between Flutter Pigeon API and iOS ABRConfiguration.
//

import Foundation
import Flutter
import THEOplayerSDK

class AbrBridge: THEOplayerNativeAbrAPI {

    private let pigeonMessenger: PigeonBinaryMessengerWrapper
    private let theoplayer: THEOplayer

    init(theoplayer: THEOplayer, pigeonMessenger: PigeonBinaryMessengerWrapper) {
        self.theoplayer = theoplayer
        self.pigeonMessenger = pigeonMessenger
        THEOplayerNativeAbrAPISetup.setUp(binaryMessenger: pigeonMessenger, api: self)
    }

    func dispose() {
        THEOplayerNativeAbrAPISetup.setUp(binaryMessenger: pigeonMessenger, api: nil)
    }

    // MARK: - THEOplayerNativeAbrAPI

    func getAbrStrategy() throws -> AbrStrategyConfigurationPigeon {
        let native = theoplayer.abr.strategy
        return AbrStrategyConfigurationPigeon(
            type: toPigeonType(native.type),
            metadata: native.metadata.map { meta in
                AbrStrategyMetadataPigeon(bitrate: meta.bitrate.map { Int64($0) })
            }
        )
    }

    func setAbrStrategy(config: AbrStrategyConfigurationPigeon) throws {
        let nativeType = toNativeType(config.type)
        var nativeMetadata: ABRMetadata? = nil
        if let bitrate = config.metadata?.bitrate {
            nativeMetadata = ABRMetadata(bitrate: Double(bitrate))
        }
        theoplayer.abr.strategy = ABRStrategyConfiguration(type: nativeType, metadata: nativeMetadata)
    }

    func getTargetBuffer() throws -> Double {
        return theoplayer.abr.targetBuffer ?? 20.0
    }

    func setTargetBuffer(value: Double) throws {
        theoplayer.abr.targetBuffer = value
    }

    func getPreferredPeakBitRate() throws -> Double {
        return theoplayer.abr.preferredPeakBitRate ?? 0.0
    }

    func setPreferredPeakBitRate(value: Double) throws {
        theoplayer.abr.preferredPeakBitRate = value
    }

    // MARK: - Mapping helpers

    private func toPigeonType(_ type: ABRStrategyType) -> AbrStrategyTypePigeon {
        switch type {
        case .performance: return .performance
        case .quality: return .quality
        case .bandwidth: return .bandwidth
        }
    }

    private func toNativeType(_ type: AbrStrategyTypePigeon) -> ABRStrategyType {
        switch type {
        case .performance: return .performance
        case .quality: return .quality
        case .bandwidth: return .bandwidth
        }
    }
}
