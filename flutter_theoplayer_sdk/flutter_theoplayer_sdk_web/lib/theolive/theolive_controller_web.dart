import 'dart:js_interop';
import 'package:theoplayer_platform_interface/pigeon/apis.g.dart';
import 'package:theoplayer_platform_interface/theolive/theolive_events.dart';
import 'package:theoplayer_platform_interface/theolive/theolive_internal_api.dart';
import 'package:theoplayer_platform_interface/theoplayer_event_dispatcher_interface.dart';
import 'package:theoplayer_platform_interface/theoplayer_event_manager.dart';
import 'package:theoplayer_platform_interface/theoplayer_events.dart';
import 'package:theoplayer_web/theoplayer_api_event_web.dart';
import 'package:theoplayer_web/theoplayer_api_web.dart';
import 'package:theoplayer_web/theoplayer_js_helpers_web.dart';

class THEOliveControllerWeb extends THEOliveInternalInterface {

  final THEOplayerTheoLiveApi _theoLiveApi;
  final EventManager _eventManager = EventManager();

  late final endpointLoadedEventListener;
  late final distributionLoadStartEventListener;
  late final distributionOfflineEventListener;
  late final intentToFallbackEventListener;
  late final enterBadNetworkModeEventListener;
  late final exitBadNetworkModeEventListener;

  THEOliveControllerWeb(this._theoLiveApi) {
    endpointLoadedEventListener = (EndpointLoadedEventJS event) {
      _eventManager.dispatchEvent(EndpointLoadedEvent(endpoint:
          Endpoint(
            hespSrc: event.endpoint.hespSrc,
            hlsSrc: event.endpoint.hlsSrc,
            adSrc: event.endpoint.adSrc,
            cdn: event.endpoint.adSrc,
            weight: event.endpoint.weight.toDouble(),
            priority: event.endpoint.priority,
          )
      ));
    }.toJS;

    distributionLoadStartEventListener = (DistributionLoadStartEventJS event) {
      _eventManager.dispatchEvent(DistributionLoadStartEvent(channelId: event.distributionId));
    }.toJS;

    distributionOfflineEventListener = (DistributionOfflineEventJS event) {
      _eventManager.dispatchEvent(DistributionOfflineEvent(channelId: event.distributionId));
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

    _theoLiveApi.addEventListener(THEOliveApiEventTypes.ENDPOINTLOADED.toLowerCase(), endpointLoadedEventListener);
    _theoLiveApi.addEventListener(THEOliveApiEventTypes.DISTRIBUTIONLOADSTART.toLowerCase(), distributionLoadStartEventListener);
    _theoLiveApi.addEventListener(THEOliveApiEventTypes.DISTRIBUTIONOFFLINE.toLowerCase(), distributionOfflineEventListener);
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
    _theoLiveApi.preloadPublications(JSHelpers.stringListToJSArray(channelIDs));
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
    _theoLiveApi.removeEventListener(THEOliveApiEventTypes.ENDPOINTLOADED.toLowerCase(), endpointLoadedEventListener);
    _theoLiveApi.removeEventListener(THEOliveApiEventTypes.DISTRIBUTIONLOADSTART.toLowerCase(), distributionLoadStartEventListener);
    _theoLiveApi.removeEventListener(THEOliveApiEventTypes.DISTRIBUTIONOFFLINE.toLowerCase(), distributionOfflineEventListener);
    _theoLiveApi.removeEventListener(THEOliveApiEventTypes.INTENTTOFALLBACK.toLowerCase(), intentToFallbackEventListener);
    _theoLiveApi.removeEventListener(THEOliveApiEventTypes.ENTERBADNETWORKMODE.toLowerCase(), enterBadNetworkModeEventListener);
    _theoLiveApi.removeEventListener(THEOliveApiEventTypes.EXITBADNETWORKMODE.toLowerCase(), exitBadNetworkModeEventListener);
  }

}