//
//  CueTransformer.swift
//  flutter_theoplayer_sdk_ios
//

import Foundation
import THEOplayerSDK

struct CueTransformer {
    private struct RawCustomAttribute: Decodable {
        let value: String
        let type: String
    }

    private struct RawCustomAttributes: Decodable {
        let rawAttributes: [String: RawCustomAttribute]
    }

    /// Serializes DateRangeCue custom attributes into a flat JSON object.
    /// String attributes stay strings, numeric attributes become JSON numbers
    /// and binary attributes are represented as base64-encoded strings.
    static func toCustomAttributesJson(_ customAttributes: CustomAttributes) -> String? {
        guard let encoded = try? JSONEncoder().encode(customAttributes),
              let decoded = try? JSONDecoder().decode(RawCustomAttributes.self, from: encoded) else {
            return nil
        }

        var attributes: [String: Any] = [:]
        for (key, attribute) in decoded.rawAttributes {
            switch attribute.type {
            case "daterange-ca-type_number":
                attributes[key] = Double(attribute.value) ?? attribute.value
            case "daterange-ca-type_arraybuffer":
                // Re-encode to strip the line feeds the native SDK inserts into its base64 values.
                if let data = Data(base64Encoded: attribute.value, options: .ignoreUnknownCharacters) {
                    attributes[key] = data.base64EncodedString()
                } else {
                    attributes[key] = attribute.value
                }
            default:
                attributes[key] = attribute.value
            }
        }

        guard let json = try? JSONSerialization.data(withJSONObject: attributes) else {
            return nil
        }
        return String(data: json, encoding: .utf8)
    }
}
