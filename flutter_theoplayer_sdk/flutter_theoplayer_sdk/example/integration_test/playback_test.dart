// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://docs.flutter.dev/cookbook/testing/integration/introduction

import 'dart:async';

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

  testWidgets('Test latencies with HYBRID_COMPOSITION', (WidgetTester tester) async {
    await runLatenciesTest(tester, AndroidViewComposition.HYBRID_COMPOSITION);
  });

  testWidgets('Test latencies with SURFACE_TEXTURE', (WidgetTester tester) async {
    await runLatenciesTest(tester, AndroidViewComposition.SURFACE_TEXTURE);
  });

  //disabled for now only on WEB, we need to figure out the license
  if (!kIsWeb) {
    testWidgets('Test basic THEOlive playback with HYBRID_COMPOSITION', (WidgetTester tester) async {
      await runBasicTHEOlivePlaybackTest(tester, AndroidViewComposition.HYBRID_COMPOSITION);
    });

    // the only difference is is on Android
    testWidgets('Test basic THEOlive playback with SURFACE_TEXTURE', (WidgetTester tester) async {
      await runBasicTHEOlivePlaybackTest(tester, AndroidViewComposition.SURFACE_TEXTURE);
    });

    testWidgets('Test video track events with HYBRID_COMPOSITION', (WidgetTester tester) async {
      await runVideoTrackEventsTest(tester, AndroidViewComposition.HYBRID_COMPOSITION);
    });

    testWidgets('Test video track events with SURFACE_TEXTURE', (WidgetTester tester) async {
      await runVideoTrackEventsTest(tester, AndroidViewComposition.SURFACE_TEXTURE);
    });

    testWidgets('Test audio track events with HYBRID_COMPOSITION', (WidgetTester tester) async {
      await runAudioTrackEventsTest(tester, AndroidViewComposition.HYBRID_COMPOSITION);
    });

    testWidgets('Test audio track events with SURFACE_TEXTURE', (WidgetTester tester) async {
      await runAudioTrackEventsTest(tester, AndroidViewComposition.SURFACE_TEXTURE);
    });

    testWidgets('Test text track events with HYBRID_COMPOSITION', (WidgetTester tester) async {
      await runTextTrackEventsTest(tester, AndroidViewComposition.HYBRID_COMPOSITION);
    });

    testWidgets('Test text track events with SURFACE_TEXTURE', (WidgetTester tester) async {
      await runTextTrackEventsTest(tester, AndroidViewComposition.SURFACE_TEXTURE);
    });

    testWidgets('Test quality properties with HYBRID_COMPOSITION', (WidgetTester tester) async {
      await runQualityPropertiesTest(tester, AndroidViewComposition.HYBRID_COMPOSITION);
    });

    testWidgets('Test quality properties with SURFACE_TEXTURE', (WidgetTester tester) async {
      await runQualityPropertiesTest(tester, AndroidViewComposition.SURFACE_TEXTURE);
    });
  }
}

Future<void> runBasicPlaybackTest(WidgetTester tester, AndroidViewComposition androidViewComposition) async {
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

  print("Testing channel state :  ${player.theoLive!.distributionState}");
  expect(player.theoLive?.distributionState == DistributionState.loaded, isTrue);

  print("Testing playback duration():  ${player.getDuration()}");
  expect(player.getDuration() == double.infinity, isTrue);

  print("Testing playback currentTime():  ${player.getCurrentTime()}");
  expect(player.getCurrentTime() >= 0, isTrue);
}

