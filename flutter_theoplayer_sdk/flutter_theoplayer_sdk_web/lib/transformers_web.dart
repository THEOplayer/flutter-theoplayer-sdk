import 'package:theoplayer_platform_interface/pigeon/apis.g.dart' as PlatformInterface;
import 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_audiotrack.dart';
import 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_audiotrack_impl.dart';
import 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_videotrack.dart';
import 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_videotrack_impl.dart';
import 'package:theoplayer_web/theoplayer_api_web.dart';

PlatformInterface.ReadyState toFlutterReadyState(int readyState) {
  PlatformInterface.ReadyState flutterReadyState = PlatformInterface.ReadyState.have_nothing;

  switch (readyState) {
    case 0:
      flutterReadyState = PlatformInterface.ReadyState.have_nothing;
    case 1:
      flutterReadyState = PlatformInterface.ReadyState.have_metadata;
    case 2:
      flutterReadyState = PlatformInterface.ReadyState.have_current_data;
    case 3:
      flutterReadyState = PlatformInterface.ReadyState.have_future_data;
    case 4:
      flutterReadyState = PlatformInterface.ReadyState.have_enough_data;
    default:
      throw UnsupportedError("Unsupported readyState: $readyState");
  }

  return flutterReadyState;
}

PlatformInterface.SourceDescription? toFlutterSourceDescription(SourceDescription? sourceDescription) {
  if (sourceDescription == null) {
    return null;
  }

  List<PlatformInterface.TypedSource> typedSources = [];
  for (var typedSource in sourceDescription.sources) {
    PlatformInterface.FairPlayDRMConfiguration? fairPlayDRMConfiguration;
    FairplayContentProtectionConfiguration? fairplay = typedSource.contentProtection?.fairplay;
    if (fairplay != null) {
      fairPlayDRMConfiguration = PlatformInterface.FairPlayDRMConfiguration(licenseAcquisitionURL: fairplay.licenseAcquisitionURL, certificateURL: fairplay.certificateURL);
    }

    PlatformInterface.WidevineDRMConfiguration? widevineDRMConfiguration;
    WidevineContentProtectionConfiguration? widevine = typedSource.contentProtection?.widevine;
    if (widevine != null) {
      widevineDRMConfiguration = PlatformInterface.WidevineDRMConfiguration(licenseAcquisitionURL: widevine.licenseAcquisitionURL);
    }

    typedSources.add(PlatformInterface.TypedSource(src: typedSource.src, drm: PlatformInterface.DRMConfiguration(fairplay: fairPlayDRMConfiguration, widevine: widevineDRMConfiguration)));
  }

  return PlatformInterface.SourceDescription(sources: typedSources);
}

SourceDescription toSourceDescription(PlatformInterface.SourceDescription flutterSourceDescription) {
  List<TypedSource> flutterTypedSources = [];

  for (var flutterTypedSource in flutterSourceDescription.sources) {
    if (flutterTypedSource == null) {
      continue;
    }

    FairplayContentProtectionConfiguration? flutterFairplayDrmConfiguration;
    PlatformInterface.FairPlayDRMConfiguration? faiplay = flutterTypedSource.drm?.fairplay;
    if (faiplay != null) {
      flutterFairplayDrmConfiguration = FairplayContentProtectionConfiguration(licenseAcquisitionURL: faiplay.licenseAcquisitionURL, certificateURL: faiplay.certificateURL);
    }

    WidevineContentProtectionConfiguration? flutterWidevineDrmConfiguration;
    PlatformInterface.WidevineDRMConfiguration? widevine = flutterTypedSource.drm?.widevine;
    if (widevine != null) {
      flutterWidevineDrmConfiguration = WidevineContentProtectionConfiguration(licenseAcquisitionURL: widevine.licenseAcquisitionURL);
    }

    flutterTypedSources.add(TypedSource(src: flutterTypedSource.src, contentProtection: ContentProtection(fairplay: flutterFairplayDrmConfiguration, widevine: flutterWidevineDrmConfiguration)));
  }

  return SourceDescription(sources: flutterTypedSources);
}

PlatformInterface.TextTrackReadyState toFlutterTextTrackReadyState(int textTrackReadyState) {
  switch (textTrackReadyState) {
    case 1:
      return PlatformInterface.TextTrackReadyState.loading;
    case 2:
      return PlatformInterface.TextTrackReadyState.loaded;
    case 3:
      return PlatformInterface.TextTrackReadyState.error;
    case 0:
    default:
      return PlatformInterface.TextTrackReadyState.none;
  }
}

PlatformInterface.TextTrackType toFlutterTextTrackType(String textTrackType) {
  switch (textTrackType) {
    case "srt":
      return PlatformInterface.TextTrackType.srt;
    case "ttml":
      return PlatformInterface.TextTrackType.ttml;
    case "webvtt":
      return PlatformInterface.TextTrackType.webvtt;
    case "emsg":
      return PlatformInterface.TextTrackType.emsg;
    case "eventstream":
      return PlatformInterface.TextTrackType.eventstream;
    case "id3":
      return PlatformInterface.TextTrackType.id3;
    case "cea608":
      return PlatformInterface.TextTrackType.cea608;
    case "daterange":
      return PlatformInterface.TextTrackType.daterange;
    case "":
    default:
      return PlatformInterface.TextTrackType.none;
  }
}

PlatformInterface.TextTrackMode toFlutterTextTrackMode(String mode) {
  switch (mode) {
    case "showing":
      return PlatformInterface.TextTrackMode.showing;
    case "hidden":
      return PlatformInterface.TextTrackMode.hidden;
    case "disabled":
    default:
      return PlatformInterface.TextTrackMode.disabled;
  }
}

String toTextTrackMode(PlatformInterface.TextTrackMode flutterTextTrackmode) {
  switch (flutterTextTrackmode) {
    case PlatformInterface.TextTrackMode.showing:
      return "showing";
    case PlatformInterface.TextTrackMode.hidden:
      return "hidden";
    case PlatformInterface.TextTrackMode.disabled:
    default:
      return "disabled";
  }
}

AudioQuality toFlutterAudioQuality(THEOplayerAudioQuality q) => AudioQualityImpl(q.id, q.uid, q.name, q.bandwidth, q.codecs, q.audioSamplingRate);

AudioQualities toFlutterAudioQualities(List<THEOplayerAudioQuality> qualities) {
  AudioQualities flutterQualities = AudioQualitiesImpl();
  for (var i = 0; i < qualities.length; i++) {
    THEOplayerAudioQuality q = qualities[i];
    flutterQualities.add(toFlutterAudioQuality(q));
  }
  return flutterQualities;
}

VideoQuality toFlutterVideoQuality(THEOplayerVideoQuality q) => VideoQualityImpl(q.id, q.uid, q.name, q.bandwidth, q.codecs, q.width, q.height, q.frameRate, q.firstFrame);

VideoQualities toFlutterVideoQualities(List<THEOplayerVideoQuality> qualities) {
  VideoQualities flutterQualities = VideoQualitiesImpl();
  for (var i = 0; i < qualities.length; i++) {
    THEOplayerVideoQuality q = qualities[i];
    flutterQualities.add(toFlutterVideoQuality(q));
  }
  return flutterQualities;
}
