import 'package:flutter/foundation.dart';
import 'package:theoplayer_platform_interface/helpers/logger.dart';
import 'package:theoplayer_platform_interface/pigeon/apis.g.dart' hide HespLatencies;
import 'package:theoplayer_platform_interface/pigeon/apis.g.dart' as pigeon show HespLatencies;
import 'package:theoplayer_platform_interface/pigeon_binary_messenger_wrapper.dart';
import 'package:theoplayer_platform_interface/theolive/theolive_events.dart';
import 'package:theoplayer_platform_interface/theolive/theolive_api.dart';
import 'package:theoplayer_platform_interface/theolive/theolive_internal_api.dart';
import 'package:theoplayer_platform_interface/theoplayer_event_dispatcher_interface.dart';
import 'package:theoplayer_platform_interface/theoplayer_event_manager.dart';
import 'package:theoplayer_platform_interface/theoplayer_events.dart';

class THEOplayerTHEOliveControllerMobile extends THEOliveInternalInterface implements THEOplayerFlutterTHEOliveAPI {
  late final PigeonBinaryMessengerWrapper _pigeonMessenger;
  late final THEOplayerNativeTHEOliveAPI _nativeTHEOliveAPI;
  final EventManager _eventManager = EventManager();

  THEOplayerTHEOliveControllerMobile(String channelSuffix) {
    _pigeonMessenger = PigeonBinaryMessengerWrapper(suffix: channelSuffix);
    _nativeTHEOliveAPI = THEOplayerNativeTHEOliveAPI(binaryMessenger: _pigeonMessenger);
    THEOplayerFlutterTHEOliveAPI.setUp(this, binaryMessenger: _pigeonMessenger);
  }

  @override
  set badNetworkMode(bool badNetworkMode) {
    printLog("Using badNetworkMode is not supported on ${defaultTargetPlatform.name}");
  }

  @override
  bool get badNetworkMode {
    printLog("Using badNetworkMode is not supported on ${defaultTargetPlatform.name}");
    return false;
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
    _eventManager.clear();
  }

  @override
  void preloadChannels(List<String> channelIDs) {
    _nativeTHEOliveAPI.preloadChannels(channelIDs);
  }

  @override
  Future<double?> get currentLatency async {
    return _nativeTHEOliveAPI.currentLatency();
  }

  @override
  Future<HespLatencies?> get latencies async {
    final pigeonResult = await _nativeTHEOliveAPI.latencies();
    if (pigeonResult == null) return null;
    return HespLatencies(
      engineLatency: pigeonResult.engineLatency,
      distributionLatency: pigeonResult.distributionLatency,
      playerLatency: pigeonResult.playerLatency,
      theoliveLatency: pigeonResult.theoliveLatency,
    );
  }

  // THEOplayerFlutterTHEOliveAPI methods

  @override
  void onIntentToFallbackEvent(String? errorCode, String? errorMessage) {
    final reason = (errorCode != null || errorMessage != null) ? PlayerError(errorCode: errorCode ?? '', errorMessage: errorMessage ?? '') : null;
    _eventManager.dispatchEvent(TheoLiveIntentToFallbackEvent(reason: reason));
  }

  @override
  void onDistributionOfflineEvent(String distributionId) {
    _eventManager.dispatchEvent(DistributionOfflineEvent(distributionId: distributionId));
  }

  @override
  void onDistributionLoadStartEvent(String distributionId) {
    _eventManager.dispatchEvent(DistributionLoadStartEvent(distributionId: distributionId));
  }

  @override
  void onEndpointLoadedEvent(Endpoint endpoint) {
    _eventManager.dispatchEvent(EndpointLoadedEvent(endpoint: endpoint));
  }

  /// Experimental API
  @override
  void onSeeking(double currentTime) {
    // current time is not used
    _eventManager.dispatchEvent(SeekingEvent(currentTime: currentTime));
  }

  /// Experimental API
  @override
  void onSeeked(double currentTime) {
    // current time is not used
    _eventManager.dispatchEvent(SeekedEvent(currentTime: currentTime));
  }
}
