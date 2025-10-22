@JS()
library THEOplayer.js;

import 'dart:js_interop';
import 'package:web/web.dart';

void initializeTHEOplayer() {
  //prepare for initialization
}

//TODO: check if we can properly generate interfaces via js_bindings or typings from TS.

@JS("THEOplayer")
@staticInterop
class THEOplayer {}

@JS("THEOplayer.players")
external JSArray<JSAny?> get theoplayerPlayers;

extension THEOplayerExtension on THEOplayer {}

@JS()
@anonymous
@staticInterop
class THEOplayerEventListener {}

extension THEOplayerEventListenerExtension on THEOplayerEventListener {
  external void addEventListener(String eventType, JSFunction fn);
  external void removeEventListener(String eventType, JSFunction fn);
}

@JS("THEOplayer.ChromelessPlayer")
@staticInterop
class THEOplayerJS implements THEOplayerEventListener {
  external factory THEOplayerJS(HTMLElement videoElement, THEOplayerConfigParams theoPlayerConfig);
}

extension THEOplayerJSExtension on THEOplayerJS {
  external void play();
  external void pause();
  external void stop();

  external bool muted;
  external bool autoplay;
  external double currentTime;
  external SourceDescription source;
  external JSDate? currentProgramDateTime;
  external double playbackRate;
  external double get duration;
  external bool get paused;
  external String preload;
  external int readyState;
  external double volume;
  external bool ended;
  external bool seeking;
  external int get videoHeight;
  external int get videoWidth;
  external THEOplayerError? get error;

  external THEOplayerTimeRanges get seekable;
  external THEOplayerTimeRanges get played;
  external THEOplayerTimeRanges get buffered;

  external THEOplayerArrayList<THEOplayerTextTrack> get textTracks;
  external THEOplayerArrayList<THEOplayerAudioTrack> get audioTracks;
  external THEOplayerArrayList<THEOplayerVideoTrack> get videoTracks;

  external THEOplayerTheoLiveApi? get theoLive;
}

@JS("Date")
@anonymous
@staticInterop
//NOTE: similar to DateTime in JS, but that object doesn't work, so we create our own representation
class JSDate {
  external factory JSDate({required int epoch});
}

extension JSDateExtension on JSDate {
  external int getTime();
}

@JS()
@anonymous
@staticInterop
//NOTE: similar to TimeRanges, but that object doesn't work, so we create our own representation
class THEOplayerTimeRanges {
  external factory THEOplayerTimeRanges();
}

extension THEOplayerTimeRangesExtension on THEOplayerTimeRanges {
  external int get length;
  external JSAny? start(int index);
  external JSAny? end(int index);
}

@JS()
@anonymous
@staticInterop
class THEOplayerError {
  external factory THEOplayerError({
    String message,
    int code,
    String cause,
    String stack,
  });
}

extension THEOplayerErrorExtension on THEOplayerError {
  external String get message;
}

@JS()
@anonymous
@staticInterop
class THEOplayerConfigParams {
  external factory THEOplayerConfigParams({
    String? libraryLocation,
    String? license,
    String? licenseUrl,
    TheoLiveConfig? theoLive,
  });
}

@JS()
@anonymous
@staticInterop
class TheoLiveConfig {
  external factory TheoLiveConfig({
      String? externalSessionId,
      bool? fallbackEnabled,
      String? discoveryUrl,
  });
}

@JS()
@anonymous
@staticInterop
class SourceDescription {
  external factory SourceDescription({required JSArray<JSAny?> sources});
}

extension SourceDescriptionExtension on SourceDescription {
  external JSArray<JSAny?> get sources;
}

@JS()
@anonymous
@staticInterop
class TypedSource {
  external factory TypedSource({ required String src, 
    String? type,
    ContentProtection? contentProtection,
    String? integration
  });
}

extension TypedSourceExtension on TypedSource {
  external String? get integration; // theolive,
  external String get src;
  external String? get type;
  external ContentProtection? get contentProtection;
}

@JS()
@anonymous
@staticInterop
class ContentProtection {
  external factory ContentProtection({
    WidevineContentProtectionConfiguration? widevine,
    FairplayContentProtectionConfiguration? fairplay

  });
}

extension ContentProtectionExtension on ContentProtection {
  external WidevineContentProtectionConfiguration? get widevine;
  external FairplayContentProtectionConfiguration? get fairplay;
}

@JS()
@anonymous
@staticInterop
class WidevineContentProtectionConfiguration {
  external factory WidevineContentProtectionConfiguration({
    String licenseAcquisitionURL
  });
}

