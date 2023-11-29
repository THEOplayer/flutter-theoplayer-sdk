@JS()
library THEOplayer.js;

import 'dart:html';
import 'package:js/js.dart';

void initializeTHEOplayer() {
  //prepare for initialization
}

//TODO: check if we can properly generate interfaces via js_bindings or typings from TS.

@JS("THEOplayer") 
class THEOplayer {
  external static List<THEOplayerJS> players;
}

@JS()
@anonymous
class THEOplayerEventListener {
  external void addEventListener(String event, fn(event), [dynamic id = ""]);
  external void removeEventListener(String event, fn(event), [dynamic id = ""]);
}

@JS("THEOplayer.ChromelessPlayer")
class THEOplayerJS extends THEOplayerEventListener {
  external THEOplayerJS(HtmlElement videoElement, THEOplayerConfigParams theoPlayerConfig);

  external play();
  external pause();
  external stop();

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

}

@JS("Date")
@anonymous
//NOTE: similar to DateTime in JS, but that object doesn't work, so we create our own representation
class JSDate {
  external JSDate(int epoch);
  external int getTime();
}

@JS()
@anonymous
//NOTE: similar to TimeRanges, but that object doesn't work, so we create our own representation
class THEOplayerTimeRanges {
  external factory THEOplayerTimeRanges();

  external int get length;
  external start(int index);
  external end(int index);

}


@JS()
@anonymous
class THEOplayerError {
  external factory THEOplayerError({
    String message,
    int code,
    String cause,
    String stack,
  });

  external String get message;

}

@JS()
@anonymous
class THEOplayerConfigParams {
  external factory THEOplayerConfigParams({
    String? libraryLocation,
    String? license,
    String? licenseUrl
  });
}

@JS()
@anonymous
class SourceDescription {
  external factory SourceDescription({required List<TypedSource> sources}
  );

  external List<TypedSource> get sources;
}

@JS()
@anonymous
class TypedSource {
  external factory TypedSource({ required String src, 
    String? type,
    ContentProtection? contentProtection
  });

  external String get src;
  external String? get type;
  external ContentProtection? get contentProtection;
}

@JS()
@anonymous
class ContentProtection {
  external factory ContentProtection({
    WidevineContentProtectionConfiguration? widevine,
    FairplayContentProtectionConfiguration? fairplay

  });

  external WidevineContentProtectionConfiguration? get widevine;
  external FairplayContentProtectionConfiguration? get fairplay;

}

@JS()
@anonymous
class WidevineContentProtectionConfiguration {
  external factory WidevineContentProtectionConfiguration({
    String licenseAcquisitionURL
  });

  external String get licenseAcquisitionURL;

}

@JS()
@anonymous
class FairplayContentProtectionConfiguration {

  external factory FairplayContentProtectionConfiguration({
    String licenseAcquisitionURL,
    String certificateURL
  });

  external String get licenseAcquisitionURL;
  external String get certificateURL;

}

@JS()
@anonymous
class THEOplayerArrayList<T> extends THEOplayerEventListener{

  external int get length;
  external T item(int index);

}

@JS()
@anonymous
class THEOplayerTextTrackCueList<THEOplayerTextTrackCue>{

  external int get length;
  external THEOplayerTextTrackCue item(int index);

}

@JS()
@anonymous
class THEOplayerTextTrack extends THEOplayerEventListener {

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
class THEOplayerTextTrackCue extends THEOplayerEventListener {

  external String get id;
  external int get uid;
  external double get startTime;
  external double get endTime;
  external dynamic get content;

  external THEOplayerTextTrack track;

}

@JS()
@anonymous
abstract class THEOplayerMediaTrack<T> extends THEOplayerEventListener {

  external bool enabled;
  external String get id;
  external int get uid;
  external String get kind; //enum
  external String label;
  external String language;

  external T? activeQuality;
  external THEOplayerArrayList<T> qualities;
  //TODO: check if we can change every THEOplayerArrayList to List!
  external List<T>? targetQuality;

}

@JS()
@anonymous
class THEOplayerAudioTrack extends THEOplayerMediaTrack<THEOplayerAudioQuality> {

}

@JS()
@anonymous
class THEOplayerVideoTrack extends THEOplayerMediaTrack<THEOplayerVideoQuality> {
  
}

@JS()
@anonymous
abstract class THEOplayerMediaQuality extends THEOplayerEventListener {

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
class THEOplayerAudioQuality extends THEOplayerMediaQuality {

  external int get audioSamplingRate;
}

@JS()
@anonymous
class THEOplayerVideoQuality extends THEOplayerMediaQuality {

  external int get height;
  external int get width;
  external double get frameRate;
  external double get firstFrame;

}