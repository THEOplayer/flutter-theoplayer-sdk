import Flutter
import THEOplayerTHEOliveIntegration
import UIKit
import XCTest

@testable import theoplayer

// This demonstrates a simple unit test of the Swift portion of this plugin's implementation.
//
// See https://developer.apple.com/documentation/xctest for more information about using XCTest.

class RunnerTests: XCTestCase {

  func testGetPlatformVersion() {
    let plugin = TheoplayerPlugin()

    let call = FlutterMethodCall(methodName: "getPlatformVersion", arguments: [])

    let resultExpectation = expectation(description: "result block must be called.")
    plugin.handle(call) { result in
      XCTAssertEqual(result as! String, "iOS " + UIDevice.current.systemVersion)
      resultExpectation.fulfill()
    }
    waitForExpectations(timeout: 1)
  }

  func testMapsSourceLatencyTarget() {
    let source = TypedSourcePigeon(
      src: "https://example.com/live.m3u8",
      latencyConfiguration: SourceLatencyConfiguration(targetOffset: 3.0)
    )

    let transformed = SourceTransformer.toTypedSource(typedSource: source)

    XCTAssertNotNil(transformed?.latencyConfiguration)
  }

  func testMapsTheoLiveLatencyTarget() {
    let source = TypedSourcePigeon(
      src: "distribution-id",
      integration: .theolive,
      latencyConfiguration: SourceLatencyConfiguration(targetOffset: 2.0)
    )

    let transformed = SourceTransformer.toTypedSource(typedSource: source) as? TheoLiveSource

    XCTAssertEqual(transformed?.targetLatency, 2.0)
  }

}
