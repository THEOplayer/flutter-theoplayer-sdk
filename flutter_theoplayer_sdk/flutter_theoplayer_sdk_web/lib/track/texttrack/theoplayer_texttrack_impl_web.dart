import 'dart:js_interop';

import 'package:theoplayer_platform_interface/pigeon/apis.g.dart';
import 'package:theoplayer_platform_interface/track/texttrack/theoplayer_texttrack_events.dart';
import 'package:theoplayer_platform_interface/track/texttrack/theoplayer_texttrack.dart';
import 'package:theoplayer_platform_interface/track/texttrack/theoplayer_texttrack_impl.dart';
import 'package:theoplayer_web/theoplayer_api_event_web.dart';
import 'package:theoplayer_web/theoplayer_api_web.dart';
import 'package:theoplayer_web/track/texttrack/theoplayer_texttrackcue_impl_web.dart';
import 'package:theoplayer_web/transformers_web.dart';
import 'package:theoplayer_web/utils/js_utils.dart';

class TextTrackImplWeb extends TextTrackImpl {
  final THEOplayerTextTrack _nativeTextTrack;

  late final addCueEventListener;
  late final removeCueEventListener;
  late final enterCueEventListener;
  late final exitCueEventListener;
  late final changeEventListener;
  late final cueChangeEventListener;

  TextTrackImplWeb(super.id, super.uid, super.label, super.language, super.kind, super.inBandMetadataTrackDispatchType, super.readyState, super.type,
      super.cues, super.activeCues, super.source, super.isForced, super.mode, this._nativeTextTrack) {
    addCueEventListener = ((TextTrackAddCueEventJS event) {
      var cue = event.cue;
      var flutterCue = CueImplWeb(cue.id, cue.uid, cue.startTime, cue.endTime, jsObjectToJsonString(cue.content) ?? "", cue);
      cues.add(flutterCue);
      dispatchEvent(TextTrackAddCueEvent(track: this, cue: flutterCue));
    }).toJS;

    removeCueEventListener = ((TextTrackRemoveCueEventJS event) {
      var cue = event.cue;
      Cue? flutterCue = cues.firstWhereOrNull((item) => item.uid == cue.uid);
      if (flutterCue == null) {
        return;
      }

      cues.remove(flutterCue);
      activeCues.remove(flutterCue);
      dispatchEvent(TextTrackRemoveCueEvent(track: this, cue: flutterCue));
    }).toJS;

    enterCueEventListener = ((TextTrackEnterCueEventJS event) {
      var cue = event.cue;

      Cue? flutterCue = cues.firstWhereOrNull((item) => item.uid == cue.uid);
      if (flutterCue == null) {
        return;
      }

      activeCues.add(flutterCue);
      dispatchEvent(TextTrackEnterCueEvent(cue: flutterCue));
    }).toJS;

    exitCueEventListener = ((TextTrackExitCueEventJS event) {
      var cue = event.cue;

      Cue? flutterCue = cues.firstWhereOrNull((item) => item.uid == cue.uid);
      if (flutterCue == null) {
        return;
      }

      activeCues.remove(flutterCue);
      dispatchEvent(TextTrackExitCueEvent(cue: flutterCue));
    }).toJS;

    cueChangeEventListener = ((TextTrackCueChangeEventJS event) {
      dispatchEvent(TextTrackCueChangeEvent(track: this));
    }).toJS;

    changeEventListener = ((TextTrackChangeEventJS event) {
      dispatchEvent(TextTrackChangeEvent(track: this));
    }).toJS;

    _nativeTextTrack.addEventListener(TextTrackEventTypes.ADDCUE.toLowerCase(), addCueEventListener);
    _nativeTextTrack.addEventListener(TextTrackEventTypes.REMOVECUE.toLowerCase(), removeCueEventListener);
    _nativeTextTrack.addEventListener(TextTrackEventTypes.ENTERCUE.toLowerCase(), enterCueEventListener);
    _nativeTextTrack.addEventListener(TextTrackEventTypes.EXITCUE.toLowerCase(), exitCueEventListener);
    _nativeTextTrack.addEventListener(TextTrackEventTypes.CHANGE.toLowerCase(), changeEventListener);
    _nativeTextTrack.addEventListener(TextTrackEventTypes.CUECHANGE.toLowerCase(), cueChangeEventListener);
  }

  @override
  void setMode(TextTrackMode mode) {
    super.setMode(mode);
    _nativeTextTrack.mode = toTextTrackMode(mode);
  }

  void dispose() {
    super.dispose();
    _nativeTextTrack.removeEventListener(TextTrackEventTypes.ADDCUE.toLowerCase(), addCueEventListener);
    _nativeTextTrack.removeEventListener(TextTrackEventTypes.REMOVECUE.toLowerCase(), removeCueEventListener);
    _nativeTextTrack.removeEventListener(TextTrackEventTypes.ENTERCUE.toLowerCase(), enterCueEventListener);
    _nativeTextTrack.removeEventListener(TextTrackEventTypes.EXITCUE.toLowerCase(), exitCueEventListener);
    _nativeTextTrack.removeEventListener(TextTrackEventTypes.CHANGE.toLowerCase(), changeEventListener);
    _nativeTextTrack.removeEventListener(TextTrackEventTypes.CUECHANGE.toLowerCase(), cueChangeEventListener);

    for (var cue in cues) {
      (cue as CueImplWeb).dispose();
    }

    cues.clear();
    activeCues.clear();
  }
}
