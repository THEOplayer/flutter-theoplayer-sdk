import Flutter
import THEOplayerSDK
import THEOplayerTHEOliveIntegration
import UIKit
import XCTest

@testable import theoplayer_ios

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

    guard let transformed = SourceTransformer.toTypedSource(typedSource: source) else {
      XCTFail("Expected a typed source")
      return
    }
    let roundTrip = SourceTransformer.toFlutterTypedSource(typedSource: transformed)
    let sourceDescription = THEOplayerSDK.SourceDescription(sources: [transformed])
    let getterPayload = SourceTransformer.toFlutterSourceDescription(source: sourceDescription)

    XCTAssertEqual(transformed.latencyConfiguration?.targetOffset, 3.0)
    XCTAssertEqual(roundTrip?.latencyConfiguration?.targetOffset, 3.0)
    XCTAssertEqual(getterPayload?.sources.compactMap { $0 }.first?.latencyConfiguration?.targetOffset, 3.0)
  }

  func testUnconfiguredSourceHasNoLatencyConfiguration() {
    let source = TypedSourcePigeon(src: "https://example.com/live.m3u8")
    let transformed = SourceTransformer.toTypedSource(typedSource: source)

    XCTAssertNil(SourceTransformer.toFlutterTypedSource(typedSource: transformed)?.latencyConfiguration)
  }

  func testMapsTheoLiveLatencyTarget() {
    let source = TypedSourcePigeon(
      src: "distribution-id",
      integration: .theolive,
      latencyConfiguration: SourceLatencyConfiguration(targetOffset: 2.0)
    )

    let transformed = SourceTransformer.toTypedSource(typedSource: source) as? TheoLiveSource
    let roundTrip = SourceTransformer.toFlutterTypedSource(typedSource: transformed)

    XCTAssertEqual(transformed?.targetLatency, 2.0)
    XCTAssertEqual(roundTrip?.latencyConfiguration?.targetOffset, 2.0)
    XCTAssertEqual(roundTrip?.integration, .theolive)
  }

}
