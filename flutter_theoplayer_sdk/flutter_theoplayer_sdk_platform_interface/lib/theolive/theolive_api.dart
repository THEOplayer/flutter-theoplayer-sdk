import 'package:theoplayer_platform_interface/theoplayer_event_dispatcher_interface.dart';

abstract class THEOlive implements EventDispatcher{
  void preloadChannels(List<String> channelIDs);
  void set badNetworkMode(bool badNetworkMode);
  bool get badNetworkMode;
}
