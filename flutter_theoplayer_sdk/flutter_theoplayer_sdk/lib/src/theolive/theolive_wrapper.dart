import 'package:theoplayer_platform_interface/theolive/theolive_events.dart';
import 'package:theoplayer_platform_interface/theolive/theolive_internal_api.dart';
import 'package:theoplayer_platform_interface/theoplayer_event_dispatcher_interface.dart';
import 'package:theoplayer_platform_interface/theoplayer_event_manager.dart';
import 'package:theoplayer_platform_interface/theoplayer_events.dart';

class THEOliveAPIHolder extends THEOliveInternalInterface {
  final EventManager _eventManager = EventManager();
  THEOliveInternalInterface? _internalTHEOliveAPI;

  void forwardingEventListener(event) {
    _eventManager.dispatchEvent(event);
  }

  THEOliveAPIHolder();

  /// Method to setup the THEOlive event listeners).
  void setup(THEOliveInternalInterface? internalTHEOliveAPI) {
    _internalTHEOliveAPI = internalTHEOliveAPI;

    _internalTHEOliveAPI?.addEventListener(THEOliveApiEventTypes.PUBLICATIONLOADSTART, forwardingEventListener);
    _internalTHEOliveAPI?.addEventListener(THEOliveApiEventTypes.PUBLICATIONLOADED, forwardingEventListener);
    _internalTHEOliveAPI?.addEventListener(THEOliveApiEventTypes.PUBLICATIONOFFLINE, forwardingEventListener);
    _internalTHEOliveAPI?.addEventListener(THEOliveApiEventTypes.INTENTTOFALLBACK, forwardingEventListener);
    _internalTHEOliveAPI?.addEventListener(THEOliveApiEventTypes.ENTERBADNETWORKMODE, forwardingEventListener);
    _internalTHEOliveAPI?.addEventListener(THEOliveApiEventTypes.EXITBADNETWORKMODE, forwardingEventListener);

  }

  @override
  void addEventListener(String eventType, EventListener<Event> listener) {
    _eventManager.addEventListener(eventType, listener);
  }

  @override
  void removeEventListener(String eventType, EventListener<Event> listener) {
    _eventManager.removeEventListener(eventType, listener);
  }

  /// Method to clean the listeners.
  void dispose() {
    _internalTHEOliveAPI?.removeEventListener(THEOliveApiEventTypes.PUBLICATIONLOADSTART, forwardingEventListener);
    _internalTHEOliveAPI?.removeEventListener(THEOliveApiEventTypes.PUBLICATIONLOADED, forwardingEventListener);
    _internalTHEOliveAPI?.removeEventListener(THEOliveApiEventTypes.PUBLICATIONOFFLINE, forwardingEventListener);
    _internalTHEOliveAPI?.removeEventListener(THEOliveApiEventTypes.INTENTTOFALLBACK, forwardingEventListener);
    _internalTHEOliveAPI?.removeEventListener(THEOliveApiEventTypes.ENTERBADNETWORKMODE, forwardingEventListener);
    _internalTHEOliveAPI?.removeEventListener(THEOliveApiEventTypes.EXITBADNETWORKMODE, forwardingEventListener);
    _eventManager.clear();
  }

  @override
  bool get badNetworkMode {
    return _internalTHEOliveAPI?.badNetworkMode ?? false;
  }

  @override
  set badNetworkMode(bool badNetworkMode) {
    _internalTHEOliveAPI?.badNetworkMode = badNetworkMode;
  }

  @override
  void preloadChannels(List<String> channelIDs) {
    _internalTHEOliveAPI?.preloadChannels(channelIDs);
  }

}