extension WidevineContentProtectionConfigurationExtension on WidevineContentProtectionConfiguration {
  external String get licenseAcquisitionURL;
}

@JS()
@anonymous
@staticInterop
class FairplayContentProtectionConfiguration {
  external factory FairplayContentProtectionConfiguration({
    String licenseAcquisitionURL,
    String certificateURL
  });
}

extension FairplayContentProtectionConfigurationExtension on FairplayContentProtectionConfiguration {
  external String get licenseAcquisitionURL;
  external String get certificateURL;
}

@JS()
@anonymous
@staticInterop
class THEOplayerArrayList<T> implements THEOplayerEventListener {}

extension THEOplayerArrayListExtension<T> on THEOplayerArrayList<T> {
  external int get length;
  external JSAny? item(int index);
}

@JS()
@anonymous
@staticInterop
class THEOplayerTextTrackCueList<THEOplayerTextTrackCue> {}

extension THEOplayerTextTrackCueListExtension<THEOplayerTextTrackCue> on THEOplayerTextTrackCueList<THEOplayerTextTrackCue> {
  external int get length;
  external JSAny? item(int index);
}

@JS()
@anonymous
@staticInterop
class THEOplayerTextTrack implements THEOplayerEventListener {}

extension THEOplayerTextTrackExtension on THEOplayerTextTrack {
  external String? get id;
  external int get uid;
  external String get label;
  external String get kind;
  external String get language;
  external String get inBandMetadataTrackDispatchType;
  external String mode; // enum
  external int get readyState; //enum
  external String get type; // enum
  external String get src;
  external bool get forced;
  external THEOplayerTextTrackCueList? activeCues;
  external THEOplayerTextTrackCueList? cues;
}

@JS()
@anonymous
@staticInterop
class THEOplayerTextTrackCue implements THEOplayerEventListener {}

extension THEOplayerTextTrackCueExtension on THEOplayerTextTrackCue {
  external String get id;
  external int get uid;
  external double get startTime;
  external double get endTime;
  external JSAny? get content;

  external THEOplayerTextTrack track;
}

@JS()
@anonymous
@staticInterop
abstract class THEOplayerMediaTrack<T> implements THEOplayerEventListener {}

extension THEOplayerMediaTrackExtension<T> on THEOplayerMediaTrack<T> {
  external bool enabled;
  external String get id;
  external int get uid;
  external String get kind; //enum
  external String label;
  external String language;

  external JSAny? activeQuality;
  external JSArray<JSAny?> qualities;
  external JSArray<JSAny?>? targetQuality;
}

@JS()
@anonymous
@staticInterop
class THEOplayerAudioTrack implements THEOplayerMediaTrack<THEOplayerAudioQuality> {}

@JS()
@anonymous
@staticInterop
class THEOplayerVideoTrack implements THEOplayerMediaTrack<THEOplayerVideoQuality> {}

@JS()
@anonymous
@staticInterop
abstract class THEOplayerMediaQuality implements THEOplayerEventListener {}

extension THEOplayerMediaQualityExtension on THEOplayerMediaQuality {
  external String get id;
  external int get uid;
  external String get name;
  external String label;
  external bool get available;
  external int get averageBandwidth;
  external int get bandwidth;
  external String get codecs;
}

@JS()
@anonymous
@staticInterop
class THEOplayerAudioQuality implements THEOplayerMediaQuality {}

extension THEOplayerAudioQualityExtension on THEOplayerAudioQuality {
  external int get audioSamplingRate;
}

@JS()
@anonymous
@staticInterop
class THEOplayerVideoQuality implements THEOplayerMediaQuality {}

extension THEOplayerVideoQualityExtension on THEOplayerVideoQuality {
  external int get height;
  external int get width;
  external double get frameRate;
  external double get firstFrame;
}

// API for https://www.theoplayer.com/docs/theoplayer/v8/api-reference/web/interfaces/TheoLiveApi.html
// Porting changes from https://github.com/THEOplayer/flutter-theolive-sdk/blob/develop/flutter_theolive_sdk_platform_interface/pigeons/apis/theolive_host_api.dart
@JS()
@anonymous
@staticInterop
class THEOplayerTheoLiveApi implements THEOplayerEventListener {}

extension THEOplayerTheoLiveApiExtension on THEOplayerTheoLiveApi {
  external bool badNetworkMode;
  external JSAny? preloadPublications(JSArray<JSAny?> publicationIds);
}