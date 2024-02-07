import 'dart:js_util';

import 'package:flutter_theoplayer_sdk_platform_interface/theoplayer_event_dispatcher_interface.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/theoplayer_event_manager.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/theoplayer_events.dart';
import 'package:flutter_theoplayer_sdk_web/theoplayer_api_event_web.dart';
import 'package:flutter_theoplayer_sdk_web/theoplayer_api_web.dart';
import 'package:flutter_theoplayer_sdk_web/transformers_web.dart';

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

    canPlayEventListener = allowInterop((CanPlayEventJS event) {
      _eventManager.dispatchEvent(CanPlayEvent(currentTime: event.currentTime));
    });

    timeUpdateEventListener = allowInterop((TimeUpdateEventJS event) {
      _eventManager.dispatchEvent(TimeUpdateEvent(currentTime: event.currentTime, currentProgramDateTime: event.currentProgramDateTime?.getTime()));
    });

    playEventListener = allowInterop((PlayEventJS event) {
      _eventManager.dispatchEvent(PlayEvent(currentTime: event.currentTime));
    });

    playingEventListener = allowInterop((PlayingEventJS event) {
      _eventManager.dispatchEvent(PlayingEvent(currentTime: event.currentTime));
    });

    pauseEventListener = allowInterop((PauseEventJS event) {
      _eventManager.dispatchEvent(PauseEvent(currentTime: event.currentTime));
    });

    waitingEventListener = allowInterop((WaitingEventJS event) {
      _eventManager.dispatchEvent(WaitingEvent(currentTime: event.currentTime));
    });

    durationChangeEventListener = allowInterop((DurationChangeEventJS event) {
      _eventManager.dispatchEvent(DurationChangeEvent(duration: event.duration));
    });

    progressEventListener = allowInterop((ProgressEventJS event) {
      _eventManager.dispatchEvent(ProgressEvent(currentTime: event.currentTime));
    });

    rateChangeEventListener = allowInterop((RateChangeEventJS event) {
      _eventManager.dispatchEvent(RateChangeEvent(currentTime: event.currentTime, playbackRate: event.playbackRate));
    });

    seekingEventListener = allowInterop((SeekingEventJS event) {
      _eventManager.dispatchEvent(SeekingEvent(currentTime: event.currentTime));
    });

    seekedEventListener = allowInterop((SeekedEventJS event) {
      _eventManager.dispatchEvent(SeekedEvent(currentTime: event.currentTime));
    });

    volumeChangeEventListener = allowInterop((VolumeChangeEventJS event) {
      _eventManager.dispatchEvent(VolumeChangeEvent(currentTime: event.currentTime, volume: event.volume));
    });

    resizeEventListener = allowInterop((ResizeEventJS event) {
      _eventManager.dispatchEvent(ResizeEvent(currentTime: _theoplayerJS.currentTime, width: _theoplayerJS.videoWidth, height: _theoplayerJS.videoHeight));
    });

    endedEventListener = allowInterop((EndedEventJS event) {
      _eventManager.dispatchEvent(EndedEvent(currentTime: event.currentTime));
    });

    errorEventListener  = allowInterop((ErrorEventJS event){
      _eventManager.dispatchEvent(ErrorEvent(error: event.error));
    });

    destroyEventListener = allowInterop((DestroyEventJS event) {
      _eventManager.dispatchEvent(DestroyEvent());
    });

    readyStateChangeEventListener = allowInterop((ReadyStateChangeEventJS event) {
      _eventManager.dispatchEvent(ReadyStateChangeEvent(currentTime: event.currentTime, readyState: toFlutterReadyState(event.readyState)));
    });

    loadStartEventListener = allowInterop((LoadedDataEventJS event) {
      _eventManager.dispatchEvent(LoadStartEvent());
    });

    loadedMetadataEventListener = allowInterop((LoadedMetadataEventJS event) {
      _eventManager.dispatchEvent(LoadedMetadataEvent(currentTime: event.currentTime));
    });

    loadedDataEventListener = allowInterop((LoadedDataEventJS event) {
      _eventManager.dispatchEvent(LoadedDataEvent(currentTime: event.currentTime));
    });

    canPlayThroughEventListener = allowInterop((CanPlayThroughEventJS event) {
      _eventManager.dispatchEvent(CanPlayThroughEvent(currentTime: event.currentTime));
    });

    sourceChangeEventListener = allowInterop((SourceChangeEventJS event) {
      _eventManager.dispatchEvent(SourceChangeEvent(source: toFlutterSourceDescription(event.source)));
    });

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
