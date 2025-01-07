import 'package:pigeon/pigeon.dart';

import '../models/ads.dart';

//Talking from Native to Dart

@FlutterApi()
abstract class THEOplayerFlutterAdsAPI {
  void onAdBegin(Ad? ad, List<Ad> currentAds, AdBreak? currentAdBreak, List<Ad> scheduledAds);
  void onAdBreakBegin(AdBreak adbreak, List<Ad> currentAds, AdBreak? currentAdBreak, List<Ad> scheduledAds);
  void onAdBreakChange(AdBreak adbreak, List<Ad> currentAds, AdBreak? currentAdBreak, List<Ad> scheduledAds);
  void onAdBreakEnd(AdBreak adbreak, List<Ad> currentAds, AdBreak? currentAdBreak, List<Ad> scheduledAds);
  void onAdClicked(Ad? ad, List<Ad> currentAds, AdBreak? currentAdBreak, List<Ad> scheduledAds);
  void onAddAdBreak(AdBreak adbreak, List<Ad> currentAds, AdBreak? currentAdBreak, List<Ad> scheduledAds);
  void onAddAd(Ad? ad, List<Ad> currentAds, AdBreak? currentAdBreak, List<Ad> scheduledAds);
  void onAdEnd(Ad? ad, List<Ad> currentAds, AdBreak? currentAdBreak, List<Ad> scheduledAds);
  void onAdError(Ad? ad, List<Ad> currentAds, AdBreak? currentAdBreak, List<Ad> scheduledAds);
  void onAdFirstQuartile(Ad? ad, List<Ad> currentAds, AdBreak? currentAdBreak, List<Ad> scheduledAds);
  void onAdImpression(Ad? ad, List<Ad> currentAds, AdBreak? currentAdBreak, List<Ad> scheduledAds);
  void onAdLoaded(Ad? ad, List<Ad> currentAds, AdBreak? currentAdBreak, List<Ad> scheduledAds);
  void onAdMidpoint(Ad? ad, List<Ad> currentAds, AdBreak? currentAdBreak, List<Ad> scheduledAds);
  void onAdSkip(Ad? ad, List<Ad> currentAds, AdBreak? currentAdBreak, List<Ad> scheduledAds);
  void onAdTapped(Ad? ad, List<Ad> currentAds, AdBreak? currentAdBreak, List<Ad> scheduledAds);
  void onAdThirdQuartile(Ad? ad, List<Ad> currentAds, AdBreak? currentAdBreak, List<Ad> scheduledAds);
  void onRemoveAdBreak(AdBreak adbreak, List<Ad> currentAds, AdBreak? currentAdBreak, List<Ad> scheduledAds);
}

@HostApi()
abstract class THEOplayerNativeAdsAPI {
  bool isPlaying();
  List<Ad> getCurrentAds();
  AdBreak? getCurrentAdBreak();
  List<Ad> getScheduledAds();
  void schedule(AdDescription adDescription);
  void skip();
  //TODO:
  // getOmid()
  // registerServerSideIntegration()
}

