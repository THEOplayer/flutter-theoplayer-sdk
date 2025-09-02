@JS()
library THEOplayer.js;

import 'package:theoplayer_web/theoplayer_api_web.dart';
import 'dart:js_interop';

@JS()
@anonymous
class SourceChangeEventJS {
  external SourceDescription? source;
}

@JS()
@anonymous
class PlayEventJS {
  external double currentTime;
}

@JS()
@anonymous
class PlayingEventJS {
  external double currentTime;
}

@JS()
@anonymous
class PauseEventJS {
  external double currentTime;
}

@JS()
@anonymous
class WaitingEventJS {
  external double currentTime;
}

@JS()
@anonymous
class DurationChangeEventJS {
  external double duration;
}

@JS()
@anonymous
class ProgressEventJS {
  external double currentTime;
}

@JS()
@anonymous
class TimeUpdateEventJS {
  external double currentTime;
  external JSDate? currentProgramDateTime;
}

@JS()
@anonymous
class RateChangeEventJS {
  external double currentTime;
  external double playbackRate;
}

@JS()
@anonymous
class SeekingEventJS {
  external double currentTime;
}

@JS()
@anonymous
class SeekedEventJS {
  external double currentTime;
}

@JS()
@anonymous
class VolumeChangeEventJS {
  external double currentTime;
  external double volume;
}

@JS()
@anonymous
class ResizeEventJS {
  external double currentTime;
  external int width;
  external int height;
}

@JS()
@anonymous
class EndedEventJS {
  external double currentTime;
}

@JS()
@anonymous
class ErrorEventJS {
  external String error;
}

@JS()
@anonymous
class DestroyEventJS {}

@JS()
@anonymous
class ReadyStateChangeEventJS {
  external double currentTime;
  external int readyState;
}

@JS()
@anonymous
class LoadStartEventJS {}

@JS()
@anonymous
class LoadedMetadataEventJS {
  external double currentTime;
}

@JS()
@anonymous
class LoadedDataEventJS {
  external double currentTime;
}

@JS()
@anonymous
class CanPlayEventJS {
  external double currentTime;
}

@JS()
@anonymous
class CanPlayThroughEventJS {
  external double currentTime;
}

@JS()
@anonymous
class AddAudioTrackEventJS {
  external THEOplayerAudioTrack track;
}

@JS()
@anonymous
class RemoveAudioTrackEventJS {
  external THEOplayerAudioTrack track;
}

@JS()
@anonymous
class AudioTrackListChangeEventJS {
  external THEOplayerAudioTrack track;
}

@JS()
@anonymous
class AudioTargetQualityChangedEventJS {
  external List<THEOplayerAudioQuality> qualities;
  external THEOplayerAudioQuality? quality;
}

@JS()
@anonymous
class AudioActiveQualityChangedEventJS {
  external THEOplayerAudioQuality quality;
}

@JS()
@anonymous
class AudioQualityUpdateEventJS {}

@JS()
@anonymous
class AddVideoTrackEventJS {
  external THEOplayerVideoTrack track;
}

@JS()
@anonymous
class RemoveVideoTrackEventJS {
  external THEOplayerVideoTrack track;
}

@JS()
@anonymous
class VideoTrackListChangeEventJS {
  external THEOplayerVideoTrack track;
}

@JS()
@anonymous
class VideoTargetQualityChangedEventJS {
  external List<THEOplayerVideoQuality> qualities;
  external THEOplayerVideoQuality? quality;
}

@JS()
@anonymous
class VideoActiveQualityChangedEventJS {
  external THEOplayerVideoQuality quality;
}

@JS()
@anonymous
class VideoQualityUpdateEventJS {}

@JS()
@anonymous
class AddTextTrackEventJS {
  external THEOplayerTextTrack track;
}

@JS()
@anonymous
class RemoveTextTrackEventJS {
  external THEOplayerTextTrack track;
}

@JS()
@anonymous
class TextTrackListChangeEventJS {
  external THEOplayerTextTrack track;
}

@JS()
@anonymous
class TextTrackAddCueEventJS {
  external THEOplayerTextTrack track;
  external THEOplayerTextTrackCue cue;
}

@JS()
@anonymous
class TextTrackRemoveCueEventJS {
  external THEOplayerTextTrack track;
  external THEOplayerTextTrackCue cue;
}

@JS()
@anonymous
class TextTrackEnterCueEventJS {
  external THEOplayerTextTrackCue cue;
}

@JS()
@anonymous
class TextTrackExitCueEventJS {
  external THEOplayerTextTrackCue cue;
}

@JS()
@anonymous
class TextTrackCueChangeEventJS {
  external THEOplayerTextTrack track;
}

@JS()
@anonymous
class TextTrackChangeEventJS {
  external THEOplayerTextTrack track;
}

@JS()
@anonymous
class CueEnterEventJS {
  external THEOplayerTextTrackCue cue;
}

@JS()
@anonymous
class CueExitEventJS {
  external THEOplayerTextTrackCue cue;
}

@JS()
@anonymous
class CueUpdateEventJS {
  external THEOplayerTextTrackCue cue;
}

//THEOlive events

@JS()
@anonymous
class PublicationLoadedEventJS {
  external String publicationId;
}

@JS()
@anonymous
class PublicationLoadStartEventJS {
  external String publicationId;
}

@JS()
@anonymous
class PublicationOfflineEventJS {
  external String publicationId;
}

@JS()
@anonymous
class IntentToFallbackEventJS {}

@JS()
@anonymous
class EnterBadNetworkModeEventJS {}

@JS()
@anonymous
class ExitBadNetworkModeEventJS {}