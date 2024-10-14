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
