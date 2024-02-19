import 'package:theoplayer_platform_interface/theoplayer_events.dart';
import 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_videotrack.dart';

class VideoTracksEventTypes {
  static const ADDTRACK = "ADDTRACK";
  static const REMOVETRACK = "REMOVETRACK";
  static const CHANGE = "CHANGE";
}

class VideoTrackEventTypes {
  static const TARGETQUALITYCHANGED = "TARGETQUALITYCHANGED";
  static const ACTIVEQUALITYCHANGED = "ACTIVEQUALITYCHANGED";
}

class VideoQualityEventTypes {
  static const UPDATE = "UPDATE";
}

class AddVideoTrackEvent extends Event {
  final VideoTrack track;

  AddVideoTrackEvent({required this.track}) : super(type: VideoTracksEventTypes.ADDTRACK);
}

class RemoveVideoTrackEvent extends Event {
  final VideoTrack track;

  RemoveVideoTrackEvent({required this.track}) : super(type: VideoTracksEventTypes.REMOVETRACK);
}

class VideoTrackListChangeEvent extends Event {
  final VideoTrack track;

  VideoTrackListChangeEvent({required this.track}) : super(type: VideoTracksEventTypes.CHANGE);
}

class VideoTargetQualityChangedEvent extends Event {
  final VideoQualities qualities;
  final VideoQuality? quality;

  VideoTargetQualityChangedEvent({required this.qualities, required this.quality}) : super(type: VideoTrackEventTypes.TARGETQUALITYCHANGED);
}

class VideoActiveQualityChangedEvent extends Event {
  final VideoQuality quality;

  VideoActiveQualityChangedEvent({required this.quality}) : super(type: VideoTrackEventTypes.ACTIVEQUALITYCHANGED);
}

class VideoQualityUpdateEvent extends Event {
  VideoQualityUpdateEvent() : super(type: VideoQualityEventTypes.UPDATE);
}
