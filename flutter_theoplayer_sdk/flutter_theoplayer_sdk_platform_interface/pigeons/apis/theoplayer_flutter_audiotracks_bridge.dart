import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class THEOplayerNativeAudioTracksAPI {
  void setTargetQuality(int audioTrackUid, int? qualityUid);

  void setTargetQualities(int audioTrackUid, List<int>? qualitiesUid);

  void setEnabled(int audioTrackUid, bool enabled);
}

@FlutterApi()
abstract class THEOplayerFlutterAudioTracksAPI {
  // AudioTrackList events
  void onAddAudioTrack(String? id, int uid, String? label, String? language, String? kind, bool isEnabled);

  // helper to populate the qualities in the audio track
  void onAudioTrackAddQuality(int audioTrackUid, String qualityId, int qualityUid, String? name, int bandwidth, String? codecs, int audioSamplingRate);

  void onRemoveAudioTrack(int uid);

  void onAudioTrackListChange(int uid);

  // AudioTrack events
  void onTargetQualityChange(int audioTrackUid, List<int> qualitiesUid, int? qualityUid);

  void onActiveQualityChange(int audioTrackUid, int qualityUid);

  // Quality events
  void onQualityUpdate(int audioTrackUid, int qualityUid, String? name, int bandwidth, String? codecs, int audioSamplingRate);
}
