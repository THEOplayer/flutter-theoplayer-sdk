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

  /*
  THEOplayer? player;

  Future<void> _setupPlayer (){
    
    final ready = Completer();

    player = THEOplayer(
      theoPlayerConfig: THEOplayerConfig(
        license: "sZP7IYe6T6PeISfZ3QBr0Ozt3lg6FSa_IuC-TSeo0ZzL0QP1ISUKTD313Kh6FOPlUY3zWokgbgjNIOf9flIKCLh_3ufZFSxlISB-3uXgCZzr0SfZFS0t3l5t3Qfz0l5cCmfVfK4_bQgZCYxNWoryIQXzImf90Sbk0Sft3LCi0u5i0Oi6Io4pIYP1UQgqWgjeCYxgflEc3L5t0l0Z0ufk3SbrFOPeWok1dDrLYtA1Ioh6TgV6v6fVfKcqCoXVdQjLUOfVfGxEIDjiWQXrIYfpCoj-fgzVfKxqWDXNWG3ybojkbK3gflNWfKcqCoXVdQjLUOfVfGxEIDjiWQXrIYfpCoj-fgzVfG3edt06TgV6dwx-Wuh6FOP1WKxZWogef6i6CDrebKjNIwxof6i6IKgZIYxof6i6dDjLf6i6UQg9ID_6FOPzUKjLf6i6Uo46Wt06Ymi6bo4pIXjNWYAZIY3LdDjpflNzbG4gFOPKIDXzUYPgbZf9Dkkj",
        androidConfiguration: AndroidConfig(useHybridComposition: true)        ),
      onCreate: (){
        ready.complete();
      }
    );

    return ready.future;
  }
  */

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
    //player.setAutoplay(true);
    await tester.pumpAndSettle();
    player.setSource(
      SourceDescription(sources: [
          TypedSource(src: "https://cdn.theoplayer.com/video/big_buck_bunny/big_buck_bunny.m3u8"),
        ]
      )
    );
    await tester.pumpAndSettle();
    player.play();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 30));
    print("Testing playback duration():  ${player.getDuration()}");
    expect(player.getDuration() >= 5, isTrue );

  });


  testWidgets('Success integration test', (WidgetTester tester) async {
    expect(true, isTrue);
  });
}