Future<void> runVideoTrackEventsTest(WidgetTester tester, AndroidViewComposition androidViewComposition) async {
  TestApp app = TestApp(androidViewComposition: androidViewComposition);
  await tester.pumpWidget(app);

  final chromlessPlayerView = find.byKey(const Key('testChromelessPlayer'));
  await tester.ensureVisible(chromlessPlayerView);
  final player = (tester.firstElement(chromlessPlayerView).widget as ChromelessPlayerView).player;
  await tester.pumpAndSettle();
  await app.waitForPlayerReady();
  await tester.pumpAndSettle();

  expect(player.isInitialized, isTrue);

  player.setMuted(true);
  player.setAutoplay(true);

  // Track events we expect to receive
  final addTrackCompleter = Completer<AddVideoTrackEvent>();
  final activeQualityChangedCompleter = Completer<VideoActiveQualityChangedEvent>();

  player.videoTracks.addEventListener(VideoTracksEventTypes.ADDTRACK, (event) {
    print("Received ADDTRACK event");
    if (!addTrackCompleter.isCompleted) {
      addTrackCompleter.complete(event as AddVideoTrackEvent);
    }
  });

  print("Setting source for video track events test");
  player.setSource(SourceDescription(sources: [
    TheoLiveSource(src: "38yyniscxeglzr8n0lbku57b0"),
  ]));

  await tester.pumpAndSettle(const Duration(seconds: 10));

  // Verify ADDTRACK event was received
  print("Testing ADDTRACK event received");
  expect(addTrackCompleter.isCompleted, isTrue);
  final addTrackEvent = addTrackCompleter.isCompleted ? addTrackCompleter.future : null;
  if (addTrackEvent != null) {
    final track = (await addTrackEvent).track;
    print("Added track: id=${track.id}, label=${track.label}, kind=${track.kind}");
    expect(track.id, isNotNull);

    // Listen for active quality change on the track
    track.addEventListener(VideoTrackEventTypes.ACTIVEQUALITYCHANGED, (event) {
      print("Received ACTIVEQUALITYCHANGED event");
      if (!activeQualityChangedCompleter.isCompleted) {
        activeQualityChangedCompleter.complete(event as VideoActiveQualityChangedEvent);
      }
    });
  }

  // Verify video tracks are available
  print("Testing videoTracks count: ${player.videoTracks.length}");
  expect(player.videoTracks.length, greaterThan(0));

  final firstTrack = player.videoTracks[0]; // Video has only one track right now
  print("Testing first video track properties");
  expect(firstTrack.id, isNotNull);
  print("  id: ${firstTrack.id}, label: ${firstTrack.label}, kind: ${firstTrack.kind}, isEnabled: ${firstTrack.isEnabled}");

  // Verify qualities are available
  print("Testing video qualities count: ${firstTrack.qualities.length}");
  expect(firstTrack.qualities.length, greaterThan(0));

  final firstQuality = firstTrack.qualities[0];
  print("  quality: ${firstQuality.width}x${firstQuality.height}, bandwidth: ${firstQuality.bandwidth}, codecs: ${firstQuality.codecs}");
  expect(firstQuality.width, greaterThan(0));
  expect(firstQuality.height, greaterThan(0));

  // Wait a bit more for active quality to be reported
  await tester.pumpAndSettle(const Duration(seconds: 5));

  print("Testing activeQuality");
  final activeQuality = firstTrack.activeQuality;
  expect(activeQuality, isNotNull, reason: "activeQuality should be available after playback starts");
  print("  activeQuality: ${activeQuality!.width}x${activeQuality.height}");
  expect(activeQuality.width, greaterThan(0));
  expect(activeQuality.height, greaterThan(0));
}

