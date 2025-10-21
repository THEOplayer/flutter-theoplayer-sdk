@JS()
library THEOplayer.js;

import 'package:theoplayer_web/theoplayer_api_web.dart';
import 'dart:js_interop';

@JS()
@anonymous
@staticInterop
class SourceChangeEventJS {}

extension SourceChangeEventJSExtension on SourceChangeEventJS {
  external SourceDescription? source;
}

@JS()
@anonymous
@staticInterop
class PlayEventJS {}

extension PlayEventJSExtension on PlayEventJS {
  external double currentTime;
}

@JS()
@anonymous
@staticInterop
class PlayingEventJS {}

extension PlayingEventJSExtension on PlayingEventJS {
  external double currentTime;
}

@JS()
@anonymous
@staticInterop
class PauseEventJS {}

extension PauseEventJSExtension on PauseEventJS {
  external double currentTime;
}

@JS()
@anonymous
@staticInterop
class WaitingEventJS {}

extension WaitingEventJSExtension on WaitingEventJS {
  external double currentTime;
}

@JS()
@anonymous
@staticInterop
class DurationChangeEventJS {}

extension DurationChangeEventJSExtension on DurationChangeEventJS {
  external double duration;
}

@JS()
@anonymous
@staticInterop
class ProgressEventJS {}

extension ProgressEventJSExtension on ProgressEventJS {
  external double currentTime;
}

@JS()
@anonymous
@staticInterop
class TimeUpdateEventJS {}

extension TimeUpdateEventJSExtension on TimeUpdateEventJS {
  external double currentTime;
  external JSDate? currentProgramDateTime;
}

@JS()
@anonymous
@staticInterop
class RateChangeEventJS {}

extension RateChangeEventJSExtension on RateChangeEventJS {
  external double currentTime;
  external double playbackRate;
}

@JS()
@anonymous
@staticInterop
class SeekingEventJS {}

extension SeekingEventJSExtension on SeekingEventJS {
  external double currentTime;
}

@JS()
@anonymous
@staticInterop
class SeekedEventJS {}

extension SeekedEventJSExtension on SeekedEventJS {
  external double currentTime;
}

@JS()
@anonymous
@staticInterop
class VolumeChangeEventJS {}

extension VolumeChangeEventJSExtension on VolumeChangeEventJS {
  external double currentTime;
  external double volume;
}

@JS()
@anonymous
@staticInterop
class ResizeEventJS {}

extension ResizeEventJSExtension on ResizeEventJS {
  external double currentTime;
  external int width;
  external int height;
}

@JS()
@anonymous
@staticInterop
class EndedEventJS {}

extension EndedEventJSExtension on EndedEventJS {
  external double currentTime;
}

@JS()
@anonymous
@staticInterop
class ErrorEventJS {}

extension ErrorEventJSExtension on ErrorEventJS {
  external String error;
}

@JS()
@anonymous
@staticInterop
class DestroyEventJS {}

@JS()
@anonymous
@staticInterop
class ReadyStateChangeEventJS {}

extension ReadyStateChangeEventJSExtension on ReadyStateChangeEventJS {
  external double currentTime;
  external int readyState;
}

@JS()
@anonymous
@staticInterop
class LoadStartEventJS {}

@JS()
@anonymous
@staticInterop
class LoadedMetadataEventJS {}

extension LoadedMetadataEventJSExtension on LoadedMetadataEventJS {
  external double currentTime;
}

@JS()
@anonymous
@staticInterop
class LoadedDataEventJS {}

extension LoadedDataEventJSExtension on LoadedDataEventJS {
  external double currentTime;
}

@JS()
@anonymous
@staticInterop
class CanPlayEventJS {}

extension CanPlayEventJSExtension on CanPlayEventJS {
  external double currentTime;
}

@JS()
@anonymous
@staticInterop
class CanPlayThroughEventJS {}

extension CanPlayThroughEventJSExtension on CanPlayThroughEventJS {
  external double currentTime;
}

