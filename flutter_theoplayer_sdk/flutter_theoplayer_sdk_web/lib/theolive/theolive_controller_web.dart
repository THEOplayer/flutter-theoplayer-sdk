import 'dart:js_interop';
import 'package:theoplayer_platform_interface/theolive/theolive_events.dart';
import 'package:theoplayer_platform_interface/theolive/theolive_internal_api.dart';
import 'package:theoplayer_platform_interface/theoplayer_event_dispatcher_interface.dart';
import 'package:theoplayer_platform_interface/theoplayer_event_manager.dart';
import 'package:theoplayer_platform_interface/theoplayer_events.dart';
import 'package:theoplayer_web/theoplayer_api_event_web.dart';
import 'package:theoplayer_web/theoplayer_api_web.dart';

class THEOliveControllerWeb extends THEOliveInternalInterface {

  final THEOplayerTheoLiveApi _theoLiveApi;
  final EventManager _eventManager = EventManager();

  late final publicationLoadedEventListener;
  late final publicationLoadStartEventListener;
  late final publicationOfflineEventListener;
  late final intentToFallbackEventListener;
  late final enterBadNetworkModeEventListener;
  late final exitBadNetworkModeEventListener;

  THEOliveControllerWeb(this._theoLiveApi) {
    publicationLoadedEventListener = (PublicationLoadedEventJS event) {
      _eventManager.dispatchEvent(PublicationLoadedEvent(publicationId: event.publicationId));
    }.toJS;

    publicationLoadStartEventListener = (PublicationLoadStartEventJS event) {
      _eventManager.dispatchEvent(PublicationLoadStartEvent(publicationId: event.publicationId));
    }.toJS;

    publicationOfflineEventListener = (PublicationOfflineEventJS event) {
      _eventManager.dispatchEvent(PublicationOfflineEvent(publicationId: event.publicationId));
    }.toJS;

    intentToFallbackEventListener = (IntentToFallbackEventJS event) {
      _eventManager.dispatchEvent(IntentToFallbackEvent());
    }.toJS;

    enterBadNetworkModeEventListener = (EnterBadNetworkModeEventJS event) {
      _eventManager.dispatchEvent(EnterBadNetworkModeEvent());
    }.toJS;

    exitBadNetworkModeEventListener = (ExitBadNetworkModeEventJS event) {
      _eventManager.dispatchEvent(ExitBadNetworkModeEvent());
    }.toJS;

    _theoLiveApi.addEventListener(THEOliveApiEventTypes.PUBLICATIONLOADED.toLowerCase(), publicationLoadedEventListener);
    _theoLiveApi.addEventListener(THEOliveApiEventTypes.PUBLICATIONLOADSTART.toLowerCase(), publicationLoadStartEventListener);
    _theoLiveApi.addEventListener(THEOliveApiEventTypes.PUBLICATIONOFFLINE.toLowerCase(), publicationOfflineEventListener);
    _theoLiveApi.addEventListener(THEOliveApiEventTypes.INTENTTOFALLBACK.toLowerCase(), intentToFallbackEventListener);
    _theoLiveApi.addEventListener(THEOliveApiEventTypes.ENTERBADNETWORKMODE.toLowerCase(), enterBadNetworkModeEventListener);
    _theoLiveApi.addEventListener(THEOliveApiEventTypes.EXITBADNETWORKMODE.toLowerCase(), exitBadNetworkModeEventListener);
  }

  @override
  set badNetworkMode(bool badNetworkMode) {
    _theoLiveApi.badNetworkMode = badNetworkMode;
  }

  @override
  bool get badNetworkMode {
    return _theoLiveApi.badNetworkMode;
  }

  @override
  void preloadChannels(List<String> channelIDs) {
    _theoLiveApi.preloadPublications(channelIDs);
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
    _theoLiveApi.removeEventListener(THEOliveApiEventTypes.PUBLICATIONLOADED.toLowerCase(), publicationLoadedEventListener);
    _theoLiveApi.removeEventListener(THEOliveApiEventTypes.PUBLICATIONLOADSTART.toLowerCase(), publicationLoadStartEventListener);
    _theoLiveApi.removeEventListener(THEOliveApiEventTypes.PUBLICATIONOFFLINE.toLowerCase(), publicationOfflineEventListener);
    _theoLiveApi.removeEventListener(THEOliveApiEventTypes.INTENTTOFALLBACK.toLowerCase(), intentToFallbackEventListener);
    _theoLiveApi.removeEventListener(THEOliveApiEventTypes.ENTERBADNETWORKMODE.toLowerCase(), enterBadNetworkModeEventListener);
    _theoLiveApi.removeEventListener(THEOliveApiEventTypes.EXITBADNETWORKMODE.toLowerCase(), exitBadNetworkModeEventListener);
  }

}