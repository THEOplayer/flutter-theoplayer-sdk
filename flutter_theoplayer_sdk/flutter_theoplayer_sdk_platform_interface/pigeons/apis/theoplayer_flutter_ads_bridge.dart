import 'package:pigeon/pigeon.dart';

import '../models/ads.dart';

//Talking from Native to Dart
@FlutterApi()
abstract class THEOplayerFlutterAdsAPI {
  void onAdBegin(Ad ad);
  void onAdBreakBegin(AdBreak adbreak);
  void onAdBreakChange(AdBreak adbreak);
  void onAdBreakEnd(AdBreak adbreak);
  void onAdClicked(Ad ad);
  void onAddAdBreak(AdBreak adbreak);
  void onAddAd(Ad ad);
  void onAdEnd(Ad ad);
  void onAdError(Ad ad);
  void onAdFirstQuartile(Ad ad);
  void onAdImpression(Ad ad);
  void onAdLoaded(Ad ad);
  void onAdMidpoint(Ad ad);
  void onAdSkip(Ad ad);
  void onAdTapped(Ad ad);
  void onAdThirdQuartile(Ad ad);
  void onRemoveAdBreak(AdBreak adbreak);
}

@HostApi()
abstract class THEOplayerNativeAdsAPI {
  bool isPlaying();
  List<Ad> getCurrentAds();
  AdBreak getCurrentAdBreak();
  List<Ad> getScheduledAds();
  void schedule(AdDescription adDescription);
  void skip();
  //TODO:
  // getOmid()
  // registerServerSideIntegration()
}

