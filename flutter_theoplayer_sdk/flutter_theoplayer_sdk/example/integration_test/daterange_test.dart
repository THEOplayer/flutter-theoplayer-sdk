import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:theoplayer/theoplayer.dart';

import '../integration_test_app/test_app.dart';

const daterangeStream = "https://cdn.theoplayer.com/video/star_wars_episode_vii-the_force_awakens_official_comic-con_2015_reel_(2015)/daterange-test.m3u8";

// First daterange in the stream: starts 10s into the video (PDT 12:36:33 + 10s) and lasts 5s.
const testCueId = "test-010";
const testCueClass = "com.theoplayer.daterange-test";
const testCueStartDate = "2015-07-30T12:36:43.000Z";
const testCueEndDate = "2015-07-30T12:36:48.000Z";
const testCueDurationSeconds = 5.0;

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

Future<void> _pumpUntil(WidgetTester tester, bool Function() condition, {Duration timeout = const Duration(seconds: 60)}) async {
  final end = DateTime.now().add(timeout);
  while (!condition() && DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 500));
  }
}

Future<void> runDateRangeCueTest(WidgetTester tester, AndroidViewComposition androidViewComposition) async {
  TestApp app = TestApp(androidViewComposition: androidViewComposition);
  final player = await _preparePlayer(tester, app);

  DateRangeCue? testCue;
  var enteredTestCue = false;
  var exitedTestCue = false;

  player.textTracks.addEventListener(TextTracksEventTypes.ADDTRACK, (event) {
    final track = (event as AddTextTrackEvent).track;
    print("Received text ADDTRACK event, type: ${track.type}");
    if (track.type != TextTrackType.daterange) {
      return;
    }
    track.addEventListener(TextTrackEventTypes.ADDCUE, (cueEvent) {
      final cue = (cueEvent as TextTrackAddCueEvent).cue;
      print("Received daterange ADDCUE event, cue: ${cue.id}");
      if (cue is DateRangeCue && cue.id == testCueId) {
        testCue = cue;
      }
    });
    track.addEventListener(TextTrackEventTypes.ENTERCUE, (cueEvent) {
      final cue = (cueEvent as TextTrackEnterCueEvent).cue;
      print("Received daterange ENTERCUE event, cue: ${cue.id}");
      if (cue.id == testCueId) {
        enteredTestCue = true;
      }
    });
    track.addEventListener(TextTrackEventTypes.EXITCUE, (cueEvent) {
      final cue = (cueEvent as TextTrackExitCueEvent).cue;
      print("Received daterange EXITCUE event, cue: ${cue.id}");
      if (cue.id == testCueId) {
        exitedTestCue = true;
      }
    });
  });

  print("Setting daterange source with hlsDateRange enabled");
  player.source = SourceDescription(sources: [
    TypedSource(src: daterangeStream, hlsDateRange: true),
  ]);

  await _pumpUntil(tester, () => testCue != null, timeout: const Duration(seconds: 30));
  expect(testCue, isNotNull, reason: "DateRangeCue '$testCueId' should arrive on a daterange text track");

  final cue = testCue!;
  print("Testing daterange cue fields");
  print("  id: ${cue.id}, uid: ${cue.uid}, startTime: ${cue.startTime}, endTime: ${cue.endTime}");
  print("  startDate: ${cue.startDate}, endDate: ${cue.endDate}, duration: ${cue.duration}, plannedDuration: ${cue.plannedDuration}");
  print("  cueClass: ${cue.cueClass}, endOnNext: ${cue.endOnNext}, customAttributes: ${cue.customAttributes}");
  print("  scte35Cmd: ${cue.scte35Cmd?.length}, scte35Out: ${cue.scte35Out?.length}, scte35In: ${cue.scte35In?.length}");

  expect(cue.id, testCueId);
  expect(cue.cueClass, testCueClass);
  expect(cue.startDate.millisecondsSinceEpoch, DateTime.parse(testCueStartDate).millisecondsSinceEpoch);
  expect(cue.endDate?.millisecondsSinceEpoch, DateTime.parse(testCueEndDate).millisecondsSinceEpoch);
  expect(cue.duration, testCueDurationSeconds);
  expect(cue.plannedDuration, testCueDurationSeconds);
  expect(cue.endTime.isFinite, isTrue, reason: "A daterange with END-DATE/DURATION should have a finite endTime");
  expect(cue.endTime - cue.startTime, closeTo(testCueDurationSeconds, 0.1));
  expect(cue.scte35Out, isNotNull, reason: "SCTE35-OUT payload should be forwarded");
  expect(cue.scte35Out, isNotEmpty);
  expect(cue.scte35In, isNotNull, reason: "SCTE35-IN payload should be forwarded");
  expect(cue.scte35In, isNotEmpty);
  expect(cue.customAttributes, isNotNull, reason: "X-COM-* custom attributes should be forwarded");
  expect(cue.customAttributes!.values.map((value) => value.toString()), contains("cue-010"));

  final dateRangeTracks = player.textTracks.where((track) => track.type == TextTrackType.daterange);
  expect(dateRangeTracks, isNotEmpty);
  print("Testing cue is stored on the track, cue count: ${dateRangeTracks.first.cues.length}");
  expect(dateRangeTracks.first.cues.where((trackCue) => trackCue.id == testCueId), isNotEmpty);

  // the cue is active between 10s and 15s of playback
  await _pumpUntil(tester, () => enteredTestCue);
  expect(enteredTestCue, isTrue, reason: "ENTERCUE should fire when playback reaches the daterange start");

  await _pumpUntil(tester, () => exitedTestCue);
  expect(exitedTestCue, isTrue, reason: "EXITCUE should fire when playback passes the daterange end");
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
