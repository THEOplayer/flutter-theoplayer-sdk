class SourceDescription {
  final List<PigeonTypedSource?> sources;

  const SourceDescription({required this.sources});
}

///
/// Internal TypedSource Pigeon for Android/iOS communication
/// Remarks:
/// * Internal type, don't use it, it will be removed.
///
class PigeonTypedSource {
  final String src;
  final DRMConfiguration? drm;
  final SourceIntegrationId? integration;
  final PlaybackPipeline playbackPipeline;
  final Map<String?, String?>? headers;

  const PigeonTypedSource({required this.src, this.drm, this.integration, this.playbackPipeline = PlaybackPipeline.media3, this.headers});
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

enum PlaybackPipeline {
  media3, legacy,
}