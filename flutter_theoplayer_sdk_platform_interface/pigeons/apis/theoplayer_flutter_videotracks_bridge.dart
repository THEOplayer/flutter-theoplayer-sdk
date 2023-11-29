import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class THEOplayerNativeVideoTracksAPI {
  void setTargetQuality(int videoTrackUid, int? qualityUid);

  void setTargetQualities(int videoTrackUid, List<int>? qualitiesUid);

  void setEnabled(int videoTrackUid, bool enabled);
}

@FlutterApi()
abstract class THEOplayerFlutterVideoTracksAPI {
  // VideoTrackList events
  void onAddVideoTrack(String? id, int uid, String? label, String? language, String? kind, bool isEnabled);

  // helper to populate the qualities in the video track
  void onVideoTrackAddQuality(int videoTrackUid, String qualityId, int qualityUid, String? name, int bandwidth, String? codecs, int width, int height, double frameRate, double firstFrame);

  void onRemoveVideoTrack(int uid);

  void onVideoTrackListChange(int uid);

  // VideoTrack events
  void onTargetQualityChange(int videoTrackUid, List<int> qualitiesUid, int? qualityUid);

  void onActiveQualityChange(int videoTrackUid, int qualityUid);

  // Quality events
  void onQualityUpdate(int videoTrackUid, int qualityUid, String? name, int bandwidth, String? codecs, int width, int height, double frameRate, double firstFrame);
}
