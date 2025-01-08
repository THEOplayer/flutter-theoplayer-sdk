import 'package:theoplayer_platform_interface/ads/theoplayer_ads_events.dart';
import 'package:theoplayer_platform_interface/ads/theoplayer_ads_internal_interface.dart';
import 'package:theoplayer_platform_interface/pigeon/apis.g.dart';
import 'package:theoplayer_platform_interface/pigeon_binary_messenger_wrapper.dart';
import 'package:theoplayer_platform_interface/theoplayer_event_dispatcher_interface.dart';
import 'package:theoplayer_platform_interface/theoplayer_event_manager.dart';
import 'package:theoplayer_platform_interface/theoplayer_events.dart';


class AdsImplMobile extends AdsInternalInterface implements THEOplayerFlutterAdsAPI {

  final EventManager _eventManager = EventManager();

  late final String _channelSuffix;
  late final PigeonBinaryMessengerWrapper _pigeonMessenger;
  late final THEOplayerNativeAdsAPI _nativeAPI;

  AdBreak? _currentAdBreak = null;
  List<Ad> _currentAds = [];
  List<Ad> _scheduledAds = [];
  bool _isPlaying = false;

  AdsImplMobile(int id){
    _channelSuffix = 'id_$id';
    _pigeonMessenger = PigeonBinaryMessengerWrapper(suffix: _channelSuffix);
    _nativeAPI = THEOplayerNativeAdsAPI(binaryMessenger: _pigeonMessenger);
    THEOplayerFlutterAdsAPI.setup(this, binaryMessenger: _pigeonMessenger);
  }

  @override
  AdBreak? getCurrentAdBreak() {
    return _currentAdBreak;
  }

  @override
  List<Ad> getCurrentAds() {
    return _currentAds;
  }

  @override
  List<Ad> getScheduledAds() {
    return _scheduledAds;
  }

  @override
  bool isPlaying() {
    return _isPlaying;
  }

  @override
  void schedule(AdDescription adDescription) {
    _nativeAPI.schedule(adDescription);
  }

  @override
  void skip() {
    _nativeAPI.skip();
  }

  @override
  void addEventListener(String eventType, EventListener<Event> listener) {
    _eventManager.addEventListener(eventType, listener);
  }

  @override
  void removeEventListener(String eventType, EventListener<Event> listener) {
    _eventManager.removeEventListener(eventType, listener);
  }

  @override
  void dispose() {
    _scheduledAds.clear();
    _currentAds.clear();
    _currentAdBreak = null;
    _eventManager.clear();
  }

  // THEOplayerFlutterAdsAPI

  void _updateLocalRepresentations(List<Ad?> pCurrentAds, AdBreak? pCurrentAdBreak, List<Ad?> pScheduledAds) {
    _currentAds = pCurrentAds.nonNulls.toList();
    _currentAdBreak = pCurrentAdBreak;
    _scheduledAds = pScheduledAds.nonNulls.toList();
  }

  @override
  void onAdBegin(Ad? ad, List<Ad?> currentAds, AdBreak? currentAdBreak, List<Ad?> scheduledAds) {
    _updateLocalRepresentations(currentAds, currentAdBreak, scheduledAds);
    _eventManager.dispatchEvent(AdBeginEvent(ad));
  }

  @override
  void onAdBreakBegin(AdBreak adbreak, List<Ad?> currentAds, AdBreak? currentAdBreak, List<Ad?> scheduledAds) {
    _updateLocalRepresentations(currentAds, currentAdBreak, scheduledAds);
    _eventManager.dispatchEvent(AdBreakBeginEvent(adbreak));
  }

  @override
  void onAdBreakChange(AdBreak adbreak, List<Ad?> currentAds, AdBreak? currentAdBreak, List<Ad?> scheduledAds) {
    _updateLocalRepresentations(currentAds, currentAdBreak, scheduledAds);
    _eventManager.dispatchEvent(AdBreakChangeEvent(adbreak));
  }

  @override
  void onAdBreakEnd(AdBreak adbreak, List<Ad?> currentAds, AdBreak? currentAdBreak, List<Ad?> scheduledAds) {
    _updateLocalRepresentations(currentAds, currentAdBreak, scheduledAds);
    _eventManager.dispatchEvent(AdBreakEndEvent(adbreak));
  }

