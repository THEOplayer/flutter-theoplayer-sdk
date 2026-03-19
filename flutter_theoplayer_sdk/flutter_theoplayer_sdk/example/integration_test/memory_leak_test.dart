import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:theoplayer/theoplayer.dart';

import '../integration_test_app/test_app.dart';

const int memoryTestIterations = int.fromEnvironment("MEMORY_TEST_ITERATIONS", defaultValue: 10);
const Duration settleDuration = Duration(seconds: 2);
const Duration playbackDuration = Duration(seconds: 5);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Memory leak test with HYBRID_COMPOSITION', (WidgetTester tester) async {
    await runMemoryLeakTest(tester, AndroidViewComposition.HYBRID_COMPOSITION);
  });

  testWidgets('Memory leak test with SURFACE_TEXTURE', (WidgetTester tester) async {
    await runMemoryLeakTest(tester, AndroidViewComposition.SURFACE_TEXTURE);
  });
}

Future<void> runMemoryLeakTest(WidgetTester tester, AndroidViewComposition androidViewComposition) async {
  print("MEMORY_TEST: Starting memory leak test with $androidViewComposition, iterations=$memoryTestIterations");
  print("MEMORY_TEST: TIMESTAMP_START=${DateTime.now().millisecondsSinceEpoch}");

  for (int i = 0; i < memoryTestIterations; i++) {
    print("MEMORY_TEST: CYCLE_START iteration=$i timestamp=${DateTime.now().millisecondsSinceEpoch}");

    // Create player
    TestApp app = TestApp(androidViewComposition: androidViewComposition);
    await tester.pumpWidget(app);

    final chromelessPlayerView = find.byKey(const Key('testChromelessPlayer'));
    await tester.ensureVisible(chromelessPlayerView);
    final player = (tester.firstElement(chromelessPlayerView).widget as ChromelessPlayerView).player;
    await tester.pumpAndSettle();
    await app.waitForPlayerReady();
    await tester.pumpAndSettle();

    expect(player.isInitialized, isTrue);

    // Load and play
    player.setMuted(true);
    player.setAutoplay(true);

    player.setSource(SourceDescription(sources: [
      TypedSource(src: "https://cdn.theoplayer.com/video/big_buck_bunny/big_buck_bunny.m3u8"),
    ]));

    await tester.pumpAndSettle(playbackDuration);

    expect(player.getCurrentTime() >= 0, isTrue);
    print("MEMORY_TEST: PLAYING iteration=$i currentTime=${player.getCurrentTime()}");

    // Destroy player by pumping an empty container
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();

    print("MEMORY_TEST: CYCLE_END iteration=$i timestamp=${DateTime.now().millisecondsSinceEpoch}");

    // Let GC settle between cycles
    await tester.pumpAndSettle(settleDuration);
  }

  print("MEMORY_TEST: TIMESTAMP_END=${DateTime.now().millisecondsSinceEpoch}");
  print("MEMORY_TEST: All $memoryTestIterations iterations completed");
}
