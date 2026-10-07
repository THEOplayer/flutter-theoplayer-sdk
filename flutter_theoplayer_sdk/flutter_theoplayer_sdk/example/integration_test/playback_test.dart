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
import '../integration_test_app/test_log.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test basic playback with HYBRID_COMPOSITION', (WidgetTester tester) async {
    await runBasicPlaybackTest(tester, AndroidViewComposition.HYBRID_COMPOSITION);
  });

  // the only difference is is on Android
  testWidgets('Test basic playback with SURFACE_TEXTURE', (WidgetTester tester) async {
    await runBasicPlaybackTest(tester, AndroidViewComposition.SURFACE_TEXTURE);
  });

  testWidgets('Test playbackRate reporting with HYBRID_COMPOSITION', (WidgetTester tester) async {
    await runPlaybackRateTest(tester, AndroidViewComposition.HYBRID_COMPOSITION);
  });

  testWidgets('Test playbackRate reporting with SURFACE_TEXTURE', (WidgetTester tester) async {
    await runPlaybackRateTest(tester, AndroidViewComposition.SURFACE_TEXTURE);
  });

  //disabled for now only on WEB, we need to figure out the license
  if (!kIsWeb) {
    // Latency tests are iOS-only for now: Android native SDK doesn't expose latency properties yet.
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      testWidgets('Test latencies with HYBRID_COMPOSITION', (WidgetTester tester) async {
        await runLatenciesTest(tester, AndroidViewComposition.HYBRID_COMPOSITION);
      });

      testWidgets('Test latencies with SURFACE_TEXTURE', (WidgetTester tester) async {
        await runLatenciesTest(tester, AndroidViewComposition.SURFACE_TEXTURE);
      });
    }

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

    testWidgets('Test THEOlive ABR strategy performance with HYBRID_COMPOSITION', (WidgetTester tester) async {
      await runTHEOliveAbrStrategyPerformanceTest(tester, AndroidViewComposition.HYBRID_COMPOSITION);
    });

    testWidgets('Test THEOlive ABR strategy performance with SURFACE_TEXTURE', (WidgetTester tester) async {
      await runTHEOliveAbrStrategyPerformanceTest(tester, AndroidViewComposition.SURFACE_TEXTURE);
    });

    testWidgets('Test THEOlive ABR strategy quality with HYBRID_COMPOSITION', (WidgetTester tester) async {
      await runTHEOliveAbrStrategyQualityTest(tester, AndroidViewComposition.HYBRID_COMPOSITION);
    });

    testWidgets('Test THEOlive ABR strategy quality with SURFACE_TEXTURE', (WidgetTester tester) async {
      await runTHEOliveAbrStrategyQualityTest(tester, AndroidViewComposition.SURFACE_TEXTURE);
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

  testLog("Testing isInitialized()");
  expect(player.isInitialized, isTrue);

  testLog("Testing isPaused()");
  expect(player.isPaused, isTrue);

  player.muted = true;
  player.autoplay = true;

  testLog("Setting source");

  player.source = SourceDescription(sources: [
    TypedSource(src: "https://cdn.theoplayer.com/video/big_buck_bunny/big_buck_bunny.m3u8"),
  ]);

  // Flutter frames can settle before native playback reaches five seconds, so poll the player's time with a deadline.
  final deadline = DateTime.now().add(const Duration(seconds: 30));
  while (player.currentTime < 5 && DateTime.now().isBefore(deadline)) {
    await tester.pump(const Duration(milliseconds: 500));
  }

  testLog("Testing playback duration():  ${player.duration}");
  expect(player.duration >= 0, isTrue);

  testLog("Testing playback currentTime():  ${player.currentTime}");
  expect(player.currentTime >= 5, isTrue);
}

/// playbackRate must reflect the native player's rate (1.0 by default) without any prior `ratechange`.
Future<void> runPlaybackRateTest(WidgetTester tester, AndroidViewComposition androidViewComposition) async {
  TestApp app = TestApp(androidViewComposition: androidViewComposition);
  await tester.pumpWidget(app);

  final chromlessPlayerView = find.byKey(const Key('testChromelessPlayer'));
  await tester.ensureVisible(chromlessPlayerView);
  final player = (tester.firstElement(chromlessPlayerView).widget as ChromelessPlayerView).player;
  await tester.pumpAndSettle();
  await app.waitForPlayerReady();
  await tester.pumpAndSettle();

  expect(player.isInitialized, isTrue);

  testLog("Testing playbackRate before any source: ${player.playbackRate}");
  expect(player.playbackRate, equals(1.0));

  final rateChanges = <double>[];
  player.addEventListener(PlayerEventTypes.RATECHANGE, (event) => rateChanges.add((event as RateChangeEvent).playbackRate));

  player.muted = true;
  player.autoplay = true;
  player.source = SourceDescription(sources: [
    TypedSource(src: "https://cdn.theoplayer.com/video/big_buck_bunny/big_buck_bunny.m3u8"),
  ]);

  await tester.pumpAndSettle(const Duration(seconds: 10));

  testLog("Testing playbackRate while playing at default speed: ${player.playbackRate} (ratechange events: $rateChanges)");
  expect(player.currentTime, greaterThan(0));
  expect(player.playbackRate, equals(1.0));

  player.playbackRate = 1.5;
  await tester.pumpAndSettle(const Duration(seconds: 3));

  testLog("Testing playbackRate after setting 1.5: ${player.playbackRate} (ratechange events: $rateChanges)");
  expect(player.playbackRate, equals(1.5));
  expect(rateChanges, contains(1.5));
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

  testLog("Testing isInitialized()");
  expect(player.isInitialized, isTrue);

  testLog("Testing isPaused()");
  expect(player.isPaused, isTrue);

  player.muted = true;
  player.autoplay = true;

  testLog("Setting source");

  player.source = SourceDescription(sources: [
    TheoLiveSource(src: "38yyniscxeglzr8n0lbku57b0"),
  ]);

  await tester.pumpAndSettle(const Duration(seconds: 10));

  testLog("Testing channel state :  ${player.theoLive!.distributionState}");
  expect(player.theoLive?.distributionState == DistributionState.loaded, isTrue);

  testLog("Testing playback duration():  ${player.duration}");
  expect(player.duration == double.infinity, isTrue);

  testLog("Testing playback currentTime():  ${player.currentTime}");
  expect(player.currentTime >= 0, isTrue);
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

  player.muted = true;
  player.autoplay = true;

  // Track events we expect to receive
  final addTrackCompleter = Completer<AddVideoTrackEvent>();
  final activeQualityChangedCompleter = Completer<VideoActiveQualityChangedEvent>();

  player.videoTracks.addEventListener(VideoTracksEventTypes.ADDTRACK, (event) {
    testLog("Received ADDTRACK event");
    if (!addTrackCompleter.isCompleted) {
      addTrackCompleter.complete(event as AddVideoTrackEvent);
    }
  });

  testLog("Setting source for video track events test");
  player.source = SourceDescription(sources: [
    TheoLiveSource(src: "38yyniscxeglzr8n0lbku57b0"),
  ]);

  await tester.pumpAndSettle(const Duration(seconds: 10));

  // Verify ADDTRACK event was received
  testLog("Testing ADDTRACK event received");
  expect(addTrackCompleter.isCompleted, isTrue);
  final addTrackEvent = addTrackCompleter.isCompleted ? addTrackCompleter.future : null;
  if (addTrackEvent != null) {
    final track = (await addTrackEvent).track;
    testLog("Added track: id=${track.id}, label=${track.label}, kind=${track.kind}");
    expect(track.id, isNotNull);

    // Listen for active quality change on the track
    track.addEventListener(VideoTrackEventTypes.ACTIVEQUALITYCHANGED, (event) {
      testLog("Received ACTIVEQUALITYCHANGED event");
      if (!activeQualityChangedCompleter.isCompleted) {
        activeQualityChangedCompleter.complete(event as VideoActiveQualityChangedEvent);
      }
    });
  }

  // Verify video tracks are available
  testLog("Testing videoTracks count: ${player.videoTracks.length}");
  expect(player.videoTracks.length, greaterThan(0));

  final firstTrack = player.videoTracks[0]; // Video has only one track right now
  testLog("Testing first video track properties");
  expect(firstTrack.id, isNotNull);
  testLog("  id: ${firstTrack.id}, label: ${firstTrack.label}, kind: ${firstTrack.kind}, isEnabled: ${firstTrack.isEnabled}");

  // Verify qualities are available
  testLog("Testing video qualities count: ${firstTrack.qualities.length}");
  expect(firstTrack.qualities.length, greaterThan(0));

  final firstQuality = firstTrack.qualities[0];
  testLog("  quality: ${firstQuality.width}x${firstQuality.height}, bandwidth: ${firstQuality.bandwidth}, codecs: ${firstQuality.codecs}");
  expect(firstQuality.width, greaterThan(0));
  expect(firstQuality.height, greaterThan(0));

  // Wait a bit more for active quality to be reported
  await tester.pumpAndSettle(const Duration(seconds: 5));

  testLog("Testing activeQuality");
  final activeQuality = firstTrack.activeQuality;
  expect(activeQuality, isNotNull, reason: "activeQuality should be available after playback starts");
  testLog("  activeQuality: ${activeQuality!.width}x${activeQuality.height}");
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

  player.muted = true;
  player.autoplay = true;

  final addTrackCompleter = Completer<AddAudioTrackEvent>();

  player.audioTracks.addEventListener(AudioTracksEventTypes.ADDTRACK, (event) {
    testLog("Received audio ADDTRACK event");
    if (!addTrackCompleter.isCompleted) {
      addTrackCompleter.complete(event as AddAudioTrackEvent);
    }
  });

  testLog("Setting source for audio track events test");
  player.source = SourceDescription(sources: [
    TheoLiveSource(src: "38yyniscxeglzr8n0lbku57b0"),
  ]);

  await tester.pumpAndSettle(const Duration(seconds: 10));

  // Verify ADDTRACK event was received
  testLog("Testing audio ADDTRACK event received");
  expect(addTrackCompleter.isCompleted, isTrue);

  // Verify audio tracks are available
  testLog("Testing audioTracks count: ${player.audioTracks.length}");
  expect(player.audioTracks.length, greaterThan(0));

  final firstTrack = player.audioTracks[0];
  testLog("Testing first audio track properties");
  testLog("  id: ${firstTrack.id}, label: ${firstTrack.label}, kind: ${firstTrack.kind}, isEnabled: ${firstTrack.isEnabled}");
  expect(firstTrack.id, isNotNull);

  // Verify audio qualities are available (not supported on iOS)
  final bool isIOS = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
  if (isIOS) {
    testLog("Skipping audio qualities check on iOS (not supported)");
  } else {
    testLog("Testing audio qualities count: ${firstTrack.qualities.length}");
    expect(firstTrack.qualities.length, greaterThan(0), reason: "Audio qualities should be available on ${kIsWeb ? 'Web' : 'Android'}");
    final firstQuality = firstTrack.qualities[0];
    testLog("  quality: bandwidth=${firstQuality.bandwidth}, audioSamplingRate=${firstQuality.audioSamplingRate}");
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

  player.muted = true;
  player.autoplay = true;

  final addTrackCompleter = Completer<AddTextTrackEvent>();

  player.textTracks.addEventListener(TextTracksEventTypes.ADDTRACK, (event) {
    testLog("Received text ADDTRACK event");
    if (!addTrackCompleter.isCompleted) {
      addTrackCompleter.complete(event as AddTextTrackEvent);
    }
  });

  testLog("Setting source for text track events test");
  player.source = SourceDescription(sources: [
    TheoLiveSource(src: "38yyniscxeglzr8n0lbku57b0"),
  ]);

  await tester.pumpAndSettle(const Duration(seconds: 10));

  // Text tracks may or may not be present depending on the source
  testLog("Testing textTracks count: ${player.textTracks.length}");
  if (player.textTracks.isNotEmpty) {
    final firstTrack = player.textTracks[0];
    testLog("Testing first text track properties");
    testLog("  id: ${firstTrack.id}, label: ${firstTrack.label}, kind: ${firstTrack.kind}, language: ${firstTrack.language}");
    expect(firstTrack.id, isNotNull);
  }

  if (addTrackCompleter.isCompleted) {
    final event = await addTrackCompleter.future;
    testLog("Text track added: id=${event.track.id}, label=${event.track.label}");
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

  player.muted = true;
  player.autoplay = true;

  testLog("Setting source for quality properties test");
  player.source = SourceDescription(sources: [
    TheoLiveSource(src: "38yyniscxeglzr8n0lbku57b0"),
  ]);

  await tester.pumpAndSettle(const Duration(seconds: 10));

  // Test video quality properties
  expect(player.videoTracks.length, greaterThan(0));
  final videoTrack = player.videoTracks[0];
  expect(videoTrack.qualities.length, greaterThan(0));

  for (final quality in videoTrack.qualities) {
    testLog("Video quality: ${quality.width}x${quality.height}, bandwidth=${quality.bandwidth}, averageBandwidth=${quality.averageBandwidth}, available=${quality.available}");
    expect(quality.bandwidth, greaterThan(0));
    expect(quality.available, isNotNull);
    // width and height should be non-negative
    expect(quality.width, greaterThanOrEqualTo(0));
    expect(quality.height, greaterThanOrEqualTo(0));
  }

  // Test unlocalizedLabel on video track
  testLog("Video track unlocalizedLabel: ${videoTrack.unlocalizedLabel}");
  // unlocalizedLabel may be null, just verify it's accessible

  // Test audio quality properties (not supported on iOS)
  final bool isIOS = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
  if (player.audioTracks.isNotEmpty) {
    final audioTrack = player.audioTracks[0];
    testLog("Audio track unlocalizedLabel: ${audioTrack.unlocalizedLabel}");

    if (isIOS) {
      testLog("Skipping audio quality properties check on iOS (not supported)");
    } else {
      expect(audioTrack.qualities.length, greaterThan(0), reason: "Audio qualities should be available on ${kIsWeb ? 'Web' : 'Android'}");
      for (final quality in audioTrack.qualities) {
        testLog("Audio quality: bandwidth=${quality.bandwidth}, audioSamplingRate=${quality.audioSamplingRate}, averageBandwidth=${quality.averageBandwidth}, available=${quality.available}");
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

  player.muted = true;
  player.autoplay = true;

  testLog("Setting source for latencies test");
  player.source = SourceDescription(sources: [
    TheoLiveSource(src: "38yyniscxeglzr8n0lbku57b0"),
  ]);

  // Test latencies
  expect(player.theoLive, isNotNull);

  final theoLive = player.theoLive!;
  final deadline = DateTime.now().add(const Duration(seconds: 30));
  HespLatencies? latencies;
  double? currentLatency;
  do {
    latencies = await theoLive.latencies;
    currentLatency = await theoLive.currentLatency;
    if ((latencies?.theoliveLatency ?? 0) > 0 && (currentLatency ?? 0) > 0) break;
    await tester.pump(const Duration(seconds: 1));
  } while (DateTime.now().isBefore(deadline));
  testLog(
      "Latencies: engineLatency=${latencies?.engineLatency}, distributionLatency=${latencies?.distributionLatency}, playerLatency=${latencies?.playerLatency}, theoliveLatency=${latencies?.theoliveLatency}");

  expect(latencies, isNotNull);
  expect(latencies!.theoliveLatency, isNotNull);
  expect(latencies.theoliveLatency!, greaterThan(0));

  // Test currentLatency
  testLog("Current latency: $currentLatency");
  expect(currentLatency, isNotNull);
  expect(currentLatency!, greaterThan(0));
}

Future<void> runTHEOliveAbrStrategyPerformanceTest(WidgetTester tester, AndroidViewComposition androidViewComposition) async {
  TestApp app = TestApp(androidViewComposition: androidViewComposition);
  await tester.pumpWidget(app);

  final chromlessPlayerView = find.byKey(const Key('testChromelessPlayer'));
  await tester.ensureVisible(chromlessPlayerView);
  final player = (tester.firstElement(chromlessPlayerView).widget as ChromelessPlayerView).player;
  await tester.pumpAndSettle();
  await app.waitForPlayerReady();
  await tester.pumpAndSettle();

  expect(player.isInitialized, isTrue);

  player.muted = true;
  player.autoplay = true;

  // Set ABR strategy to performance before setting source
  testLog("Setting ABR strategy to performance");
  await player.abr.setStrategy(AbrStrategyConfiguration(type: AbrStrategyType.performance));

  // Verify strategy is set
  final strategy = await player.abr.strategy;
  testLog("Current ABR strategy: ${strategy.type}");
  expect(strategy.type, equals(AbrStrategyType.performance));

  testLog("Setting THEOlive source");
  player.source = SourceDescription(sources: [
    TheoLiveSource(src: "38yyniscxeglzr8n0lbku57b0"),
  ]);

  // Wait just enough for initial track selection - ABR strategy only affects initial selection
  await tester.pumpAndSettle(const Duration(seconds: 3));

  // Verify video tracks are available
  expect(player.videoTracks.length, greaterThan(0));
  final videoTrack = player.videoTracks[0];
  expect(videoTrack.qualities.length, greaterThan(0));

  // Find the lowest bandwidth quality
  int lowestBandwidth = videoTrack.qualities.first.bandwidth;
  for (final quality in videoTrack.qualities) {
    if (quality.bandwidth < lowestBandwidth) {
      lowestBandwidth = quality.bandwidth;
    }
  }

  testLog("Available qualities:");
  for (final quality in videoTrack.qualities) {
    testLog("  ${quality.width}x${quality.height}, bandwidth=${quality.bandwidth}");
  }

  // With performance strategy, the initial active quality should be the lowest bandwidth
  final activeQuality = videoTrack.activeQuality;
  expect(activeQuality, isNotNull, reason: "Active quality should be available after playback starts");
  testLog("Initial active quality: ${activeQuality!.width}x${activeQuality.height}, bandwidth=${activeQuality.bandwidth}");
  testLog("Lowest bandwidth: $lowestBandwidth");

  // Verify the initial active quality is the lowest bandwidth quality
  expect(activeQuality.bandwidth, equals(lowestBandwidth), reason: "Performance strategy should select the lowest bandwidth video quality for initial track selection");
}

Future<void> runTHEOliveAbrStrategyQualityTest(WidgetTester tester, AndroidViewComposition androidViewComposition) async {
  TestApp app = TestApp(androidViewComposition: androidViewComposition);
  await tester.pumpWidget(app);

  final chromlessPlayerView = find.byKey(const Key('testChromelessPlayer'));
  await tester.ensureVisible(chromlessPlayerView);
  final player = (tester.firstElement(chromlessPlayerView).widget as ChromelessPlayerView).player;
  await tester.pumpAndSettle();
  await app.waitForPlayerReady();
  await tester.pumpAndSettle();

  expect(player.isInitialized, isTrue);

  player.muted = true;
  player.autoplay = true;

  // Set ABR strategy to quality before setting source
  testLog("Setting ABR strategy to quality");
  await player.abr.setStrategy(AbrStrategyConfiguration(type: AbrStrategyType.quality));

  // Verify strategy is set
  final strategy = await player.abr.strategy;
  testLog("Current ABR strategy: ${strategy.type}");
  expect(strategy.type, equals(AbrStrategyType.quality));

  testLog("Setting THEOlive source");
  player.source = SourceDescription(sources: [
    TheoLiveSource(src: "38yyniscxeglzr8n0lbku57b0"),
  ]);

  // Wait just enough for initial track selection - ABR strategy only affects initial selection
  await tester.pumpAndSettle(const Duration(seconds: 3));

  // Verify video tracks are available
  expect(player.videoTracks.length, greaterThan(0));
  final videoTrack = player.videoTracks[0];
  expect(videoTrack.qualities.length, greaterThan(0));

  // Get player view size in physical pixels (native SDK uses physical pixels)
  final viewSize = tester.getSize(chromlessPlayerView);
  final devicePixelRatio = tester.view.devicePixelRatio;
  final physicalHeight = (viewSize.height * devicePixelRatio).toInt();
  testLog("Player view size: ${viewSize.width}x${viewSize.height} (logical), physical height: $physicalHeight");

  // Find the highest quality that fits the physical view height
  int expectedBandwidth = 0;
  for (final quality in videoTrack.qualities) {
    if (quality.height <= physicalHeight && quality.bandwidth > expectedBandwidth) {
      expectedBandwidth = quality.bandwidth;
    }
  }

  // If no quality fits, native SDK picks the lowest (smallest) quality
  if (expectedBandwidth == 0) {
    expectedBandwidth = videoTrack.qualities.first.bandwidth;
    for (final quality in videoTrack.qualities) {
      if (quality.bandwidth < expectedBandwidth) {
        expectedBandwidth = quality.bandwidth;
      }
    }
  }

  testLog("Available qualities:");
  for (final quality in videoTrack.qualities) {
    testLog("  ${quality.width}x${quality.height}, bandwidth=${quality.bandwidth}");
  }

  // With quality strategy, the initial active quality should be the highest fitting the view
  final activeQuality = videoTrack.activeQuality;
  expect(activeQuality, isNotNull, reason: "Active quality should be available after playback starts");
  testLog("Initial active quality: ${activeQuality!.width}x${activeQuality.height}, bandwidth=${activeQuality.bandwidth}");
  testLog("Expected bandwidth (highest fitting view): $expectedBandwidth");

  // Verify the initial active quality matches the expected quality for view size
  expect(activeQuality.bandwidth, equals(expectedBandwidth), reason: "Quality strategy should select the highest bandwidth video quality fitting the view size");
}
