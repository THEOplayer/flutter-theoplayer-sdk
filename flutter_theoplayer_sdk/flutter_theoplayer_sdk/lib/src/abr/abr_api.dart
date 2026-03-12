import 'package:theoplayer_platform_interface/abr/abr_internal_api.dart';

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

/// Dart-side ABR API.
///
/// Delegates to an [AbrInternalInterface] provided by the platform-specific
/// view controller (Pigeon on native, JS interop on web).
class AbrAPI {
  AbrInternalInterface? _controller;

  /// Bind to the platform controller. Called internally during player setup.
  void setup(AbrInternalInterface? controller) {
    _controller = controller;
  }

  /// Get the current ABR strategy.
  Future<AbrStrategyConfiguration> get strategy async {
    final result = await _controller?.getAbrStrategy();
    if (result == null) {
      return AbrStrategyConfiguration(type: AbrStrategyType.bandwidth);
    }
    return _fromInternal(result);
  }

  /// Set the ABR strategy.
  Future<void> setStrategy(AbrStrategyConfiguration config) async {
    await _controller?.setAbrStrategy(_toInternal(config));
  }

  /// Get the target buffer in seconds.
  Future<double> get targetBuffer async {
    return await _controller?.getTargetBuffer() ?? 20.0;
  }

  /// Set the target buffer in seconds.
  Future<void> setTargetBuffer(double value) async {
    await _controller?.setTargetBuffer(value);
  }

  /// Get the preferred peak bitrate in bps (iOS only, returns 0 on other platforms).
  Future<double> get preferredPeakBitRate async {
    return await _controller?.getPreferredPeakBitRate() ?? 0.0;
  }

  /// Set the preferred peak bitrate in bps (iOS only, no-op on other platforms).
  Future<void> setPreferredPeakBitRate(double value) async {
    await _controller?.setPreferredPeakBitRate(value);
  }

  void dispose() {
    _controller = null;
  }

  // MARK: - Mapping helpers

  static AbrStrategyConfiguration _fromInternal(AbrStrategyConfigurationInternal i) {
    return AbrStrategyConfiguration(
      type: AbrStrategyType.values[i.type.index],
      metadata: i.metadata != null
          ? AbrStrategyMetadata(bitrate: i.metadata!.bitrate)
          : null,
    );
  }

  static AbrStrategyConfigurationInternal _toInternal(AbrStrategyConfiguration c) {
    return AbrStrategyConfigurationInternal(
      type: AbrStrategyTypeInternal.values[c.type.index],
      metadata: c.metadata != null
          ? AbrStrategyMetadataInternal(bitrate: c.metadata!.bitrate)
          : null,
    );
  }
}
