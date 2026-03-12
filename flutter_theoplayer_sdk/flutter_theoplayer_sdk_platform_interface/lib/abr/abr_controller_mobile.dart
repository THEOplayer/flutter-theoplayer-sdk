import 'package:theoplayer_platform_interface/abr/abr_internal_api.dart';
import 'package:theoplayer_platform_interface/pigeon/apis.g.dart';
import 'package:theoplayer_platform_interface/pigeon_binary_messenger_wrapper.dart';

class AbrControllerMobile implements AbrInternalInterface {
  late final PigeonBinaryMessengerWrapper _pigeonMessenger;
  late final THEOplayerNativeAbrAPI _nativeAbrAPI;

  AbrControllerMobile(String channelSuffix) {
    _pigeonMessenger = PigeonBinaryMessengerWrapper(suffix: channelSuffix);
    _nativeAbrAPI = THEOplayerNativeAbrAPI(binaryMessenger: _pigeonMessenger);
  }

  @override
  Future<AbrStrategyConfigurationInternal> getAbrStrategy() async {
    final pigeon = await _nativeAbrAPI.getAbrStrategy();
    return AbrStrategyConfigurationInternal(
      type: AbrStrategyTypeInternal.values[pigeon.type.index],
      metadata: pigeon.metadata != null
          ? AbrStrategyMetadataInternal(bitrate: pigeon.metadata!.bitrate?.toInt())
          : null,
    );
  }

  @override
  Future<void> setAbrStrategy(AbrStrategyConfigurationInternal config) async {
    await _nativeAbrAPI.setAbrStrategy(AbrStrategyConfigurationPigeon(
      type: AbrStrategyTypePigeon.values[config.type.index],
      metadata: config.metadata != null
          ? AbrStrategyMetadataPigeon(bitrate: config.metadata!.bitrate)
          : null,
    ));
  }

  @override
  Future<double> getTargetBuffer() async {
    return _nativeAbrAPI.getTargetBuffer();
  }

  @override
  Future<void> setTargetBuffer(double value) async {
    await _nativeAbrAPI.setTargetBuffer(value);
  }

  @override
  Future<double> getPreferredPeakBitRate() async {
    return _nativeAbrAPI.getPreferredPeakBitRate();
  }

  @override
  Future<void> setPreferredPeakBitRate(double value) async {
    await _nativeAbrAPI.setPreferredPeakBitRate(value);
  }
}
