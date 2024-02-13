import 'package:theoplayer_platform_interface/theoplayer_event_dispatcher_interface.dart';
import 'package:theoplayer_platform_interface/theoplayer_events.dart';
import 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_mediatrack.dart';

abstract class VideoTracks extends MediaTracks<VideoTrack> {
  /// Add the given listener for the given [VideoTracksEventTypes] type(s).
  @override
  void addEventListener(String eventType, EventListener<Event> listener);

  /// Remove the given listener for the given [VideoTracksEventTypes] type(s).
  @override
  void removeEventListener(String eventType, EventListener<Event> listener);
}

abstract class VideoTrack extends MediaTrack<VideoQuality, VideoQualities> {
  VideoTrack(super.id, super.uid, super.label, super.language, super.kind, super.qualities);
}

abstract class VideoQualities extends Qualities<VideoQuality> {}

abstract class VideoQuality extends Quality {
  VideoQuality(super.id, super.uid);

  int get width;

  int get height;

  double get frameRate;

  double get firstFrame;
}
