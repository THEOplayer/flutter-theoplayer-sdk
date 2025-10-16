import 'dart:js_interop';

import 'package:theoplayer_platform_interface/track/texttrack/theoplayer_texttrack_events.dart';
import 'package:theoplayer_platform_interface/track/texttrack/theoplayer_texttrack_impl.dart';
import 'package:theoplayer_web/theoplayer_api_event_web.dart';
import 'package:theoplayer_web/theoplayer_api_web.dart';
import 'package:theoplayer_web/utils/js_utils.dart';

class CueImplWeb extends CueImpl {
  final THEOplayerTextTrackCue _nativeTextTrackCue;

  late final enterEventListener;
  late final exitEventListener;
  late final updateEventlistener;

  CueImplWeb(super.id, super.uid, super.startTime, super.endTime, super.content, this._nativeTextTrackCue) {
    enterEventListener = (CueEnterEventJS event) {
      dispatchEvent(CueEnterEvent(cue: this));
    }.toJS;

    exitEventListener = (CueExitEventJS event) {
      dispatchEvent(CueExitEvent(cue: this));
    }.toJS;

    updateEventlistener = (CueUpdateEventJS event) {
      var cue = event.cue;
      update(cue.endTime, jsObjectToJsonString(cue.content) ?? "");
      dispatchEvent(CueUpdateEvent(cue: this));
    }.toJS;

    this._nativeTextTrackCue.addEventListener(TextTrackCueEventTypes.ENTER.toLowerCase(), enterEventListener);
    this._nativeTextTrackCue.addEventListener(TextTrackCueEventTypes.ENTER.toLowerCase(), exitEventListener);
    this._nativeTextTrackCue.addEventListener(TextTrackCueEventTypes.ENTER.toLowerCase(), updateEventlistener);
  }

  void dispose() {
    super.dispose();
    this._nativeTextTrackCue.removeEventListener(TextTrackCueEventTypes.ENTER.toLowerCase(), enterEventListener);
    this._nativeTextTrackCue.removeEventListener(TextTrackCueEventTypes.ENTER.toLowerCase(), exitEventListener);
    this._nativeTextTrackCue.removeEventListener(TextTrackCueEventTypes.ENTER.toLowerCase(), updateEventlistener);
  }
}
