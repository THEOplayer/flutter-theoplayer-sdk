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

  TypedSource({
    required super.src,
    super.drm,
    super.integration,
    this.androidSourceConfiguration,
    this.headers
  }) : super(playbackPipeline: androidSourceConfiguration?.playbackPipeline ?? PlaybackPipeline.media3);
}
/// THEOlive TypedSource
class TheoLiveSource extends TypedSource {
  TheoLiveSource({required super.src, super.drm, super.integration = SourceIntegrationId.theolive, super.androidSourceConfiguration});
}