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
  //experimental API for iOS-only
  void onSeeking(double currentTime);
  void onSeeked(double currentTime);
}
