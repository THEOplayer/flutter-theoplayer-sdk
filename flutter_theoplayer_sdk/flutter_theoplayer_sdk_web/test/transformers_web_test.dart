@TestOn('browser')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:theoplayer_platform_interface/pigeon/apis.g.dart' as PlatformInterface;
import 'package:theoplayer_web/theoplayer_api_web.dart' as Web;
import 'package:theoplayer_web/theoplayer_js_helpers_web.dart';
import 'package:theoplayer_web/transformers_web.dart';

void main() {
  test('maps THEOlive integration and latency configuration from Web', () {
    final source = Web.TypedSource(
      src: 'distribution-id',
      integration: 'theolive',
      lowLatency: true,
      latencyConfiguration: Web.SourceLatencyConfiguration(
        targetOffset: 3.0,
        minimumOffset: 2.0,
        maximumOffset: 4.0,
        forceSeekOffset: 10.0,
        minimumPlaybackRate: 0.95,
        maximumPlaybackRate: 1.05,
      ),
    );

    final transformed = toFlutterTypedSource(source)!;

    expect(transformed.integration, PlatformInterface.SourceIntegrationId.theolive);
    expect(transformed.lowLatency, isTrue);
    expect(transformed.latencyConfiguration?.targetOffset, 3.0);
    expect(transformed.latencyConfiguration?.minimumOffset, 2.0);
    expect(transformed.latencyConfiguration?.maximumOffset, 4.0);
    expect(transformed.latencyConfiguration?.forceSeekOffset, 10.0);
    expect(transformed.latencyConfiguration?.minimumPlaybackRate, 0.95);
    expect(transformed.latencyConfiguration?.maximumPlaybackRate, 1.05);
  });

  test('maps THEOlive integration and latency configuration to Web', () {
    final description = toSourceDescription(PlatformInterface.SourceDescription(sources: [
      PlatformInterface.TypedSourcePigeon(
        src: 'distribution-id',
        integration: PlatformInterface.SourceIntegrationId.theolive,
        lowLatency: true,
        latencyConfiguration: PlatformInterface.SourceLatencyConfiguration(targetOffset: 2.0),
      ),
    ]));

    final transformed = description.sources.getItem(0)! as Web.TypedSource;

    expect(transformed.integration, 'theolive');
    expect(transformed.lowLatency, isTrue);
    expect(transformed.latencyConfiguration?.targetOffset, 2.0);
  });

  test('ignores unknown Web source integrations', () {
    final source = Web.TypedSource(src: 'https://example.com/live.m3u8', integration: 'unknown');

    expect(toFlutterTypedSource(source)?.integration, isNull);
  });
}
