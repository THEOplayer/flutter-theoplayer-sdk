// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://docs.flutter.dev/cookbook/testing/integration/introduction

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:theoplayer/theoplayer.dart';

import 'test_app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test basic playback', (WidgetTester tester) async {
    TestApp app = TestApp();
    await tester.pumpWidget(app);

    final chromlessPlayerView = find.byKey(const Key('testChromelessPlayer'));
    await tester.ensureVisible(chromlessPlayerView);
    final player = (tester.firstElement(chromlessPlayerView).widget as ChromelessPlayer).player;
    await tester.pumpAndSettle();
    await app.waitForPlayerReady();

    print("Testing isInitialized()");
    expect(player.isInitialized(), isTrue);

    print("Testing isPaused()");
    expect(player.isPaused(), isTrue);

    player.setMuted(true);
    player.setAutoplay(true);

    print("Setting source");

    player.setSource(SourceDescription(sources: [
      TypedSource(src: "https://cdn.theoplayer.com/video/big_buck_bunny/big_buck_bunny.m3u8"),
    ]));

    await tester.pumpAndSettle(const Duration(seconds: 10));

    print("Testing playback duration():  ${player.getDuration()}");
    expect(player.getDuration() >= 0, isTrue);

    print("Testing playback currentTime():  ${player.getCurrentTime()}");
    expect(player.getCurrentTime() >= 5, isTrue);
  });
}
