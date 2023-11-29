import 'package:flutter_theoplayer_sdk_platform_interface/theoplayer_events.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/track/texttrack/theoplayer_texttrack.dart';

class TextTracksEventTypes {
  static const ADDTRACK = "ADDTRACK";
  static const REMOVETRACK = "REMOVETRACK";
  static const CHANGE = "CHANGE";
}

class TextTrackEventTypes {
  static const ADDCUE = "ADDCUE";
  static const REMOVECUE = "REMOVECUE";
  static const ENTERCUE = "ENTERCUE";
  static const EXITCUE = "EXITCUE";
  static const CUECHANGE = "CUECHANGE";
  static const CHANGE = "CHANGE";
}

class TextTrackCueEventTypes {
  static const ENTER = "ENTER";
  static const EXIT = "EXIT";
  static const UPDATE = "UPDATE";
}

class AddTextTrackEvent extends Event {
  final TextTrack track;

  AddTextTrackEvent({required this.track}) : super(type: TextTracksEventTypes.ADDTRACK);
}

class RemoveTextTrackEvent extends Event {
  final TextTrack track;

  RemoveTextTrackEvent({required this.track}) : super(type: TextTracksEventTypes.REMOVETRACK);
}

class TextTrackListChangeEvent extends Event {
  final TextTrack track;

  TextTrackListChangeEvent({required this.track}) : super(type: TextTracksEventTypes.CHANGE);
}

class TextTrackAddCueEvent extends Event {
  final TextTrack track;
  final Cue cue;

  TextTrackAddCueEvent({required this.track, required this.cue}) : super(type: TextTrackEventTypes.ADDCUE);
}

class TextTrackRemoveCueEvent extends Event {
  final TextTrack track;
  final Cue cue;

  TextTrackRemoveCueEvent({required this.track, required this.cue}) : super(type: TextTrackEventTypes.REMOVECUE);
}

class TextTrackEnterCueEvent extends Event {
  final Cue cue;

  TextTrackEnterCueEvent({required this.cue}) : super(type: TextTrackEventTypes.ENTERCUE);
}

class TextTrackExitCueEvent extends Event {
  final Cue cue;

  TextTrackExitCueEvent({required this.cue}) : super(type: TextTrackEventTypes.EXITCUE);
}

class TextTrackCueChangeEvent extends Event {
  final TextTrack track;

  TextTrackCueChangeEvent({required this.track}) : super(type: TextTrackEventTypes.CUECHANGE);
}

class TextTrackChangeEvent extends Event {
  final TextTrack track;

  TextTrackChangeEvent({required this.track}) : super(type: TextTrackEventTypes.CHANGE);
}

class CueEnterEvent extends Event {
  final Cue cue;

  CueEnterEvent({required this.cue}) : super(type: TextTrackCueEventTypes.ENTER);
}

class CueExitEvent extends Event {
  final Cue cue;

  CueExitEvent({required this.cue}) : super(type: TextTrackCueEventTypes.EXIT);
}

class CueUpdateEvent extends Event {
  final Cue cue;

  CueUpdateEvent({required this.cue}) : super(type: TextTrackCueEventTypes.UPDATE);
}
