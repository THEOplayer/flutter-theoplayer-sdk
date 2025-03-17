import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class THEOplayerNativeTHEOliveAPI {
  void goLive();
  void preloadChannels(List<String>? channelIds);
}

@FlutterApi()
abstract class THEOplayerFlutterTHEOliveAPI {
  void onPublicationLoadStartEvent(String channelId);
  void onPublicationLoadedEvent(String channelId);
  void onPublicationOfflineEvent(String channelId);
  void onIntentToFallbackEvent();
}
