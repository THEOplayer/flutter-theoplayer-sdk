import 'package:pigeon/pigeon.dart';

import '../models/track_enums.dart';

@HostApi()
abstract class THEOplayerNativeTextTracksAPI {
  void setMode(int textTrackUid, TextTrackMode mode);
}

@FlutterApi()
abstract class THEOplayerFlutterTextTracksAPI {
  // TextTrackList events
  void onAddTextTrack(
      String? id,
      int uid,
      String? label,
      String? language,
      String? kind,
      String? inBandMetadataTrackDispatchType,
      TextTrackReadyState readyState,
      TextTrackType type,
      String? source,
      bool isForced,
      TextTrackMode mode);

  void onRemoveTextTrack(int uid);

  void onTextTrackListChange(int uid);

  // TextTrack events
  void onTextTrackAddCue(int textTrackUid, String id, int uid, double startTime, double endTime, String content);

  void onTextTrackRemoveCue(int textTrackUid, int cueUid);

  void onTextTrackEnterCue(int textTrackUid, int cueUid);

  void onTextTrackExitCue(int textTrackUid, int cueUid);

  void onTextTrackCueChange(int textTrackUid);

  void onTextTrackChange(int textTrackUid);

  // Cue events
  void onCueEnter(int textTrackUid, int cueUid);

  void onCueExit(int textTrackUid, int cueUid);

  void onCueUpdate(int textTrackUid, int cueUid, double endTime, String content);
}
