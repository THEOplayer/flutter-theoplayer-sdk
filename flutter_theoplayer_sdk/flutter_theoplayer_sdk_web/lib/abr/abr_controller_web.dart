import 'dart:js_interop';

import 'package:theoplayer_platform_interface/abr/abr_internal_api.dart';
import 'package:theoplayer_web/theoplayer_api_web.dart';

class AbrControllerWeb implements AbrInternalInterface {
  final THEOplayerJS _theoPlayerJS;

  AbrControllerWeb(this._theoPlayerJS);

  @override
  Future<AbrStrategyConfigurationInternal> getAbrStrategy() async {
    final abrConfig = _theoPlayerJS.abr;
    final strategyJS = abrConfig.strategy;
    if (strategyJS == null) {
      return AbrStrategyConfigurationInternal(type: AbrStrategyTypeInternal.bandwidth);
    }
    final strategy = strategyJS as THEOplayerAbrStrategy;
    return AbrStrategyConfigurationInternal(
      type: _fromJsType(strategy.type),
      metadata: strategy.metadata != null
          ? AbrStrategyMetadataInternal(bitrate: strategy.metadata!.bitrate)
          : null,
    );
  }

  @override
  Future<void> setAbrStrategy(AbrStrategyConfigurationInternal config) async {
    final abrConfig = _theoPlayerJS.abr;
    THEOplayerAbrMetadata? metadata;
    if (config.metadata != null) {
      metadata = THEOplayerAbrMetadata(bitrate: config.metadata!.bitrate);
    }
    abrConfig.strategy = THEOplayerAbrStrategy(
      type: _toJsType(config.type),
      metadata: metadata,
    ) as JSAny;
  }

  @override
  Future<double> getTargetBuffer() async {
    final abrConfig = _theoPlayerJS.abr;
    return abrConfig.targetBuffer?.toDartDouble ?? 20.0;
  }

  @override
  Future<void> setTargetBuffer(double value) async {
    final abrConfig = _theoPlayerJS.abr;
    abrConfig.targetBuffer = value.toJS;
  }

  @override
  Future<double> getPreferredPeakBitRate() async {
    // Not supported on web
    return 0.0;
  }

  @override
  Future<void> setPreferredPeakBitRate(double value) async {
    // No-op on web
  }

  // MARK: - Mapping helpers

  AbrStrategyTypeInternal _fromJsType(String type) {
    switch (type) {
      case 'performance':
        return AbrStrategyTypeInternal.performance;
      case 'quality':
        return AbrStrategyTypeInternal.quality;
      case 'bandwidth':
      default:
        return AbrStrategyTypeInternal.bandwidth;
    }
  }

  String _toJsType(AbrStrategyTypeInternal type) {
    switch (type) {
      case AbrStrategyTypeInternal.performance:
        return 'performance';
      case AbrStrategyTypeInternal.quality:
        return 'quality';
      case AbrStrategyTypeInternal.bandwidth:
        return 'bandwidth';
    }
  }
}
