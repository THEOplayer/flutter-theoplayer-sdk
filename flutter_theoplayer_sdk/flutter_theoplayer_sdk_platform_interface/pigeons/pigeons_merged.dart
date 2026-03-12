import 'package:pigeon/pigeon.dart';

// run in the `flutter_theoplayer_sdk_platform_interface` folder:
// dart run build_runner build --delete-conflicting-outputs

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/pigeon/apis.g.dart',
  dartOptions: DartOptions(),
  kotlinOut: '../flutter_theoplayer_sdk_android/android/src/main/kotlin/com/theoplayer/flutter/pigeon/APIs.g.kt',
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
  daterange,
  timecode;
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
  final List<TypedSourcePigeon?> sources;

  SourceDescription({required this.sources});
}

///
/// Internal TypedSource Pigeon for Android/iOS communication
/// Remarks:
/// * Internal type, don't use it, it will be removed.
///
class TypedSourcePigeon {
  final String src;
  final String? type;
  final DRMConfiguration? drm;
  final SourceIntegrationId? integration;
  final Map<String?, String?>? headers;

  TypedSourcePigeon({required this.src, this.type, this.drm, this.integration, this.headers});
}

enum SourceIntegrationId {
  theolive,
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
  void onAddTextTrack(String? id, int uid, String? label, String? language, String? kind, String? inBandMetadataTrackDispatchType, TextTrackReadyState readyState, TextTrackType type, String? source,
      bool isForced, TextTrackMode mode, String? unlocalizedLabel);

  void onRemoveTextTrack(int uid);

  void onTextTrackListChange(int uid);

  // TextTrack events
  void onTextTrackAddCue(int textTrackUid, String id, int uid, double startTime, double endTime, String content);

  void onTextTrackAddDateRangeCue(int textTrackUid, String id, int uid, double startTime, double endTime, String? cueClass, double startDateMillis, double? endDateMillis, double? duration,
      double? plannedDuration, bool endOnNext, String? customAttributesJson);

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



class HespLatencies {
  final double? engineLatency;
  final double? distributionLatency;
  final double? playerLatency;
  final double? theoliveLatency;

  HespLatencies(this.engineLatency, this.distributionLatency, this.playerLatency, this.theoliveLatency);
}

@HostApi()
abstract class THEOplayerNativeTHEOliveAPI {
  void goLive();
  void preloadChannels(List<String>? channelIds);
  @async
  double? currentLatency();
  @async
  HespLatencies? latencies();
}

@FlutterApi()
abstract class THEOplayerFlutterTHEOliveAPI {
  void onDistributionLoadStartEvent(String distributionId);
  void onEndpointLoadedEvent(Endpoint endpoint);
  void onDistributionOfflineEvent(String distributionId);
  void onIntentToFallbackEvent(String? errorCode, String? errorMessage);
  //experimental API for iOS-only
  void onSeeking(double currentTime);
  void onSeeked(double currentTime);
}

class Endpoint {
  final String? hespSrc;
  final String? hlsSrc;
  final String? cdn;
  final String? adSrc;
  final double weight;
  final int priority;

  Endpoint(this.hespSrc, this.hlsSrc, this.cdn, this.adSrc, this.weight, this.priority);
}



/// The adaptive bitrate strategy type.
enum AbrStrategyTypePigeon {
  performance,
  quality,
  bandwidth,
}

/// Metadata for the ABR strategy (e.g. initial bitrate cap).
class AbrStrategyMetadataPigeon {
  final int? bitrate;

  AbrStrategyMetadataPigeon({this.bitrate});
}

/// The ABR strategy configuration: type + optional metadata.
class AbrStrategyConfigurationPigeon {
  final AbrStrategyTypePigeon type;
  final AbrStrategyMetadataPigeon? metadata;

