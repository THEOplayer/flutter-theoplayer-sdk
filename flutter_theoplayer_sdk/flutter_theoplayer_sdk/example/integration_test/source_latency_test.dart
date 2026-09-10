import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:theoplayer/theoplayer.dart';

import '../integration_test_app/test_app.dart';

const _testSource = 'https://cdn.theoplayer.com/video/big_buck_bunny/big_buck_bunny.m3u8';
const _targetOffset = 6.0;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test source latency configuration forwarding', (WidgetTester tester) async {
    final app = TestApp();
    await tester.pumpWidget(app);

    final playerView = find.byKey(const Key('testChromelessPlayer'));
    await tester.ensureVisible(playerView);
    final player = (tester.firstElement(playerView).widget as ChromelessPlayerView).player;
    await tester.pumpAndSettle();
    await app.waitForPlayerReady();

    player.source = SourceDescription(sources: [
      TypedSource(
        src: _testSource,
        type: 'application/x-mpegurl',
        lowLatency: true,
        latencyConfiguration: SourceLatencyConfiguration(
          targetOffset: _targetOffset,
          minimumOffset: 4.0,
          maximumOffset: 8.0,
          forceSeekOffset: 18.0,
          minimumPlaybackRate: 0.95,
          maximumPlaybackRate: 1.05,
        ),
      ),
    ]);

    for (var second = 0; second < 10 && player.source == null; second++) {
      await tester.pump(const Duration(seconds: 1));
    }

    final currentSource = player.source?.sources.first;
    expect(currentSource?.src, _testSource);

    if (kIsWeb || defaultTargetPlatform == TargetPlatform.android) {
      final latencyConfiguration = currentSource?.latencyConfiguration;
      expect(latencyConfiguration?.targetOffset, _targetOffset);
      expect(latencyConfiguration?.minimumOffset, 4.0);
      expect(latencyConfiguration?.maximumOffset, 8.0);
      expect(latencyConfiguration?.forceSeekOffset, 18.0);
      expect(latencyConfiguration?.minimumPlaybackRate, 0.95);
      expect(latencyConfiguration?.maximumPlaybackRate, 1.05);
      if (kIsWeb) {
        expect(currentSource?.lowLatency, isTrue);
      }
    }
  });
}