@JS()
@anonymous
@staticInterop
class AddAudioTrackEventJS {}

extension AddAudioTrackEventJSExtension on AddAudioTrackEventJS {
  external THEOplayerAudioTrack track;
}

@JS()
@anonymous
@staticInterop
class RemoveAudioTrackEventJS {}

extension RemoveAudioTrackEventJSExtension on RemoveAudioTrackEventJS {
  external THEOplayerAudioTrack track;
}

@JS()
@anonymous
@staticInterop
class AudioTrackListChangeEventJS {}

extension AudioTrackListChangeEventJSExtension on AudioTrackListChangeEventJS {
  external THEOplayerAudioTrack track;
}

@JS()
@anonymous
@staticInterop
class AudioTargetQualityChangedEventJS {}

extension AudioTargetQualityChangedEventJSExtension on AudioTargetQualityChangedEventJS {
  external JSArray<JSAny?> qualities;
  external THEOplayerAudioQuality? quality;
}

@JS()
@anonymous
@staticInterop
class AudioActiveQualityChangedEventJS {}

extension AudioActiveQualityChangedEventJSExtension on AudioActiveQualityChangedEventJS {
  external THEOplayerAudioQuality quality;
}

@JS()
@anonymous
@staticInterop
class AudioQualityUpdateEventJS {}

@JS()
@anonymous
@staticInterop
class AddVideoTrackEventJS {}

extension AddVideoTrackEventJSExtension on AddVideoTrackEventJS {
  external THEOplayerVideoTrack track;
}

@JS()
@anonymous
@staticInterop
class RemoveVideoTrackEventJS {}

extension RemoveVideoTrackEventJSExtension on RemoveVideoTrackEventJS {
  external THEOplayerVideoTrack track;
}

@JS()
@anonymous
@staticInterop
class VideoTrackListChangeEventJS {}

extension VideoTrackListChangeEventJSExtension on VideoTrackListChangeEventJS {
  external THEOplayerVideoTrack track;
}

@JS()
@anonymous
@staticInterop
class VideoTargetQualityChangedEventJS {}

extension VideoTargetQualityChangedEventJSExtension on VideoTargetQualityChangedEventJS {
  external JSArray<JSAny?> qualities;
  external THEOplayerVideoQuality? quality;
}

@JS()
@anonymous
@staticInterop
class VideoActiveQualityChangedEventJS {}

extension VideoActiveQualityChangedEventJSExtension on VideoActiveQualityChangedEventJS {
  external THEOplayerVideoQuality quality;
}

@JS()
@anonymous
@staticInterop
class VideoQualityUpdateEventJS {}

@JS()
@anonymous
@staticInterop
class AddTextTrackEventJS {}

extension AddTextTrackEventJSExtension on AddTextTrackEventJS {
  external THEOplayerTextTrack track;
}

@JS()
@anonymous
@staticInterop
class RemoveTextTrackEventJS {}

extension RemoveTextTrackEventJSExtension on RemoveTextTrackEventJS {
  external THEOplayerTextTrack track;
}

@JS()
@anonymous
@staticInterop
class TextTrackListChangeEventJS {}

extension TextTrackListChangeEventJSExtension on TextTrackListChangeEventJS {
  external THEOplayerTextTrack track;
}

@JS()
@anonymous
@staticInterop
class TextTrackAddCueEventJS {}

extension TextTrackAddCueEventJSExtension on TextTrackAddCueEventJS {
  external THEOplayerTextTrack track;
  external THEOplayerTextTrackCue cue;
}

@JS()
@anonymous
@staticInterop
class TextTrackRemoveCueEventJS {}

extension TextTrackRemoveCueEventJSExtension on TextTrackRemoveCueEventJS {
  external THEOplayerTextTrack track;
  external THEOplayerTextTrackCue cue;
}

@JS()
@anonymous
@staticInterop
class TextTrackEnterCueEventJS {}

