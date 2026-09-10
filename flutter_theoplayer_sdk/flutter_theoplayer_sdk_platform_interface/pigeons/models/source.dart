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
  final bool? hlsDateRange;
  final bool? lowLatency;
  final SourceLatencyConfiguration? latencyConfiguration;

  TypedSourcePigeon({required this.src, this.type, this.drm, this.integration, this.headers, this.hlsDateRange, this.lowLatency, this.latencyConfiguration});
}

/// The source-level latency configuration for live playback.
///
/// All offsets are expressed in seconds. On iOS, only [targetOffset] is supported.
class SourceLatencyConfiguration {
  /// The live offset that the player aims for.
  final double targetOffset;

  /// The offset below which the player slows down.
  ///
  /// Defaults to 0.66 times [targetOffset].
  final double? minimumOffset;

  /// The offset above which the player speeds up.
  ///
  /// Defaults to 1.5 times [targetOffset].
  final double? maximumOffset;

  /// The offset above which the player seeks to live.
  ///
  /// Defaults to 3 times [targetOffset].
  final double? forceSeekOffset;

  /// The minimum playback rate used to increase latency.
  ///
  /// Defaults to 0.92.
  final double? minimumPlaybackRate;

  /// The maximum playback rate used to decrease latency.
  ///
  /// Defaults to 1.08.
  final double? maximumPlaybackRate;

  SourceLatencyConfiguration({
    required this.targetOffset,
    this.minimumOffset,
    this.maximumOffset,
    this.forceSeekOffset,
    this.minimumPlaybackRate,
    this.maximumPlaybackRate,
  });
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
