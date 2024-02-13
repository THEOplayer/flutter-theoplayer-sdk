import 'package:theoplayer_platform_interface/pigeon/apis.g.dart';

class Event {
  final String type;
  final DateTime date = DateTime.now();
  
  Event({required this.type});
}

class PlayerEventTypes {
  static const SOURCECHANGE = "SOURCECHANGE";
  static const PLAY = "PLAY";
  static const PLAYING = "PLAYING";
  static const PAUSE = "PAUSE";
  static const WAITING = "WAITING";
  static const DURATIONCHANGE = "DURATIONCHANGE";
  static const PROGRESS = "PROGRESS";
  static const TIMEUPDATE = "TIMEUPDATE";
  static const RATECHANGE = "RATECHANGE";
  static const SEEKING = "SEEKING";
  static const SEEKED = "SEEKED";
  static const VOLUMECHANGE = "VOLUMECHANGE";
  static const RESIZE = "RESIZE";
  static const ENDED = "ENDED";
  static const ERROR = "ERROR";
  static const DESTROY = "DESTROY";
  static const READYSTATECHANGE = "READYSTATECHANGE";
  static const LOADSTART = "LOADSTART";
  static const LOADEDMETADATA = "LOADEDMETADATA";
  static const LOADEDDATA = "LOADEDDATA";
  static const CANPLAY = "CANPLAY";
  static const CANPLAYTHROUGH = "CANPLAYTHROUGH";
}

class SourceChangeEvent extends Event {
  final SourceDescription? source;

  SourceChangeEvent({required this.source}) : super(type: PlayerEventTypes.SOURCECHANGE);
}

class PlayEvent extends Event {
  final double currentTime;

  PlayEvent({required this.currentTime}) : super(type: PlayerEventTypes.PLAY);
}

class PlayingEvent extends Event {
  final double currentTime;

  PlayingEvent({required this.currentTime}) : super(type: PlayerEventTypes.PLAYING);
}

class PauseEvent extends Event {
  final double currentTime;

  PauseEvent({required this.currentTime}) : super(type: PlayerEventTypes.PAUSE);
}

class WaitingEvent extends Event {
  final double currentTime;

  WaitingEvent({required this.currentTime}) : super(type: PlayerEventTypes.WAITING);
}

class DurationChangeEvent extends Event {
  final double duration;

  DurationChangeEvent({required this.duration}) : super(type: PlayerEventTypes.DURATIONCHANGE);
}

class ProgressEvent extends Event {
  final double currentTime;

  ProgressEvent({required this.currentTime}) : super(type: PlayerEventTypes.PROGRESS);
}

class TimeUpdateEvent extends Event {
  final double currentTime;
  final int? currentProgramDateTime;

  TimeUpdateEvent({required this.currentTime, required this.currentProgramDateTime}) : super(type: PlayerEventTypes.TIMEUPDATE);
}

class RateChangeEvent extends Event {
  final double currentTime;
  final double playbackRate;

  RateChangeEvent({required this.currentTime, required this.playbackRate}) : super(type: PlayerEventTypes.RATECHANGE);
}

class SeekingEvent extends Event {
  final double currentTime;

  SeekingEvent({required this.currentTime}) : super(type: PlayerEventTypes.SEEKING);
}

class SeekedEvent extends Event {
  final double currentTime;

  SeekedEvent({required this.currentTime}) : super(type: PlayerEventTypes.SEEKED);
}

class VolumeChangeEvent extends Event {
  final double currentTime;
  final double volume;

  VolumeChangeEvent({required this.currentTime, required this.volume}) : super(type: PlayerEventTypes.VOLUMECHANGE);
}

class ResizeEvent extends Event {
  final double currentTime;
  final int width;
  final int height;

  ResizeEvent({required this.currentTime, required this.width, required this.height}) : super(type: PlayerEventTypes.RESIZE);
}

class EndedEvent extends Event {
  final double currentTime;

  EndedEvent({required this.currentTime}) : super(type: PlayerEventTypes.ENDED);
}

class ErrorEvent extends Event {
  final String error;

  ErrorEvent({required this.error}) : super(type: PlayerEventTypes.ERROR);
}

class DestroyEvent extends Event {
  DestroyEvent() : super(type: PlayerEventTypes.DESTROY);
}

class ReadyStateChangeEvent extends Event {
  final double currentTime;
  final ReadyState readyState;

  ReadyStateChangeEvent({required this.currentTime, required this.readyState}) : super(type: PlayerEventTypes.READYSTATECHANGE);
}

class LoadStartEvent extends Event {
  LoadStartEvent() : super(type: PlayerEventTypes.LOADSTART);
}

class LoadedMetadataEvent extends Event {
  final double currentTime;

  LoadedMetadataEvent({required this.currentTime}) : super(type: PlayerEventTypes.LOADEDMETADATA);
}

class LoadedDataEvent extends Event {
  final double currentTime;

  LoadedDataEvent({required this.currentTime}) : super(type: PlayerEventTypes.LOADEDDATA);
}

class CanPlayEvent extends Event {
  final double currentTime;

  CanPlayEvent({required this.currentTime}) : super(type: PlayerEventTypes.CANPLAY);
}

class CanPlayThroughEvent extends Event {
  final double currentTime;

  CanPlayThroughEvent({required this.currentTime}) : super(type: PlayerEventTypes.CANPLAYTHROUGH);
}
