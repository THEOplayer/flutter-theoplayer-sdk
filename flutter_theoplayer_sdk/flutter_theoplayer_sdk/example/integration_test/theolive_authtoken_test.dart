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

  testWidgets('Test THEOlive authToken set/get with HYBRID_COMPOSITION', (WidgetTester tester) async {
    await runTHEOliveAuthTokenTest(tester, AndroidViewComposition.HYBRID_COMPOSITION);
  });

  // the only difference is on Android
  testWidgets('Test THEOlive authToken set/get with SURFACE_TEXTURE', (WidgetTester tester) async {
    await runTHEOliveAuthTokenTest(tester, AndroidViewComposition.SURFACE_TEXTURE);
  });
}

Future<void> runTHEOliveAuthTokenTest(WidgetTester tester, AndroidViewComposition androidViewComposition) async {
  TestApp app = TestApp(
    androidViewComposition: androidViewComposition,
  );
  await tester.pumpWidget(app);

  final chromlessPlayerView = find.byKey(const Key('testChromelessPlayer'));
  await tester.ensureVisible(chromlessPlayerView);
  final player = (tester.firstElement(chromlessPlayerView).widget as ChromelessPlayerView).player;
  await tester.pumpAndSettle();
  await app.waitForPlayerReady();
  await tester.pumpAndSettle();

  expect(player.isInitialized, isTrue);
  expect(player.theoLive, isNotNull);

  final theoLive = player.theoLive!;

  print("Testing THEOlive authToken default is null");
  expect(theoLive.authToken, isNull);

  print("Testing THEOlive authToken set/get roundtrip");
  const token = "test-auth-token";
  theoLive.authToken = token;
  expect(theoLive.authToken, equals(token));

  print("Testing THEOlive authToken unset via null");
  theoLive.authToken = null;
  expect(theoLive.authToken, isNull);
}
