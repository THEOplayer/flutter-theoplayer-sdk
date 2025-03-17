import 'package:flutter/foundation.dart';
import 'package:theoplayer_platform_interface/helpers/logger.dart';
import 'package:theoplayer_platform_interface/pigeon/apis.g.dart';
import 'package:theoplayer_platform_interface/pigeon_binary_messenger_wrapper.dart';
import 'package:theoplayer_platform_interface/theolive/theolive_events.dart';
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
    THEOplayerFlutterTHEOliveAPI.setup(this, binaryMessenger: _pigeonMessenger);
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

  // THEOplayerFlutterTHEOliveAPI methods
  
  @override
  void onIntentToFallbackEvent() {
    _eventManager.dispatchEvent(IntentToFallbackEvent());
  }

  @override
  void onPublicationOfflineEvent(String channelId) {
    _eventManager.dispatchEvent(PublicationOfflineEvent(publicationId: channelId));
  }

  @override
  void onPublicationLoadStartEvent(String channelId) {
    _eventManager.dispatchEvent(PublicationLoadStartEvent(publicationId: channelId));
  }

  @override
  void onPublicationLoadedEvent(String channelId) {
    _eventManager.dispatchEvent(PublicationLoadedEvent(publicationId: channelId));
  }

}
