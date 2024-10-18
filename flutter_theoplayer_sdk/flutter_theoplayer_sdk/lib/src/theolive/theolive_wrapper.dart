import 'package:theoplayer_platform_interface/theolive/theolive_api.dart';
import 'package:theoplayer_platform_interface/theolive/theolive_events.dart';
import 'package:theoplayer_platform_interface/theolive/theolive_internal_api.dart';
import 'package:theoplayer_platform_interface/theoplayer_event_dispatcher_interface.dart';
import 'package:theoplayer_platform_interface/theoplayer_event_manager.dart';
import 'package:theoplayer_platform_interface/theoplayer_events.dart';

class THEOliveAPIHolder extends THEOlive {
  final EventManager _eventManager = EventManager();

  PublicationState _publicationState = PublicationState.idle;

  THEOliveStateChangeListener? _stateChangeListener;
  THEOliveInternalInterface? _internalTHEOliveAPI;

  @override
  PublicationState get publicationState => _publicationState;

  void _forwardingEventListener(event) {
    var oldPublicationState = publicationState;
    switch (event) {
      case PublicationLoadStartEvent e: _publicationState = PublicationState.loading;
      case PublicationLoadedEvent e: _publicationState = PublicationState.loaded;
      case PublicationOfflineEvent e: _publicationState = PublicationState.offline;
      case IntentToFallbackEvent e: _publicationState = PublicationState.intentToFallback;
      default:
        break;
    }

    if (oldPublicationState != _publicationState) {
      _stateChangeListener?.call();
    }
    _eventManager.dispatchEvent(event);
  }

  THEOliveAPIHolder();

  /// Method to setup the THEOlive event listeners).
  void setup(THEOliveInternalInterface? internalTHEOliveAPI) {
    _internalTHEOliveAPI = internalTHEOliveAPI;

    _internalTHEOliveAPI?.addEventListener(THEOliveApiEventTypes.PUBLICATIONLOADSTART, _forwardingEventListener);
    _internalTHEOliveAPI?.addEventListener(THEOliveApiEventTypes.PUBLICATIONLOADED, _forwardingEventListener);
    _internalTHEOliveAPI?.addEventListener(THEOliveApiEventTypes.PUBLICATIONOFFLINE, _forwardingEventListener);
    _internalTHEOliveAPI?.addEventListener(THEOliveApiEventTypes.INTENTTOFALLBACK, _forwardingEventListener);
    _internalTHEOliveAPI?.addEventListener(THEOliveApiEventTypes.ENTERBADNETWORKMODE, _forwardingEventListener);
    _internalTHEOliveAPI?.addEventListener(THEOliveApiEventTypes.EXITBADNETWORKMODE, _forwardingEventListener);

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
    _internalTHEOliveAPI?.removeEventListener(THEOliveApiEventTypes.PUBLICATIONLOADSTART, _forwardingEventListener);
    _internalTHEOliveAPI?.removeEventListener(THEOliveApiEventTypes.PUBLICATIONLOADED, _forwardingEventListener);
    _internalTHEOliveAPI?.removeEventListener(THEOliveApiEventTypes.PUBLICATIONOFFLINE, _forwardingEventListener);
    _internalTHEOliveAPI?.removeEventListener(THEOliveApiEventTypes.INTENTTOFALLBACK, _forwardingEventListener);
    _internalTHEOliveAPI?.removeEventListener(THEOliveApiEventTypes.ENTERBADNETWORKMODE, _forwardingEventListener);
    _internalTHEOliveAPI?.removeEventListener(THEOliveApiEventTypes.EXITBADNETWORKMODE, _forwardingEventListener);
    _stateChangeListener = null;
    _publicationState = PublicationState.idle;
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

  @override
  void setStateListener(THEOliveStateChangeListener listener) {
    _stateChangeListener = listener;
  }

}