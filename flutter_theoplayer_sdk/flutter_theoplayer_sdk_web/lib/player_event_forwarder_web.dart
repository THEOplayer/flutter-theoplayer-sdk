import 'dart:js_interop';

import 'package:theoplayer_platform_interface/theoplayer_event_dispatcher_interface.dart';
import 'package:theoplayer_platform_interface/theoplayer_event_manager.dart';
import 'package:theoplayer_platform_interface/theoplayer_events.dart';
import 'package:theoplayer_web/theoplayer_api_event_web.dart';
import 'package:theoplayer_web/theoplayer_api_web.dart';
import 'package:theoplayer_web/transformers_web.dart';

class PlayerEventForwarderWeb {
  final THEOplayerJS _theoplayerJS;
  final EventManager _eventManager = EventManager();

  late final canPlayEventListener;
  late final timeUpdateEventListener;
  late final playEventListener;
  late final playingEventListener;
  late final pauseEventListener;
  late final waitingEventListener;
  late final durationChangeEventListener;
  late final progressEventListener;
  late final rateChangeEventListener;
  late final seekingEventListener;
  late final seekedEventListener;
  late final volumeChangeEventListener;
  late final resizeEventListener;
  late final endedEventListener;
  late final errorEventListener;
  late final destroyEventListener;
  late final readyStateChangeEventListener;
  late final loadStartEventListener;
  late final loadedMetadataEventListener;
  late final loadedDataEventListener;
  late final canPlayThroughEventListener;
  late final sourceChangeEventListener;

  PlayerEventForwarderWeb(this._theoplayerJS) {
    canPlayEventListener = (CanPlayEventJS event) {
      _eventManager.dispatchEvent(CanPlayEvent(currentTime: event.currentTime));
    }.toJS;

    timeUpdateEventListener = (TimeUpdateEventJS event) {
      _eventManager.dispatchEvent(TimeUpdateEvent(currentTime: event.currentTime, currentProgramDateTime: event.currentProgramDateTime?.getTime()));
    }.toJS;

    playEventListener = (PlayEventJS event) {
      _eventManager.dispatchEvent(PlayEvent(currentTime: event.currentTime));
    }.toJS;

    playingEventListener = (PlayingEventJS event) {
      _eventManager.dispatchEvent(PlayingEvent(currentTime: event.currentTime));
    }.toJS;

    pauseEventListener = (PauseEventJS event) {
      _eventManager.dispatchEvent(PauseEvent(currentTime: event.currentTime));
    }.toJS;

    waitingEventListener = (WaitingEventJS event) {
      _eventManager.dispatchEvent(WaitingEvent(currentTime: event.currentTime));
    }.toJS;

    durationChangeEventListener = (DurationChangeEventJS event) {
      _eventManager.dispatchEvent(DurationChangeEvent(duration: event.duration));
    }.toJS;

    progressEventListener = (ProgressEventJS event) {
      _eventManager.dispatchEvent(ProgressEvent(currentTime: event.currentTime));
    }.toJS;

    rateChangeEventListener = (RateChangeEventJS event) {
      _eventManager.dispatchEvent(RateChangeEvent(currentTime: event.currentTime, playbackRate: event.playbackRate));
    }.toJS;

    seekingEventListener = (SeekingEventJS event) {
      _eventManager.dispatchEvent(SeekingEvent(currentTime: event.currentTime));
    }.toJS;

    seekedEventListener = (SeekedEventJS event) {
      _eventManager.dispatchEvent(SeekedEvent(currentTime: event.currentTime));
    }.toJS;

    volumeChangeEventListener = (VolumeChangeEventJS event) {
      _eventManager.dispatchEvent(VolumeChangeEvent(currentTime: event.currentTime, volume: event.volume));
    }.toJS;

    resizeEventListener = (ResizeEventJS event) {
      _eventManager.dispatchEvent(ResizeEvent(currentTime: _theoplayerJS.currentTime, width: _theoplayerJS.videoWidth, height: _theoplayerJS.videoHeight));
    }.toJS;

    endedEventListener = (EndedEventJS event) {
      _eventManager.dispatchEvent(EndedEvent(currentTime: event.currentTime));
    }.toJS;

    errorEventListener = (ErrorEventJS event) {
      _eventManager.dispatchEvent(ErrorEvent(error: event.error));
    }.toJS;

    destroyEventListener = (DestroyEventJS event) {
      _eventManager.dispatchEvent(DestroyEvent());
    }.toJS;

    readyStateChangeEventListener = (ReadyStateChangeEventJS event) {
      _eventManager.dispatchEvent(ReadyStateChangeEvent(currentTime: event.currentTime, readyState: toFlutterReadyState(event.readyState)));
    }.toJS;

    loadStartEventListener = (LoadedDataEventJS event) {
      _eventManager.dispatchEvent(LoadStartEvent());
    }.toJS;

    loadedMetadataEventListener = (LoadedMetadataEventJS event) {
      _eventManager.dispatchEvent(LoadedMetadataEvent(currentTime: event.currentTime));
    }.toJS;

    loadedDataEventListener = (LoadedDataEventJS event) {
      _eventManager.dispatchEvent(LoadedDataEvent(currentTime: event.currentTime));
    }.toJS;

    canPlayThroughEventListener = (CanPlayThroughEventJS event) {
      _eventManager.dispatchEvent(CanPlayThroughEvent(currentTime: event.currentTime));
    }.toJS;

    sourceChangeEventListener = (SourceChangeEventJS event) {
      _eventManager.dispatchEvent(SourceChangeEvent(source: toFlutterSourceDescription(event.source)));
    }.toJS;

    attachEventListeners();
  }

