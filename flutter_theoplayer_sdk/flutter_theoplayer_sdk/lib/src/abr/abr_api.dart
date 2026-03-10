import 'package:theoplayer_platform_interface/pigeon/apis.g.dart';

/// The adaptive bitrate strategy type.
enum AbrStrategyType {
  performance,
  quality,
  bandwidth,
}

/// Metadata for the ABR strategy (e.g. initial bitrate cap).
class AbrStrategyMetadata {
  final int? bitrate;

  AbrStrategyMetadata({this.bitrate});
}

/// The ABR strategy configuration: type + optional metadata.
class AbrStrategyConfiguration {
  final AbrStrategyType type;
  final AbrStrategyMetadata? metadata;

  AbrStrategyConfiguration({required this.type, this.metadata});
}

/// Dart-side wrapper around the Pigeon-generated [THEOplayerNativeAbrAPI].
///
/// Provides a clean API to get/set ABR strategy, target buffer, and
/// preferred peak bitrate. Works on iOS, Android, and web.
class AbrAPI {
  THEOplayerNativeAbrAPI? _nativeAPI;

  /// Bind to the Pigeon API. Called internally during player setup.
  void setup(THEOplayerNativeAbrAPI? nativeAPI) {
    _nativeAPI = nativeAPI;
  }

  /// Get the current ABR strategy.
  Future<AbrStrategyConfiguration> get strategy async {
    final pigeon = await _nativeAPI?.getAbrStrategy();
    if (pigeon == null) {
      return AbrStrategyConfiguration(type: AbrStrategyType.bandwidth);
    }
    return _fromPigeon(pigeon);
  }

  /// Set the ABR strategy.
  Future<void> setStrategy(AbrStrategyConfiguration config) async {
    await _nativeAPI?.setAbrStrategy(_toPigeon(config));
  }

  /// Get the target buffer in seconds.
  Future<double> get targetBuffer async {
    return await _nativeAPI?.getTargetBuffer() ?? 20.0;
  }

  /// Set the target buffer in seconds.
  Future<void> setTargetBuffer(double value) async {
    await _nativeAPI?.setTargetBuffer(value);
  }

  /// Get the preferred peak bitrate in bps (iOS only, returns 0 on other platforms).
  Future<double> get preferredPeakBitRate async {
    return await _nativeAPI?.getPreferredPeakBitRate() ?? 0.0;
  }

  /// Set the preferred peak bitrate in bps (iOS only, no-op on other platforms).
  Future<void> setPreferredPeakBitRate(double value) async {
    await _nativeAPI?.setPreferredPeakBitRate(value);
  }

  void dispose() {
    _nativeAPI = null;
  }

  // MARK: - Mapping helpers

  static AbrStrategyConfiguration _fromPigeon(AbrStrategyConfigurationPigeon p) {
    return AbrStrategyConfiguration(
      type: AbrStrategyType.values[p.type.index],
      metadata: p.metadata != null
          ? AbrStrategyMetadata(bitrate: p.metadata!.bitrate?.toInt())
          : null,
    );
  }

  static AbrStrategyConfigurationPigeon _toPigeon(AbrStrategyConfiguration c) {
    return AbrStrategyConfigurationPigeon(
      type: AbrStrategyTypePigeon.values[c.type.index],
      metadata: c.metadata != null
          ? AbrStrategyMetadataPigeon(bitrate: c.metadata!.bitrate)
          : null,
    );
  }
}
