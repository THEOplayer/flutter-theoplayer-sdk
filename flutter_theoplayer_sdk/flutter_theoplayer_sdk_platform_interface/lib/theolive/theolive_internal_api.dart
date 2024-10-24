import 'package:theoplayer_platform_interface/theoplayer_event_dispatcher_interface.dart';

abstract class THEOliveInternalInterface implements EventDispatcher {
  void preloadChannels(List<String> channelIDs);
  void set badNetworkMode(bool badNetworkMode);
  bool get badNetworkMode;
  void dispose();
}