  void attachEventListeners() {
    _theoplayerJS.addEventListener(PlayerEventTypes.PLAY.toLowerCase(), playEventListener);
    _theoplayerJS.addEventListener(PlayerEventTypes.PLAYING.toLowerCase(), playingEventListener);
    _theoplayerJS.addEventListener(PlayerEventTypes.PAUSE.toLowerCase(), pauseEventListener);
    _theoplayerJS.addEventListener(PlayerEventTypes.WAITING.toLowerCase(), waitingEventListener);
    _theoplayerJS.addEventListener(PlayerEventTypes.DURATIONCHANGE.toLowerCase(), durationChangeEventListener);
    _theoplayerJS.addEventListener(PlayerEventTypes.PROGRESS.toLowerCase(), progressEventListener);
    _theoplayerJS.addEventListener(PlayerEventTypes.TIMEUPDATE.toLowerCase(), timeUpdateEventListener);
    _theoplayerJS.addEventListener(PlayerEventTypes.RATECHANGE.toLowerCase(), rateChangeEventListener);
    _theoplayerJS.addEventListener(PlayerEventTypes.SEEKING.toLowerCase(), seekingEventListener);
    _theoplayerJS.addEventListener(PlayerEventTypes.SEEKED.toLowerCase(), seekedEventListener);
    _theoplayerJS.addEventListener(PlayerEventTypes.VOLUMECHANGE.toLowerCase(), volumeChangeEventListener);
    _theoplayerJS.addEventListener(PlayerEventTypes.RESIZE.toLowerCase(), resizeEventListener);
    _theoplayerJS.addEventListener(PlayerEventTypes.ENDED.toLowerCase(), endedEventListener);
    _theoplayerJS.addEventListener(PlayerEventTypes.ERROR.toLowerCase(), errorEventListener);
    _theoplayerJS.addEventListener(PlayerEventTypes.DESTROY.toLowerCase(), destroyEventListener);
    _theoplayerJS.addEventListener(PlayerEventTypes.READYSTATECHANGE.toLowerCase(), readyStateChangeEventListener);
    _theoplayerJS.addEventListener(PlayerEventTypes.LOADSTART.toLowerCase(), loadStartEventListener);
    _theoplayerJS.addEventListener(PlayerEventTypes.LOADEDMETADATA.toLowerCase(), loadedMetadataEventListener);
    _theoplayerJS.addEventListener(PlayerEventTypes.LOADEDDATA.toLowerCase(), loadedDataEventListener);
    _theoplayerJS.addEventListener(PlayerEventTypes.CANPLAY.toLowerCase(), canPlayEventListener);
    _theoplayerJS.addEventListener(PlayerEventTypes.CANPLAYTHROUGH.toLowerCase(), canPlayThroughEventListener);
    _theoplayerJS.addEventListener(PlayerEventTypes.SOURCECHANGE.toLowerCase(), sourceChangeEventListener);
  }

