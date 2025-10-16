import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class THEOplayerNativeTHEOliveAPI {
  void goLive();
  void preloadChannels(List<String>? channelIds);
}

@FlutterApi()
abstract class THEOplayerFlutterTHEOliveAPI {
  void onDistributionLoadStartEvent(String channelId);
  void onEndpointLoadedEvent(Endpoint endpoint);
  void onDistributionOfflineEvent(String channelId);
  void onIntentToFallbackEvent();
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