Future<void> runAudioTrackEventsTest(WidgetTester tester, AndroidViewComposition androidViewComposition) async {
  TestApp app = TestApp(androidViewComposition: androidViewComposition);
  await tester.pumpWidget(app);

  final chromlessPlayerView = find.byKey(const Key('testChromelessPlayer'));
  await tester.ensureVisible(chromlessPlayerView);
  final player = (tester.firstElement(chromlessPlayerView).widget as ChromelessPlayerView).player;
  await tester.pumpAndSettle();
  await app.waitForPlayerReady();
  await tester.pumpAndSettle();

  expect(player.isInitialized, isTrue);

  player.setMuted(true);
  player.setAutoplay(true);

  final addTrackCompleter = Completer<AddAudioTrackEvent>();

  player.audioTracks.addEventListener(AudioTracksEventTypes.ADDTRACK, (event) {
    print("Received audio ADDTRACK event");
    if (!addTrackCompleter.isCompleted) {
      addTrackCompleter.complete(event as AddAudioTrackEvent);
    }
  });

  print("Setting source for audio track events test");
  player.setSource(SourceDescription(sources: [
    TheoLiveSource(src: "38yyniscxeglzr8n0lbku57b0"),
  ]));

  await tester.pumpAndSettle(const Duration(seconds: 10));

  // Verify ADDTRACK event was received
  print("Testing audio ADDTRACK event received");
  expect(addTrackCompleter.isCompleted, isTrue);

  // Verify audio tracks are available
  print("Testing audioTracks count: ${player.audioTracks.length}");
  expect(player.audioTracks.length, greaterThan(0));

  final firstTrack = player.audioTracks[0];
  print("Testing first audio track properties");
  print("  id: ${firstTrack.id}, label: ${firstTrack.label}, kind: ${firstTrack.kind}, isEnabled: ${firstTrack.isEnabled}");
  expect(firstTrack.id, isNotNull);

  // Verify audio qualities are available (not supported on iOS)
  final bool isIOS = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
  if (isIOS) {
    print("Skipping audio qualities check on iOS (not supported)");
  } else {
    print("Testing audio qualities count: ${firstTrack.qualities.length}");
    expect(firstTrack.qualities.length, greaterThan(0), reason: "Audio qualities should be available on ${kIsWeb ? 'Web' : 'Android'}");
    final firstQuality = firstTrack.qualities[0];
    print("  quality: bandwidth=${firstQuality.bandwidth}, audioSamplingRate=${firstQuality.audioSamplingRate}");
    expect(firstQuality.bandwidth, greaterThan(0));
  }
}

Future<void> runTextTrackEventsTest(WidgetTester tester, AndroidViewComposition androidViewComposition) async {
  TestApp app = TestApp(androidViewComposition: androidViewComposition);
  await tester.pumpWidget(app);

  final chromlessPlayerView = find.byKey(const Key('testChromelessPlayer'));
  await tester.ensureVisible(chromlessPlayerView);
  final player = (tester.firstElement(chromlessPlayerView).widget as ChromelessPlayerView).player;
  await tester.pumpAndSettle();
  await app.waitForPlayerReady();
  await tester.pumpAndSettle();

  expect(player.isInitialized, isTrue);

  player.setMuted(true);
  player.setAutoplay(true);

  final addTrackCompleter = Completer<AddTextTrackEvent>();

  player.textTracks.addEventListener(TextTracksEventTypes.ADDTRACK, (event) {
    print("Received text ADDTRACK event");
    if (!addTrackCompleter.isCompleted) {
      addTrackCompleter.complete(event as AddTextTrackEvent);
    }
  });

  print("Setting source for text track events test");
  player.setSource(SourceDescription(sources: [
    TheoLiveSource(src: "38yyniscxeglzr8n0lbku57b0"),
  ]));

  await tester.pumpAndSettle(const Duration(seconds: 10));

  // Text tracks may or may not be present depending on the source
  print("Testing textTracks count: ${player.textTracks.length}");
  if (player.textTracks.isNotEmpty) {
    final firstTrack = player.textTracks[0];
    print("Testing first text track properties");
    print("  id: ${firstTrack.id}, label: ${firstTrack.label}, kind: ${firstTrack.kind}, language: ${firstTrack.language}");
    expect(firstTrack.id, isNotNull);
  }

  if (addTrackCompleter.isCompleted) {
    final event = await addTrackCompleter.future;
    print("Text track added: id=${event.track.id}, label=${event.track.label}");
    expect(event.track.id, isNotNull);
  }
}

