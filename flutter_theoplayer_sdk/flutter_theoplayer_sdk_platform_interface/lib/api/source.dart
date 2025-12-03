import '../pigeon/apis.g.dart';

/// AndroidTypedSourceConfiguration
class AndroidTypedSourceConfiguration {
  AndroidTypedSourceConfiguration();
}

/// TypedSource
class TypedSource extends TypedSourcePigeon {
  final AndroidTypedSourceConfiguration? androidSourceConfiguration;

  /// Sets the headers to be added to all requests associated with this source,
  /// this includes: master playlist, media playlist and segment requests
  ///
  /// Note:
  /// - Only works on iOS and Android (PlaybackPipeline.media3)
  /// - Web is not supported

  final Map<String, String>? headers;

  /// The content type (MIME type) of the media resource, represented by a value from the following list:
  /// - 'application/dash+xml': The media resource is an MPEG-DASH stream.
  /// - 'application/x-mpegURL' or 'application/vnd.apple.mpegurl': The media resource is an HLS stream.
  /// - 'video/mp4': The media resource is an MP4 file.
  /// - 'millicast': The media resource is a Millicast stream.
  /// - 'theolive': The media resource is a THEOlive stream.
  ///
  /// Note:
  /// - Supported MIME types may differ across native SDK implementations.

  String? type;

  TypedSource({
    required String src,
    this.type,
    DRMConfiguration? drm,
    SourceIntegrationId? integration,
    this.androidSourceConfiguration,
    this.headers
  }) : super(src: src, type: type, drm: drm, integration: integration, headers: headers);
}

/// THEOlive TypedSource
class TheoLiveSource extends TypedSource {
  TheoLiveSource({
    required String src,
    String? type,
    DRMConfiguration? drm,
    SourceIntegrationId? integration = SourceIntegrationId.theolive,
    AndroidTypedSourceConfiguration? androidSourceConfiguration
  }) : super(
    src: src,
    type: type,
    drm: drm,
    integration: integration,
    androidSourceConfiguration: androidSourceConfiguration
  );
}