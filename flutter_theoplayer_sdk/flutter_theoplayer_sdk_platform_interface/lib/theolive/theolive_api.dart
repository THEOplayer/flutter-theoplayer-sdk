import 'package:theoplayer_platform_interface/theoplayer_event_dispatcher_interface.dart';


/// Callback that's triggered every time the internal player state is changing. See [THEOplayer.setStateListener].
typedef THEOliveStateChangeListener = void Function();

abstract class THEOlive implements EventDispatcher{
  void preloadChannels(List<String> channelIDs);
  void set badNetworkMode(bool badNetworkMode);
  bool get badNetworkMode;
  void setStateListener(THEOliveStateChangeListener listener);
  PublicationState get publicationState;
}

enum PublicationState { idle, loading, loaded, intentToFallback, offline }