  AbrStrategyConfigurationPigeon({required this.type, this.metadata});
}

/// Host API: Dart → Native calls for ABR configuration.
@HostApi()
abstract class THEOplayerNativeAbrAPI {
  /// Get the current ABR strategy.
  AbrStrategyConfigurationPigeon getAbrStrategy();

  /// Set the ABR strategy.
  void setAbrStrategy(AbrStrategyConfigurationPigeon config);

  /// Get the target buffer in seconds.
  double getTargetBuffer();

  /// Set the target buffer in seconds.
  void setTargetBuffer(double value);

  /// Get the preferred peak bitrate in bps (iOS only, returns 0 on other platforms).
  double getPreferredPeakBitRate();

  /// Set the preferred peak bitrate in bps (iOS only, no-op on other platforms).
  void setPreferredPeakBitRate(double value);
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

  void setAllowBackgroundPlayback(bool allowBackgroundPlayback);

  bool allowBackgroundPlayback();

  void setAllowAutomaticPictureInPicture(bool allowAutomaticPictureInPicture);

  bool allowAutomaticPictureInPicture();

  String? getError();

  void stop();

  void dispose();

  // application lifecycle listeners
  void onLifecycleResume();

  void onLifecyclePause();

  void configureSurface(int surfaceId, int width, int height);
}



/// A single debug flag with its metadata and current state.
class DebugFlagPigeon {
  final String key;
  final String description;
  final bool defaultValue;
  final bool isEnabled;

  DebugFlagPigeon({
    required this.key,
    required this.description,
    required this.defaultValue,
    required this.isEnabled,
  });
}

/// Host API: Dart → Native calls for debug flag management.
@HostApi()
abstract class THEOplayerNativeDebugFlagsAPI {
  /// Returns all available debug flags with their current state.
  List<DebugFlagPigeon> getAvailableFlags();

  /// Enable a flag by key.
  void enableFlag(String key);

  /// Disable a flag by key.
  void disableFlag(String key);

  /// Enable all flags.
  void enableAll();

  /// Disable all flags.
  void disableAll();

  /// Reset all flags to their compile-time defaults.
  void resetAll();

  /// Enable OS log + file logging at runtime (iOS only, no-op on Android).
  void enableFileLogging();
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
  void onAddVideoTrack(String? id, int uid, String? label, String? language, String? kind, bool isEnabled, String? unlocalizedLabel);

  // helper to populate the qualities in the video track
  void onVideoTrackAddQuality(int videoTrackUid, String qualityId, int qualityUid, String? name, int bandwidth, String? codecs, int width, int height, double frameRate, double firstFrame,
      int? averageBandwidth, bool available);

  void onRemoveVideoTrack(int uid);

  void onVideoTrackListChange(int uid);

  // VideoTrack events
  void onTargetQualityChange(int videoTrackUid, List<int> qualitiesUid, int? qualityUid);

  void onActiveQualityChange(int videoTrackUid, int qualityUid);

  // Quality events
  void onQualityUpdate(
      int videoTrackUid, int qualityUid, String? name, int bandwidth, String? codecs, int width, int height, double frameRate, double firstFrame, int? averageBandwidth, bool available);
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
  void onAddAudioTrack(String? id, int uid, String? label, String? language, String? kind, bool isEnabled, String? unlocalizedLabel);

  // helper to populate the qualities in the audio track
  void onAudioTrackAddQuality(int audioTrackUid, String qualityId, int qualityUid, String? name, int bandwidth, String? codecs, int audioSamplingRate, int? averageBandwidth, bool available);

  void onRemoveAudioTrack(int uid);

  void onAudioTrackListChange(int uid);

  // AudioTrack events
  void onTargetQualityChange(int audioTrackUid, List<int> qualitiesUid, int? qualityUid);

  void onActiveQualityChange(int audioTrackUid, int qualityUid);

  // Quality events
  void onQualityUpdate(int audioTrackUid, int qualityUid, String? name, int bandwidth, String? codecs, int audioSamplingRate, int? averageBandwidth, bool available);
}