extension TextTrackEnterCueEventJSExtension on TextTrackEnterCueEventJS {
  external THEOplayerTextTrackCue cue;
}

@JS()
@anonymous
@staticInterop
class TextTrackExitCueEventJS {}

extension TextTrackExitCueEventJSExtension on TextTrackExitCueEventJS {
  external THEOplayerTextTrackCue cue;
}

@JS()
@anonymous
@staticInterop
class TextTrackCueChangeEventJS {}

extension TextTrackCueChangeEventJSExtension on TextTrackCueChangeEventJS {
  external THEOplayerTextTrack track;
}

@JS()
@anonymous
@staticInterop
class TextTrackChangeEventJS {}

extension TextTrackChangeEventJSExtension on TextTrackChangeEventJS {
  external THEOplayerTextTrack track;
}

@JS()
@anonymous
@staticInterop
class CueEnterEventJS {}

extension CueEnterEventJSExtension on CueEnterEventJS {
  external THEOplayerTextTrackCue cue;
}

@JS()
@anonymous
@staticInterop
class CueExitEventJS {}

extension CueExitEventJSExtension on CueExitEventJS {
  external THEOplayerTextTrackCue cue;
}

@JS()
@anonymous
@staticInterop
class CueUpdateEventJS {}

extension CueUpdateEventJSExtension on CueUpdateEventJS {
  external THEOplayerTextTrackCue cue;
}

//THEOlive events

@JS()
@anonymous
@staticInterop
class EndpointLoadedEventJS {}

extension EndpointLoadedEventJExtension on EndpointLoadedEventJS {
  external EndpointJS endpoint;
}

@JS()
@anonymous
@staticInterop
class EndpointJS {}

extension EndpointJSExtension on EndpointJS {
  external String? get hespSrc;
  external String? get hlsSrc;
  external String? get adSrc;
  external String? get daiAssetKey;
  external String? get cdn;
  external int get weight;
  external int get priority;
  external DistributionContentProtectionConfigurationJS? get contentProtection;
}

@JS()
@anonymous
@staticInterop
class DistributionContentProtectionConfigurationJS {}

extension DistributionContentProtectionConfigurationJSExtension on DistributionContentProtectionConfigurationJS {
  external String get integration;
  external WidevineDistributionContentProtectionConfigurationJS? get widevine;
  external PlayReadyDistributionContentProtectionConfigurationJS? get playready;
  external FairplayDistributionContentProtectionConfigurationJS? get fairplay;
}

@JS()
@anonymous
@staticInterop
class WidevineDistributionContentProtectionConfigurationJS {}

extension WidevineDistributionContentProtectionConfigurationJSExtension on WidevineDistributionContentProtectionConfigurationJS {
  external String get licenseUrl;
}

@JS()
@anonymous
@staticInterop
class PlayReadyDistributionContentProtectionConfigurationJS {}

extension PlayReadyDistributionContentProtectionConfigurationJSExtension on PlayReadyDistributionContentProtectionConfigurationJS {
  external String get licenseUrl;
}

@JS()
@anonymous
@staticInterop
class FairplayDistributionContentProtectionConfigurationJS {}

extension FairplayDistributionContentProtectionConfigurationJSExtension on FairplayDistributionContentProtectionConfigurationJS {
  external String get licenseUrl;
  external String get certificateUrl;
}

@JS()
@anonymous
@staticInterop
class DistributionLoadStartEventJS {}

extension PublicationLoadStartEventJSExtension on DistributionLoadStartEventJS {
  external String distributionId;
}

@JS()
@anonymous
@staticInterop
class DistributionOfflineEventJS {}

extension DistributionOfflineEventJSExtension on DistributionOfflineEventJS {
  external String distributionId;
}

@JS()
@anonymous
@staticInterop
class IntentToFallbackEventJS {}

@JS()
@anonymous
@staticInterop
class EnterBadNetworkModeEventJS {}

@JS()
@anonymous
@staticInterop
class ExitBadNetworkModeEventJS {}