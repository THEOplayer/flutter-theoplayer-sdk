//
//  DebugFlagsBridge.swift
//
//  Bridge between Flutter Pigeon API and iOS DebugConfig.
//

import Foundation
import Flutter
@_spi(Debug) import THEOplayerTHEOliveIntegration

class DebugFlagsBridge: THEOplayerNativeDebugFlagsAPI {

    private let pigeonMessenger: PigeonBinaryMessengerWrapper

    init(pigeonMessenger: PigeonBinaryMessengerWrapper) {
        self.pigeonMessenger = pigeonMessenger
        THEOplayerNativeDebugFlagsAPISetup.setUp(binaryMessenger: pigeonMessenger, api: self)
    }

    func dispose() {
        THEOplayerNativeDebugFlagsAPISetup.setUp(binaryMessenger: pigeonMessenger, api: nil)
    }

    // MARK: - THEOplayerNativeDebugFlagsAPI

    func getAvailableFlags() throws -> [DebugFlagPigeon] {
        return DebugConfig.availableFlags.map { flag in
            DebugFlagPigeon(
                key: flag.key,
                description: flag.description,
                defaultValue: flag.defaultValue,
                isEnabled: DebugConfig.isEnabled(flag.key) ?? flag.defaultValue
            )
        }
    }

    func enableFlag(key: String) throws {
        DebugConfig.enable(key)
    }

    func disableFlag(key: String) throws {
        DebugConfig.disable(key)
    }

    func enableAll() throws {
        DebugConfig.enableAll()
    }

    func disableAll() throws {
        DebugConfig.disableAll()
    }

    func resetAll() throws {
        DebugConfig.resetAll()
    }

    func enableFileLogging() throws {
        DebugConfig.enableFileLogging()
    }
}
