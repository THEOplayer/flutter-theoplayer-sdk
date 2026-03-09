import 'package:theoplayer_platform_interface/theolive/theolive_api.dart';
import 'package:theoplayer_platform_interface/theoplayer_event_dispatcher_interface.dart';

abstract class THEOliveInternalInterface implements EventDispatcher {
  void preloadChannels(List<String> channelIDs);
  void set badNetworkMode(bool badNetworkMode);
  bool get badNetworkMode;
  Future<double?> get currentLatency;
  Future<HespLatencies?> get latencies;
  void dispose();
}
