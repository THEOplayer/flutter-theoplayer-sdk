// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://docs.flutter.dev/cookbook/testing/integration/introduction



import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:theoplayer/theoplayer.dart';

import 'test_app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test player created', (WidgetTester tester) async {
    await tester.pumpWidget(const TestApp());
    //await _setupPlayer();
    final chromlessPlayerView = find.byKey(const Key('testChromelessPlayer'));
    final player = (tester.firstElement(chromlessPlayerView).widget as ChromelessPlayer).player;
    await tester.pumpAndSettle();
    expect(player.isInitialized(), isTrue, reason: "Testing isInitialized()");
    expect(player.isPaused(), isTrue, reason: "Testing isPaused()");
  });

  testWidgets('Test basic playback', (WidgetTester tester) async {
    await tester.pumpWidget(const TestApp());
    //await _setupPlayer();
    final chromlessPlayerView = find.byKey(const Key('testChromelessPlayer'));
    final player = (tester.firstElement(chromlessPlayerView).widget as ChromelessPlayer).player;
    await tester.pumpAndSettle();

    print("Testing isInitialized()");
    expect(player.isInitialized(), isTrue, reason: "Testing isInitialized()");

    print("Testing isPaused()");
    expect(player.isPaused(), isTrue, reason: "Testing isPaused()");

    player.setMuted(true);

    print("Setting source");
    String sourceUrl = "https://cdn.theoplayer.com/video/dash/big_buck_bunny/BigBuckBunny_10s_simple_2014_05_09.mpd";
    if (!kIsWeb && Platform.isIOS) {
      print("Setting iOS source");
      sourceUrl = "https://cdn.theoplayer.com/video/big_buck_bunny/big_buck_bunny.m3u8";
    }
    player.setSource(
      SourceDescription(sources: [
          TypedSource(src: sourceUrl),
        ]
      )
    );

    player.play();

    await tester.pump(const Duration(seconds: 10));
    print("Testing playback duration():  ${player.getDuration()}");
    expect(player.getDuration() >= 5, isTrue );

  });


  testWidgets('Success integration test', (WidgetTester tester) async {
    expect(true, isTrue);
  });
}