  @override
  void onAdClicked(Ad? ad, List<Ad?> currentAds, AdBreak? currentAdBreak, List<Ad?> scheduledAds) {
    _updateLocalRepresentations(currentAds, currentAdBreak, scheduledAds);
    _eventManager.dispatchEvent(AdClickedEvent(ad));
  }

  @override
  void onAdEnd(Ad? ad, List<Ad?> currentAds, AdBreak? currentAdBreak, List<Ad?> scheduledAds) {
    _updateLocalRepresentations(currentAds, currentAdBreak, scheduledAds);
    _eventManager.dispatchEvent(AdEndEvent(ad));
  }

  @override
  void onAdError(Ad? ad, List<Ad?> currentAds, AdBreak? currentAdBreak, List<Ad?> scheduledAds) {
    _updateLocalRepresentations(currentAds, currentAdBreak, scheduledAds);
    _eventManager.dispatchEvent(AdErrorEvent(ad));
  }

  @override
  void onAdFirstQuartile(Ad? ad, List<Ad?> currentAds, AdBreak? currentAdBreak, List<Ad?> scheduledAds) {
    _updateLocalRepresentations(currentAds, currentAdBreak, scheduledAds);
    _eventManager.dispatchEvent(AdFirstQuartileEvent(ad));
  }

  @override
  void onAdImpression(Ad? ad, List<Ad?> currentAds, AdBreak? currentAdBreak, List<Ad?> scheduledAds) {
    _updateLocalRepresentations(currentAds, currentAdBreak, scheduledAds);
    _eventManager.dispatchEvent(AdImpressionEvent(ad));
  }

  @override
  void onAdLoaded(Ad? ad, List<Ad?> currentAds, AdBreak? currentAdBreak, List<Ad?> scheduledAds) {
    _updateLocalRepresentations(currentAds, currentAdBreak, scheduledAds);
    _eventManager.dispatchEvent(AdLoadedEvent(ad));
  }

  @override
  void onAdMidpoint(Ad? ad, List<Ad?> currentAds, AdBreak? currentAdBreak, List<Ad?> scheduledAds) {
    _updateLocalRepresentations(currentAds, currentAdBreak, scheduledAds);
    _eventManager.dispatchEvent(AdMidpointEvent(ad));
  }

  @override
  void onAdSkip(Ad? ad, List<Ad?> currentAds, AdBreak? currentAdBreak, List<Ad?> scheduledAds) {
    _updateLocalRepresentations(currentAds, currentAdBreak, scheduledAds);
    _eventManager.dispatchEvent(AdSkipEvent(ad));
  }

  @override
  void onAdTapped(Ad? ad, List<Ad?> currentAds, AdBreak? currentAdBreak, List<Ad?> scheduledAds) {
    _updateLocalRepresentations(currentAds, currentAdBreak, scheduledAds);
    _eventManager.dispatchEvent(AdTappedEvent(ad));
  }

  @override
  void onAdThirdQuartile(Ad? ad, List<Ad?> currentAds, AdBreak? currentAdBreak, List<Ad?> scheduledAds) {
    _updateLocalRepresentations(currentAds, currentAdBreak, scheduledAds);
    _eventManager.dispatchEvent(AdThirdQuartileEvent(ad));
  }

  @override
  void onAddAd(Ad? ad, List<Ad?> currentAds, AdBreak? currentAdBreak, List<Ad?> scheduledAds) {
    _updateLocalRepresentations(currentAds, currentAdBreak, scheduledAds);
    _eventManager.dispatchEvent(AddAdEvent(ad));
  }

  @override
  void onAddAdBreak(AdBreak adbreak, List<Ad?> currentAds, AdBreak? currentAdBreak, List<Ad?> scheduledAds) {
    _updateLocalRepresentations(currentAds, currentAdBreak, scheduledAds);
    _eventManager.dispatchEvent(AddAdBreakEvent(adbreak));
  }

  @override
  void onRemoveAdBreak(AdBreak adbreak, List<Ad?> currentAds, AdBreak? currentAdBreak, List<Ad?> scheduledAds) {
    _updateLocalRepresentations(currentAds, currentAdBreak, scheduledAds);
    _eventManager.dispatchEvent(RemoveAdBreakEvent(adbreak));
  }


}