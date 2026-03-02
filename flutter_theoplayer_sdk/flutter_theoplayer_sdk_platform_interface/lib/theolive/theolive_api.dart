import 'package:theoplayer_platform_interface/theoplayer_event_dispatcher_interface.dart';


/// Callback that's triggered every time the internal player state is changing. See [THEOplayer.setStateListener].
typedef THEOliveStateChangeListener = void Function();

class HespLatencies {
  final double? engineLatency;
  final double? distributionLatency;
  final double? playerLatency;
  final double? theoliveLatency;

  HespLatencies({this.engineLatency, this.distributionLatency, this.playerLatency, this.theoliveLatency});
}

abstract class THEOlive implements EventDispatcher{
  void preloadChannels(List<String> channelIDs);
  void set badNetworkMode(bool badNetworkMode);
  bool get badNetworkMode;
  void setStateListener(THEOliveStateChangeListener listener);
  DistributionState get distributionState;
  Future<double?> get currentLatency;
  Future<HespLatencies?> get latencies;
}

enum DistributionState { idle, loading, loaded, intentToFallback, offline }