  void detachEventListeners() {
    _theoplayerJS.removeEventListener(PlayerEventTypes.PLAY.toLowerCase(), playEventListener);
    _theoplayerJS.removeEventListener(PlayerEventTypes.PLAYING.toLowerCase(), playingEventListener);
    _theoplayerJS.removeEventListener(PlayerEventTypes.PAUSE.toLowerCase(), pauseEventListener);
    _theoplayerJS.removeEventListener(PlayerEventTypes.WAITING.toLowerCase(), waitingEventListener);
    _theoplayerJS.removeEventListener(PlayerEventTypes.DURATIONCHANGE.toLowerCase(), durationChangeEventListener);
    _theoplayerJS.removeEventListener(PlayerEventTypes.PROGRESS.toLowerCase(), progressEventListener);
    _theoplayerJS.removeEventListener(PlayerEventTypes.TIMEUPDATE.toLowerCase(), timeUpdateEventListener);
    _theoplayerJS.removeEventListener(PlayerEventTypes.RATECHANGE.toLowerCase(), rateChangeEventListener);
    _theoplayerJS.removeEventListener(PlayerEventTypes.SEEKING.toLowerCase(), seekingEventListener);
    _theoplayerJS.removeEventListener(PlayerEventTypes.SEEKED.toLowerCase(), seekedEventListener);
    _theoplayerJS.removeEventListener(PlayerEventTypes.VOLUMECHANGE.toLowerCase(), volumeChangeEventListener);
    _theoplayerJS.removeEventListener(PlayerEventTypes.RESIZE.toLowerCase(), resizeEventListener);
    _theoplayerJS.removeEventListener(PlayerEventTypes.ENDED.toLowerCase(), endedEventListener);
    _theoplayerJS.removeEventListener(PlayerEventTypes.ERROR.toLowerCase(), errorEventListener);
    _theoplayerJS.removeEventListener(PlayerEventTypes.DESTROY.toLowerCase(), destroyEventListener);
    _theoplayerJS.removeEventListener(PlayerEventTypes.READYSTATECHANGE.toLowerCase(), readyStateChangeEventListener);
    _theoplayerJS.removeEventListener(PlayerEventTypes.LOADSTART.toLowerCase(), loadStartEventListener);
    _theoplayerJS.removeEventListener(PlayerEventTypes.LOADEDMETADATA.toLowerCase(), loadedMetadataEventListener);
    _theoplayerJS.removeEventListener(PlayerEventTypes.LOADEDDATA.toLowerCase(), loadedDataEventListener);
    _theoplayerJS.removeEventListener(PlayerEventTypes.CANPLAY.toLowerCase(), canPlayEventListener);
    _theoplayerJS.removeEventListener(PlayerEventTypes.CANPLAYTHROUGH.toLowerCase(), canPlayThroughEventListener);
    _theoplayerJS.removeEventListener(PlayerEventTypes.SOURCECHANGE.toLowerCase(), sourceChangeEventListener);
  }

  void removeEventListener(String eventType, EventListener<Event> listener) {
    _eventManager.removeEventListener(eventType, listener);
  }

  void addEventListener(String eventType, EventListener<Event> listener) {
    _eventManager.addEventListener(eventType, listener);
  }

  void clear() {
    _eventManager.clear();
  }
}