Future<void> runQualityPropertiesTest(WidgetTester tester, AndroidViewComposition androidViewComposition) async {
  TestApp app = TestApp(androidViewComposition: androidViewComposition);
  await tester.pumpWidget(app);

  final chromlessPlayerView = find.byKey(const Key('testChromelessPlayer'));
  await tester.ensureVisible(chromlessPlayerView);
  final player = (tester.firstElement(chromlessPlayerView).widget as ChromelessPlayerView).player;
  await tester.pumpAndSettle();
  await app.waitForPlayerReady();
  await tester.pumpAndSettle();

  expect(player.isInitialized, isTrue);

  player.setMuted(true);
  player.setAutoplay(true);

  print("Setting source for quality properties test");
  player.setSource(SourceDescription(sources: [
    TheoLiveSource(src: "38yyniscxeglzr8n0lbku57b0"),
  ]));

  await tester.pumpAndSettle(const Duration(seconds: 10));

  // Test video quality properties
  expect(player.videoTracks.length, greaterThan(0));
  final videoTrack = player.videoTracks[0];
  expect(videoTrack.qualities.length, greaterThan(0));

  for (final quality in videoTrack.qualities) {
    print("Video quality: ${quality.width}x${quality.height}, bandwidth=${quality.bandwidth}, averageBandwidth=${quality.averageBandwidth}, available=${quality.available}");
    expect(quality.bandwidth, greaterThan(0));
    expect(quality.available, isNotNull);
    // width and height should be non-negative
    expect(quality.width, greaterThanOrEqualTo(0));
    expect(quality.height, greaterThanOrEqualTo(0));
  }

  // Test unlocalizedLabel on video track
  print("Video track unlocalizedLabel: ${videoTrack.unlocalizedLabel}");
  // unlocalizedLabel may be null, just verify it's accessible

  // Test audio quality properties (not supported on iOS)
  final bool isIOS = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
  if (player.audioTracks.isNotEmpty) {
    final audioTrack = player.audioTracks[0];
    print("Audio track unlocalizedLabel: ${audioTrack.unlocalizedLabel}");

    if (isIOS) {
      print("Skipping audio quality properties check on iOS (not supported)");
    } else {
      expect(audioTrack.qualities.length, greaterThan(0), reason: "Audio qualities should be available on ${kIsWeb ? 'Web' : 'Android'}");
      for (final quality in audioTrack.qualities) {
        print("Audio quality: bandwidth=${quality.bandwidth}, audioSamplingRate=${quality.audioSamplingRate}, averageBandwidth=${quality.averageBandwidth}, available=${quality.available}");
        expect(quality.bandwidth, greaterThanOrEqualTo(0));
        expect(quality.available, isNotNull);
      }
    }
  }
}

Future<void> runLatenciesTest(WidgetTester tester, AndroidViewComposition androidViewComposition) async {
  TestApp app = TestApp(androidViewComposition: androidViewComposition);
  await tester.pumpWidget(app);

  final chromlessPlayerView = find.byKey(const Key('testChromelessPlayer'));
  await tester.ensureVisible(chromlessPlayerView);
  final player = (tester.firstElement(chromlessPlayerView).widget as ChromelessPlayerView).player;
  await tester.pumpAndSettle();
  await app.waitForPlayerReady();
  await tester.pumpAndSettle();

  expect(player.isInitialized, isTrue);

  player.setMuted(true);
  player.setAutoplay(true);

  print("Setting source for latencies test");
  player.setSource(SourceDescription(sources: [
    TheoLiveSource(src: "26rg6y91ajl4yc5mv0vas5bu7"),
  ]));

  await tester.pumpAndSettle(const Duration(seconds: 10));

  // Test latencies
  expect(player.theoLive, isNotNull);

  final latencies = await player.theoLive!.latencies;
  print("Latencies: engineLatency=${latencies?.engineLatency}, distributionLatency=${latencies?.distributionLatency}, playerLatency=${latencies?.playerLatency}, theoliveLatency=${latencies?.theoliveLatency}");

  expect(latencies, isNotNull);
  expect(latencies!.theoliveLatency, isNotNull);
  expect(latencies.theoliveLatency!, greaterThan(0));

  // Test currentLatency
  final currentLatency = await player.theoLive!.currentLatency;
  print("Current latency: $currentLatency");
  expect(currentLatency, isNotNull);
  expect(currentLatency!, greaterThan(0));
}
