import 'package:pigeon/pigeon.dart';

/// The adaptive bitrate strategy type.
enum AbrStrategyTypePigeon {
  performance,
  quality,
  bandwidth,
}

/// Metadata for the ABR strategy (e.g. initial bitrate cap).
class AbrStrategyMetadataPigeon {
  final int? bitrate;

  AbrStrategyMetadataPigeon({this.bitrate});
}

/// The ABR strategy configuration: type + optional metadata.
class AbrStrategyConfigurationPigeon {
  final AbrStrategyTypePigeon type;
  final AbrStrategyMetadataPigeon? metadata;

  AbrStrategyConfigurationPigeon({required this.type, this.metadata});
}

/// Host API: Dart → Native calls for ABR configuration.
@HostApi()
abstract class THEOplayerNativeAbrAPI {
  /// Get the current ABR strategy.
  AbrStrategyConfigurationPigeon getAbrStrategy();

  /// Set the ABR strategy.
  void setAbrStrategy(AbrStrategyConfigurationPigeon config);

  /// Get the target buffer in seconds.
  double getTargetBuffer();

  /// Set the target buffer in seconds.
  void setTargetBuffer(double value);

  /// Get the preferred peak bitrate in bps (iOS only, returns 0 on other platforms).
  double getPreferredPeakBitRate();

  /// Set the preferred peak bitrate in bps (iOS only, no-op on other platforms).
  void setPreferredPeakBitRate(double value);
}
