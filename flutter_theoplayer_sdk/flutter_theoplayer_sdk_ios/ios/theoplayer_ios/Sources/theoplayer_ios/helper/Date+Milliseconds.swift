//
//  Date+Milliseconds.swift
//  flutter_theoplayer_sdk_ios
//

import Foundation

// The pigeon wire contract expresses timestamps in milliseconds since epoch, matching Android and web.
extension Date {

    var millisecondsSinceEpoch: Int64 {
        Int64((timeIntervalSince1970 * 1000).rounded())
    }

    init(millisecondsSinceEpoch: Int64) {
        self.init(timeIntervalSince1970: TimeInterval(millisecondsSinceEpoch) / 1000)
    }
}
