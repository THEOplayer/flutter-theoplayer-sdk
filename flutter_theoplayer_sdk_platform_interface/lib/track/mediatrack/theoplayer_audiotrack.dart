import 'package:theoplayer_platform_interface/theoplayer_event_dispatcher_interface.dart';
import 'package:theoplayer_platform_interface/theoplayer_events.dart';
import 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_mediatrack.dart';

abstract class AudioTracks extends MediaTracks<AudioTrack> {

  /// Add the given listener for the given [AudioTracksEventTypes] type(s).
  @override
  void addEventListener(String eventType, EventListener<Event> listener);

  /// Remove the given listener for the given [AudioTracksEventTypes] type(s).
  @override
  void removeEventListener(String eventType, EventListener<Event> listener);
}

abstract class AudioTrack extends MediaTrack<AudioQuality, AudioQualities> {
  AudioTrack(super.id, super.uid, super.label, super.language, super.kind, super.qualities);
}

abstract class AudioQualities extends Qualities<AudioQuality> {}

abstract class AudioQuality extends Quality {
  AudioQuality(super.id, super.uid);

  int get audioSamplingRate;
}
