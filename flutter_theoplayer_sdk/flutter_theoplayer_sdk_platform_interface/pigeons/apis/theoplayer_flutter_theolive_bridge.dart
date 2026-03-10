import 'package:pigeon/pigeon.dart';

class HespLatencies {
  final double? engineLatency;
  final double? distributionLatency;
  final double? playerLatency;
  final double? theoliveLatency;

  HespLatencies(this.engineLatency, this.distributionLatency, this.playerLatency, this.theoliveLatency);
}

@HostApi()
abstract class THEOplayerNativeTHEOliveAPI {
  void goLive();
  void preloadChannels(List<String>? channelIds);
  @async
  double? currentLatency();
  @async
  HespLatencies? latencies();
}

@FlutterApi()
abstract class THEOplayerFlutterTHEOliveAPI {
  void onDistributionLoadStartEvent(String distributionId);
  void onEndpointLoadedEvent(Endpoint endpoint);
  void onDistributionOfflineEvent(String distributionId);
  void onIntentToFallbackEvent(String? errorCode, String? errorMessage);
  //experimental API for iOS-only
  void onSeeking(double currentTime);
  void onSeeked(double currentTime);
}

class Endpoint {
  final String? hespSrc;
  final String? hlsSrc;
  final String? cdn;
  final String? adSrc;
  final double weight;
  final int priority;

  Endpoint(this.hespSrc, this.hlsSrc, this.cdn, this.adSrc, this.weight, this.priority);
}
