import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:theoplayer/theoplayer.dart';

import '../integration_test_app/test_app.dart';

const daterangeStream = "https://cdn.theoplayer.com/video/star_wars_episode_vii-the_force_awakens_official_comic-con_2015_reel_(2015)/index-daterange.m3u8";

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test daterange cues with HYBRID_COMPOSITION', (WidgetTester tester) async {
    await runDateRangeCueTest(tester, AndroidViewComposition.HYBRID_COMPOSITION);
  });

  // the only difference is on Android
  testWidgets('Test daterange cues with SURFACE_TEXTURE', (WidgetTester tester) async {
    await runDateRangeCueTest(tester, AndroidViewComposition.SURFACE_TEXTURE);
  });

  testWidgets('Test no daterange cues without hlsDateRange flag', (WidgetTester tester) async {
    await runDateRangeDisabledTest(tester, AndroidViewComposition.HYBRID_COMPOSITION);
  });
}

Future<THEOplayer> _preparePlayer(WidgetTester tester, TestApp app) async {
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

  return player;
}

Future<void> runDateRangeCueTest(WidgetTester tester, AndroidViewComposition androidViewComposition) async {
  TestApp app = TestApp(androidViewComposition: androidViewComposition);
  final player = await _preparePlayer(tester, app);

  final dateRangeCueCompleter = Completer<DateRangeCue>();

  player.textTracks.addEventListener(TextTracksEventTypes.ADDTRACK, (event) {
    final track = (event as AddTextTrackEvent).track;
    print("Received text ADDTRACK event, type: ${track.type}");
    if (track.type != TextTrackType.daterange) {
      return;
    }
    track.addEventListener(TextTrackEventTypes.ADDCUE, (cueEvent) {
      final cue = (cueEvent as TextTrackAddCueEvent).cue;
      print("Received daterange ADDCUE event, cue: ${cue.id}");
      if (cue is DateRangeCue && !dateRangeCueCompleter.isCompleted) {
        dateRangeCueCompleter.complete(cue);
      }
    });
  });

  print("Setting daterange source with hlsDateRange enabled");
  player.source = SourceDescription(sources: [
    TypedSource(src: daterangeStream, hlsDateRange: true),
  ]);

  await tester.pumpAndSettle(const Duration(seconds: 10));

  print("Testing daterange cue received");
  expect(dateRangeCueCompleter.isCompleted, isTrue, reason: "A DateRangeCue should arrive on a daterange text track");

  final cue = await dateRangeCueCompleter.future;
  print("Testing daterange cue fields");
  print("  id: ${cue.id}, uid: ${cue.uid}, startTime: ${cue.startTime}, endTime: ${cue.endTime}");
  print("  startDate: ${cue.startDate}, endDate: ${cue.endDate}, duration: ${cue.duration}, plannedDuration: ${cue.plannedDuration}");
  print("  cueClass: ${cue.cueClass}, endOnNext: ${cue.endOnNext}, customAttributes: ${cue.customAttributes}");
  expect(cue.id, isNotEmpty);
  expect(cue.startTime, isNotNull);
  expect(cue.startDate, isNotNull);
  // open-ended dateranges surface an infinite endTime
  if (cue.endDate == null && cue.duration == null && cue.plannedDuration == null) {
    expect(cue.endTime, double.infinity);
  }

  final dateRangeTracks = player.textTracks.where((track) => track.type == TextTrackType.daterange);
  expect(dateRangeTracks, isNotEmpty);
  print("Testing cue is stored on the track, cue count: ${dateRangeTracks.first.cues.length}");
  expect(dateRangeTracks.first.cues, isNotEmpty);
}

Future<void> runDateRangeDisabledTest(WidgetTester tester, AndroidViewComposition androidViewComposition) async {
  TestApp app = TestApp(androidViewComposition: androidViewComposition);
  final player = await _preparePlayer(tester, app);

  print("Setting daterange source without hlsDateRange");
  player.source = SourceDescription(sources: [
    TypedSource(src: daterangeStream),
  ]);

  await tester.pumpAndSettle(const Duration(seconds: 10));

  final dateRangeTracks = player.textTracks.where((track) => track.type == TextTrackType.daterange);
  print("Testing no daterange cues arrive, daterange track count: ${dateRangeTracks.length}");
  final cueCount = dateRangeTracks.fold(0, (count, track) => count + track.cues.length);
  expect(cueCount, 0, reason: "No DateRangeCues should arrive when hlsDateRange is not enabled");
}
