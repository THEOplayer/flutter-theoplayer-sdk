/// Internal interface for ABR configuration.
///
/// Implemented by platform-specific view controllers (web via JS interop,
/// native via Pigeon bridge).
abstract class AbrInternalInterface {
  Future<AbrStrategyConfigurationInternal> getAbrStrategy();
  Future<void> setAbrStrategy(AbrStrategyConfigurationInternal config);
  Future<double> getTargetBuffer();
  Future<void> setTargetBuffer(double value);
  Future<double> getPreferredPeakBitRate();
  Future<void> setPreferredPeakBitRate(double value);
}

/// Platform-neutral ABR strategy type used by the internal interface.
enum AbrStrategyTypeInternal {
  performance,
  quality,
  bandwidth,
}

/// Platform-neutral ABR strategy metadata.
class AbrStrategyMetadataInternal {
  final int? bitrate;
  AbrStrategyMetadataInternal({this.bitrate});
}

/// Platform-neutral ABR strategy configuration.
class AbrStrategyConfigurationInternal {
  final AbrStrategyTypeInternal type;
  final AbrStrategyMetadataInternal? metadata;
  AbrStrategyConfigurationInternal({required this.type, this.metadata});
}
