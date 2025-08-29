import '../pigeon/apis.g.dart';

/// AndroidTypedSourceConfiguration
class AndroidTypedSourceConfiguration {
  final PlaybackPipeline playbackPipeline;
  AndroidTypedSourceConfiguration({PlaybackPipeline? playbackPipeline})
      : playbackPipeline = playbackPipeline ?? PlaybackPipeline.media3;
}

/// TypedSource
class TypedSource extends PigeonTypedSource {
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
    required super.src,
    this.type,
    super.drm,
    super.integration,
    this.androidSourceConfiguration,
    this.headers
  }) : super(playbackPipeline: androidSourceConfiguration?.playbackPipeline ?? PlaybackPipeline.media3);
}
/// THEOlive TypedSource
class TheoLiveSource extends TypedSource {
  TheoLiveSource({required super.src, super.type, super.drm, super.integration = SourceIntegrationId.theolive, super.androidSourceConfiguration});
}