import 'package:theoplayer_platform_interface/theoplayer_events.dart';
import 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_audiotrack.dart';

class AudioTracksEventTypes {
  static const ADDTRACK = "ADDTRACK";
  static const REMOVETRACK = "REMOVETRACK";
  static const CHANGE = "CHANGE";
}

class AudioTrackEventTypes {
  static const TARGETQUALITYCHANGED = "TARGETQUALITYCHANGED";
  static const ACTIVEQUALITYCHANGED = "ACTIVEQUALITYCHANGED";
}

class AudioQualityEventTypes {
  static const UPDATE = "UPDATE";
}

class AddAudioTrackEvent extends Event {
  final AudioTrack track;

  AddAudioTrackEvent({required this.track}) : super(type: AudioTracksEventTypes.ADDTRACK);
}

class RemoveAudioTrackEvent extends Event {
  final AudioTrack track;

  RemoveAudioTrackEvent({required this.track}) : super(type: AudioTracksEventTypes.REMOVETRACK);
}

class AudioTrackListChangeEvent extends Event {
  final AudioTrack track;

  AudioTrackListChangeEvent({required this.track}) : super(type: AudioTracksEventTypes.CHANGE);
}

class AudioTargetQualityChangedEvent extends Event {
  final AudioQualities qualities;
  final AudioQuality? quality;

  AudioTargetQualityChangedEvent({required this.qualities, required this.quality}) : super(type: AudioTrackEventTypes.TARGETQUALITYCHANGED);
}

class AudioActiveQualityChangedEvent extends Event {
  final AudioQuality quality;

  AudioActiveQualityChangedEvent({required this.quality}) : super(type: AudioTrackEventTypes.ACTIVEQUALITYCHANGED);
}

class AudioQualityUpdateEvent extends Event {
  AudioQualityUpdateEvent() : super(type: AudioQualityEventTypes.UPDATE);
}
