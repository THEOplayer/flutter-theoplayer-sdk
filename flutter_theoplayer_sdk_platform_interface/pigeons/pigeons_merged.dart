import 'package:pigeon/pigeon.dart';

// 1. run in the root folder: dart run build_runner build --delete-conflicting-outputs
//run in the root folder: flutter pub run pigeon --input pigeons/pigeons_merged.dart

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/pigeon/apis.g.dart',
  dartOptions: DartOptions(),
  kotlinOut: '../flutter_theoplayer_sdk_android/android/src/main/kotlin/com/theoplayer/theoplayer/pigeon/APIs.g.kt',
  kotlinOptions: KotlinOptions(
      package: 'com.theoplayer.flutter.pigeon'
  ),
  swiftOut: '../flutter_theoplayer_sdk_ios/ios/Classes/pigeon/APIs.g.swift',
  swiftOptions: SwiftOptions(),
  dartPackageName: 'theoplayer_platform_interface',
))

enum ReadyState {
  have_nothing,
  have_metadata,
  have_current_data,
  have_future_data,
  have_enough_data;
}

enum TextTrackMode {
  disabled,
  hidden,
  showing;
}

enum TextTrackType {
  none,
  srt,
  ttml,
  webvtt,
  emsg,
  eventstream,
  id3,
  cea608,
  daterange;
}

enum TextTrackReadyState {
  none,
  loading,
  loaded,
  error;
}

class TimeRange {
  final double start;
  final double end;

  const TimeRange({required this.start, required this.end});
}

enum PreloadType {
  none,
  auto,
  metadata;
}

class SourceDescription {
  final List<TypedSource?> sources;

  const SourceDescription({required this.sources});
}

class TypedSource {
  final String src;
  final DRMConfiguration? drm;

  const TypedSource({required this.src, this.drm});
}

class DRMConfiguration {
  final WidevineDRMConfiguration? widevine;
  final FairPlayDRMConfiguration? fairplay;
  final String? customIntegrationId;
  final Map<String?, String?>? integrationParameters;

  DRMConfiguration({this.widevine, this.fairplay, this.customIntegrationId, this.integrationParameters});
}

class WidevineDRMConfiguration {
  final String licenseAcquisitionURL;
  final Map<String?, String?>? headers;

  WidevineDRMConfiguration({required this.licenseAcquisitionURL, this.headers});
}

class FairPlayDRMConfiguration {
  final String licenseAcquisitionURL;
  final String certificateURL;
  final Map<String?, String?>? headers;

  FairPlayDRMConfiguration({required this.licenseAcquisitionURL, required this.certificateURL, this.headers});
}

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

//Talking to the native
@HostApi()
abstract class THEOplayerNativeAPI {
  void setSource(SourceDescription? source);

  SourceDescription? getSource();

  void setAutoplay(bool autoplay);

  bool isAutoplay();

  void play();

  void pause();

  bool isPaused();

  void setCurrentTime(double currentTime);

  double getCurrentTime();

  void setCurrentProgramDateTime(int currentProgramDateTime);

  int? getCurrentProgramDateTime();

  double getDuration();

  void setPlaybackRate(double playbackRate);

  double getPlaybackRate();

  void setVolume(double volume);

  double getVolume();

  void setMuted(bool muted);

  bool isMuted();

  void setPreload(PreloadType preload);

  PreloadType getPreload();

  ReadyState getReadyState();

  bool isSeeking();

  bool isEnded();

  int getVideoWidth();

  int getVideoHeight();

  List<TimeRange> getBuffered();

  List<TimeRange> getSeekable();

  List<TimeRange> getPlayed();

  String? getError();

  void stop();

  void dispose();
}

//Talking from Native to Dart
@FlutterApi()
abstract class THEOplayerFlutterAPI {
  void onSourceChange(SourceDescription? source);

  void onPlay(double currentTime);

  void onPlaying(double currentTime);

  void onPause(double currentTime);

  void onWaiting(double currentTime);

  void onDurationChange(double duration);

  void onProgress(double currentTime);

  void onTimeUpdate(double currentTime, int? currentProgramDateTime);

  void onRateChange(double currentTime, double playbackRate);

  void onSeeking(double currentTime);

  void onSeeked(double currentTime);

  void onVolumeChange(double currentTime, double volume);

  void onResize(double currentTime, int width, int height);

  void onEnded(double currentTime);

  void onError(String error);

  void onDestroy();

  void onReadyStateChange(double currentTime, ReadyState readyState);

  void onLoadStart();

  void onLoadedMetadata(double currentTime);

  void onLoadedData(double currentTime);

  void onCanPlay(double currentTime);

  void onCanPlayThrough(double currentTime);
}

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
