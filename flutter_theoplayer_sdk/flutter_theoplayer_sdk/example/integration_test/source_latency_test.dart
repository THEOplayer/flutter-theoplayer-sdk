import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:theoplayer/theoplayer.dart';

import '../integration_test_app/test_app.dart';

const _liveStream = 'https://ll-hls-test.cdn-apple.com/llhls4/ll-hls-test-04/multi.m3u8';
const _targetOffset = 6.0;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test source latency configuration', (WidgetTester tester) async {
    final app = TestApp();
    await tester.pumpWidget(app);

    final playerView = find.byKey(const Key('testChromelessPlayer'));
    await tester.ensureVisible(playerView);
    final player = (tester.firstElement(playerView).widget as ChromelessPlayerView).player;
    await tester.pumpAndSettle();
    await app.waitForPlayerReady();

    Object? playbackError;
    player.addEventListener(PlayerEventTypes.ERROR, (event) => playbackError = (event as ErrorEvent).error);
    player.muted = true;
    player.autoplay = true;
    player.source = SourceDescription(sources: [
      TypedSource(
        src: _liveStream,
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

    for (var second = 0; second < 30 && player.currentTime == 0; second++) {
      await tester.pump(const Duration(seconds: 1));
    }

    expect(playbackError, isNull);
    expect(player.currentTime, greaterThan(0));

    if (kIsWeb || defaultTargetPlatform == TargetPlatform.android) {
      final currentSource = player.source?.sources.first;
      expect(currentSource?.latencyConfiguration?.targetOffset, _targetOffset);
      if (kIsWeb) {
        expect(currentSource?.lowLatency, isTrue);
      }
    }
  });
}
