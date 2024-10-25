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

  testWidgets('Test player creation', (WidgetTester tester) async {
    TestApp app = TestApp();
    await tester.pumpWidget(app);

    //await _setupPlayer();
    final chromlessPlayerView = find.byKey(const Key('testChromelessPlayer'));
    await tester.ensureVisible(chromlessPlayerView);
    final player = (tester.firstElement(chromlessPlayerView).widget as ChromelessPlayerView).player;

    await tester.pumpAndSettle();
    await app.waitForPlayerReady();

    expect(player.isInitialized, isTrue, reason: "Testing isInitialized()");
    expect(player.isPaused, isTrue, reason: "Testing isPaused()");
  });
}
