import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:theoplayer_platform_interface/pigeon/apis.g.dart';
import 'package:theoplayer_platform_interface/track/texttrack/theoplayer_texttrack.dart';
import 'package:theoplayer_platform_interface/track/texttrack/theoplayer_texttrack_events.dart';
import 'package:theoplayer_platform_interface/track/texttrack/theoplayer_texttrack_impl.dart';

class THEOplayerFlutterTextTracksAPIImpl implements THEOplayerFlutterTextTracksAPI {
  late final THEOplayerNativeTextTracksAPI _nativeTextTrackAPI;
  late final TextTracksImpl _textTracks;

  THEOplayerFlutterTextTracksAPIImpl({BinaryMessenger? binaryMessenger}) {
    THEOplayerFlutterTextTracksAPI.setUp(this, binaryMessenger: binaryMessenger);
    _nativeTextTrackAPI = THEOplayerNativeTextTracksAPI(binaryMessenger: binaryMessenger);
    _textTracks = TextTracksImpl();
  }

  TextTracks getTextTracks() {
    return _textTracks;
  }

  @override
  void onAddTextTrack(String? id,
      int uid,
      String? label,
      String? language,
      String? kind,
      String? inBandMetadataTrackDispatchType,
      TextTrackReadyState readyState,
      TextTrackType type,
      String? source,
      bool isForced,
      TextTrackMode mode,
      String? unlocalizedLabel) {
    TextTrack textTrack = TextTrackImplMobile(
        id,
        uid,
        label,
        language,
        kind,
        inBandMetadataTrackDispatchType,
        readyState,
        type,
        Cues(),
        Cues(),
        source,
        isForced,
        mode,
        _nativeTextTrackAPI);
    _textTracks.add(textTrack);
    _textTracks.dispatchEvent(AddTextTrackEvent(track: textTrack));
  }

  @override
  void onRemoveTextTrack(int uid) {
    TextTrack? textTrack = _textTracks.firstWhereOrNull((item) => item.uid == uid);
    if (textTrack == null) {
      return;
    }

    _textTracks.remove(textTrack);
    _textTracks.dispatchEvent(RemoveTextTrackEvent(track: textTrack));
  }

  @override
  void onTextTrackListChange(int uid) {
    TextTrack? textTrack = _textTracks.firstWhereOrNull((item) => item.uid == uid);
    if (textTrack == null) {
      return;
    }

    _textTracks.dispatchEvent(TextTrackListChangeEvent(track: textTrack));
  }

  @override
  void onTextTrackAddCue(int textTrackUid, String id, int uid, double startTime, double endTime, String content) {
    TextTrack? textTrack = _textTracks.firstWhereOrNull((item) => item.uid == textTrackUid);
    if (textTrack == null) {
      return;
    }

    Cue cue = CueImpl(id, uid, startTime, endTime, content);
    textTrack.cues.add(cue);
    (textTrack as TextTrackImpl).dispatchEvent(TextTrackAddCueEvent(track: textTrack, cue: cue));
  }

  @override
  void onTextTrackAddDateRangeCue(int textTrackUid, String id, int uid, double startTime, double endTime, String? cueClass, double startDateMillis, double? endDateMillis, double? duration, double? plannedDuration, bool endOnNext, String? customAttributesJson) {
    TextTrack? textTrack = _textTracks.firstWhereOrNull((item) => item.uid == textTrackUid);
    if (textTrack == null) {
      return;
    }

    Map<String, dynamic>? customAttributes;
    if (customAttributesJson != null) {
      customAttributes = json.decode(customAttributesJson) as Map<String, dynamic>;
    }

    Cue cue = DateRangeCueImpl(
        id,
        uid,
        startTime,
        endTime,
        DateTime.fromMillisecondsSinceEpoch(startDateMillis.toInt()),
        endDateMillis != null ? DateTime.fromMillisecondsSinceEpoch(endDateMillis.toInt()) : null,
        duration,
        plannedDuration,
        cueClass,
        endOnNext,
        customAttributes);
    textTrack.cues.add(cue);
    (textTrack as TextTrackImpl).dispatchEvent(TextTrackAddCueEvent(track: textTrack, cue: cue));
  }

  @override
  void onTextTrackRemoveCue(int textTrackUid, int cueUid) {
    TextTrack? textTrack = _textTracks.firstWhereOrNull((element) => element.uid == textTrackUid);
    Cue? cue = textTrack?.cues.firstWhereOrNull((element) => element.uid == cueUid);
    if (cue == null) {
      return;
    }

    (textTrack as TextTrackImpl).dispatchEvent(TextTrackRemoveCueEvent(track: textTrack, cue: cue));
  }

  @override
  void onTextTrackEnterCue(int textTrackUid, int cueUid) {
    TextTrack? textTrack = _textTracks.firstWhereOrNull((element) => element.uid == textTrackUid);
    Cue? cue = textTrack?.cues.firstWhereOrNull((element) => element.uid == cueUid);
    if (cue == null) {
      return;
    }

    (textTrack as TextTrackImpl).dispatchEvent(TextTrackEnterCueEvent(cue: cue));
  }

  @override
  void onTextTrackExitCue(int textTrackUid, int cueUid) {
    TextTrack? textTrack = _textTracks.firstWhereOrNull((element) => element.uid == textTrackUid);
    Cue? cue = textTrack?.cues.firstWhereOrNull((element) => element.uid == cueUid);
    if (cue == null) {
      return;
    }

    textTrack?.activeCues.remove(cue);
    (textTrack as TextTrackImpl).dispatchEvent(TextTrackExitCueEvent(cue: cue));
  }

  @override
  void onTextTrackCueChange(int textTrackUid) {
    TextTrack? textTrack = _textTracks.firstWhereOrNull((element) => element.uid == textTrackUid);
    if (textTrack == null) {
      return;
    }

    (textTrack as TextTrackImpl).dispatchEvent(TextTrackCueChangeEvent(track: textTrack));
  }

  @override
  void onTextTrackChange(int textTrackUid) {
    TextTrack? textTrack = _textTracks.firstWhereOrNull((element) => element.uid == textTrackUid);
    if (textTrack == null) {
      return;
    }

    (textTrack as TextTrackImpl).dispatchEvent(TextTrackChangeEvent(track: textTrack));
  }

  @override
  void onCueEnter(int textTrackUid, int cueUid) {
    TextTrack? textTrack = _textTracks.firstWhereOrNull((element) => element.uid == textTrackUid);
    Cue? cue = textTrack?.cues.firstWhereOrNull((element) => element.uid == cueUid);
    if (cue == null) {
      return;
    }

    (cue as CueImpl).dispatchEvent(CueEnterEvent(cue: cue));
  }

  @override
  void onCueExit(int textTrackUid, int cueUid) {
    TextTrack? textTrack = _textTracks.firstWhereOrNull((element) => element.uid == textTrackUid);
    Cue? cue = textTrack?.cues.firstWhereOrNull((element) => element.uid == cueUid);
    if (cue == null) {
      return;
    }

    (cue as CueImpl).dispatchEvent(CueExitEvent(cue: cue));
  }

  @override
  void onCueUpdate(int textTrackUid, int cueUid, double endTime, String content) {
    TextTrack? textTrack = _textTracks.firstWhereOrNull((element) => element.uid == textTrackUid);
    CueImpl? cue = textTrack?.cues.firstWhereOrNull((element) => element.uid == cueUid) as CueImpl?;
    if (cue == null) {
      return;
    }

    cue.update(endTime, content);
    cue.dispatchEvent(CueUpdateEvent(cue: cue));
  }

  void dispose() {
    _textTracks.dispose();
  }
}
