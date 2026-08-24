import 'package:theoplayer_platform_interface/theolive/theolive_api.dart';
import 'package:theoplayer_platform_interface/theoplayer_event_dispatcher_interface.dart';

abstract class THEOliveInternalInterface implements EventDispatcher {
  void set badNetworkMode(bool badNetworkMode);
  bool get badNetworkMode;
  void set authToken(String? authToken);
  String? get authToken;
  Future<double?> get currentLatency;
  Future<HespLatencies?> get latencies;
  void dispose();
}
