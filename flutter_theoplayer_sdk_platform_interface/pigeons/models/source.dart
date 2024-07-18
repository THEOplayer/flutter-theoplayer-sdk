class SourceDescription {
  final List<TypedSource?> sources;
  final List<AdDescription?>? ads;

  const SourceDescription(this.ads, {required this.sources});
}

/*

// NOTE: this abstraction/inheritance doesn't get generated in pigeons for some reason
// TODO: check later


class AdDescription {
  final String adIntegration;

  AdDescription({required this.adIntegration});
}

//TODO: extending doesn't work
class GoogleImaAdDescription /*extends AdDescription*/ {
  final String adIntegration;
  final String source;
  final String timeOffset;

  GoogleImaAdDescription(this.timeOffset, this.adIntegration, {required this.source});
}

 */

// TODO: we need to differentiate Pigeon and Public facing APIs and then we can hide the [adIntegration]
class AdDescription {
  final String adIntegration;
  final String source;
  final String timeOffset;

  AdDescription(this.timeOffset, {required this.source, required this.adIntegration});
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
