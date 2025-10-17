import 'package:theoplayer_platform_interface/theolive/theolive_api.dart';
import 'package:theoplayer_platform_interface/theolive/theolive_events.dart';
import 'package:theoplayer_platform_interface/theolive/theolive_internal_api.dart';
import 'package:theoplayer_platform_interface/theoplayer_event_dispatcher_interface.dart';
import 'package:theoplayer_platform_interface/theoplayer_event_manager.dart';
import 'package:theoplayer_platform_interface/theoplayer_events.dart';

class THEOliveAPIHolder extends THEOlive {
  final EventManager _eventManager = EventManager();

  DistributionState _distributionState = DistributionState.idle;

  THEOliveStateChangeListener? _stateChangeListener;
  THEOliveInternalInterface? _internalTHEOliveAPI;

  @override
  DistributionState get distributionState => _distributionState;

  void _forwardingEventListener(event) {
    var oldDistributionState = distributionState;
    switch (event) {
      case DistributionLoadStartEvent e: _distributionState = DistributionState.loading;
      case EndpointLoaded e: _distributionState = DistributionState.loaded;
      case DistributionOfflineEvent e: _distributionState = DistributionState.offline;
      case IntentToFallbackEvent e: _distributionState = DistributionState.intentToFallback;
      default:
        break;
    }

    if (oldDistributionState != _distributionState) {
      _stateChangeListener?.call();
    }
    _eventManager.dispatchEvent(event);
  }

  THEOliveAPIHolder();

  /// Method to setup the THEOlive event listeners).
  void setup(THEOliveInternalInterface? internalTHEOliveAPI) {
    _internalTHEOliveAPI = internalTHEOliveAPI;

    _internalTHEOliveAPI?.addEventListener(THEOliveApiEventTypes.DISTRIBUTIONLOADSTART, _forwardingEventListener);
    _internalTHEOliveAPI?.addEventListener(THEOliveApiEventTypes.ENDPOINTLOADED, _forwardingEventListener);
    _internalTHEOliveAPI?.addEventListener(THEOliveApiEventTypes.DISTRIBUTIONOFFLINE, _forwardingEventListener);
    _internalTHEOliveAPI?.addEventListener(THEOliveApiEventTypes.INTENTTOFALLBACK, _forwardingEventListener);
    _internalTHEOliveAPI?.addEventListener(THEOliveApiEventTypes.ENTERBADNETWORKMODE, _forwardingEventListener);
    _internalTHEOliveAPI?.addEventListener(THEOliveApiEventTypes.EXITBADNETWORKMODE, _forwardingEventListener);

    // experimental - only used on iOS, but kept it here for consistency - Android will not dispatch these
    _internalTHEOliveAPI?.addEventListener(PlayerEventTypes.SEEKING, _forwardingEventListener);
    _internalTHEOliveAPI?.addEventListener(PlayerEventTypes.SEEKED, _forwardingEventListener);

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
    _internalTHEOliveAPI?.removeEventListener(THEOliveApiEventTypes.DISTRIBUTIONLOADSTART, _forwardingEventListener);
    _internalTHEOliveAPI?.removeEventListener(THEOliveApiEventTypes.ENDPOINTLOADED, _forwardingEventListener);
    _internalTHEOliveAPI?.removeEventListener(THEOliveApiEventTypes.DISTRIBUTIONOFFLINE, _forwardingEventListener);
    _internalTHEOliveAPI?.removeEventListener(THEOliveApiEventTypes.INTENTTOFALLBACK, _forwardingEventListener);
    _internalTHEOliveAPI?.removeEventListener(THEOliveApiEventTypes.ENTERBADNETWORKMODE, _forwardingEventListener);
    _internalTHEOliveAPI?.removeEventListener(THEOliveApiEventTypes.EXITBADNETWORKMODE, _forwardingEventListener);
    _stateChangeListener = null;
    _distributionState = DistributionState.idle;
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