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

  /// Whether the player should parse and expose HLS EXT-X-DATERANGE tags as [DateRangeCue]s on a TextTrack.
  ///
  /// When `null`, the player-level [THEOplayerConfig.hlsDateRange] setting applies.

  final bool? hlsDateRange;

  /// Whether the source should be played in the low-latency mode of the player.
  ///
  /// This option is supported on Web. It must be `true` when using Low-Latency CMAF with ABR.
  final bool? lowLatency;

  /// The source-level latency configuration for live playback.
  ///
  /// Ignored for VOD playback. Android and Web support every field. iOS supports only [SourceLatencyConfiguration.targetOffset].
  final SourceLatencyConfiguration? latencyConfiguration;

  TypedSource({
    required String src,
    this.type,
    DRMConfiguration? drm,
    SourceIntegrationId? integration,
    this.androidSourceConfiguration,
    this.headers,
    this.hlsDateRange,
    this.lowLatency,
    this.latencyConfiguration,
  }) : super(
          src: src,
          type: type,
          drm: drm,
          integration: integration,
          headers: headers,
          hlsDateRange: hlsDateRange,
          lowLatency: lowLatency,
          latencyConfiguration: latencyConfiguration,
        );
}

/// THEOlive TypedSource
class TheoLiveSource extends TypedSource {
  TheoLiveSource({
    required String src,
    String? type,
    DRMConfiguration? drm,
    SourceIntegrationId? integration = SourceIntegrationId.theolive,
    AndroidTypedSourceConfiguration? androidSourceConfiguration,
    Map<String, String>? headers,
    bool? lowLatency,
    SourceLatencyConfiguration? latencyConfiguration,
  }) : super(
          src: src,
          type: type,
          drm: drm,
          integration: integration,
          androidSourceConfiguration: androidSourceConfiguration,
          headers: headers,
          lowLatency: lowLatency,
          latencyConfiguration: latencyConfiguration,
        );
}
