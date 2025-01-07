import 'package:theoplayer_platform_interface/pigeon/apis.g.dart';
import 'package:theoplayer_platform_interface/theoplayer_event_dispatcher_interface.dart';

abstract class Ads implements EventDispatcher {
  bool isPlaying();
  List<Ad> getCurrentAds();
  AdBreak? getCurrentAdBreak();
  List<Ad> getScheduledAds();
  void schedule(AdDescription adDescription);
  void skip();

  //TODO:
  // void getOmid()
  // void registerServerSideIntegration()
}