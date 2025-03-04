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

import '../integration_test_app/test_app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test basic playback with HYBRID_COMPOSITION', (WidgetTester tester) async {
    await runBasicPlaybackTest(tester, AndroidViewComposition.HYBRID_COMPOSITION);
  });

  // the only difference is is on Android
  testWidgets('Test basic playback with SURFACE_TEXTURE', (WidgetTester tester) async {
    await runBasicPlaybackTest(tester, AndroidViewComposition.SURFACE_TEXTURE);
  });

  testWidgets('Test basic THEOlive playback with HYBRID_COMPOSITION', (WidgetTester tester) async {
    await runBasicTHEOlivePlaybackTest(tester, AndroidViewComposition.HYBRID_COMPOSITION);
  });

  // the only difference is is on Android
  testWidgets('Test basic THEOlive playback with SURFACE_TEXTURE', (WidgetTester tester) async {
    await runBasicTHEOlivePlaybackTest(tester, AndroidViewComposition.SURFACE_TEXTURE);
  });

}

Future<void> runBasicPlaybackTest(WidgetTester tester, AndroidViewComposition androidViewComposition) async {
  TestApp app = TestApp(androidViewComposition: androidViewComposition,);
  await tester.pumpWidget(app);

  final chromlessPlayerView = find.byKey(const Key('testChromelessPlayer'));
  await tester.ensureVisible(chromlessPlayerView);
  final player = (tester.firstElement(chromlessPlayerView).widget as ChromelessPlayerView).player;
  await tester.pumpAndSettle();
  await app.waitForPlayerReady();
  await tester.pumpAndSettle();

  print("Testing isInitialized()");
  expect(player.isInitialized, isTrue);

  print("Testing isPaused()");
  expect(player.isPaused, isTrue);

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
}

Future<void> runBasicTHEOlivePlaybackTest(WidgetTester tester, AndroidViewComposition androidViewComposition) async {
  TestApp app = TestApp(androidViewComposition: androidViewComposition,);
  await tester.pumpWidget(app);

  final chromlessPlayerView = find.byKey(const Key('testChromelessPlayer'));
  await tester.ensureVisible(chromlessPlayerView);
  final player = (tester.firstElement(chromlessPlayerView).widget as ChromelessPlayerView).player;
  await tester.pumpAndSettle();
  await app.waitForPlayerReady();
  await tester.pumpAndSettle();

  print("Testing isInitialized()");
  expect(player.isInitialized, isTrue);

  print("Testing isPaused()");
  expect(player.isPaused, isTrue);

  player.setMuted(true);
  player.setAutoplay(true);

  print("Setting source");

  player.setSource(SourceDescription(sources: [
    TheoLiveSource(src: "38yyniscxeglzr8n0lbku57b0"),
  ]));

  await tester.pumpAndSettle(const Duration(seconds: 10));

  print("Testing channel state :  ${player.theoLive!.publicationState}");
  expect(player.theoLive?.publicationState == PublicationState.loaded, isTrue);

  print("Testing playback duration():  ${player.getDuration()}");
  expect(player.getDuration() == double.infinity, isTrue);

  print("Testing playback currentTime():  ${player.getCurrentTime()}");
  expect(player.getCurrentTime() >= 0, isTrue);
}
