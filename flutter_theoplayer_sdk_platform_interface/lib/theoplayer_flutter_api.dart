import 'package:flutter/services.dart';
import 'package:theoplayer_platform_interface/pigeon/apis.g.dart';
import 'package:theoplayer_platform_interface/theoplayer_event_dispatcher_interface.dart';
import 'package:theoplayer_platform_interface/theoplayer_event_manager.dart';
import 'package:theoplayer_platform_interface/theoplayer_events.dart';

class THEOplayerFlutterAPIImpl implements THEOplayerFlutterAPI, EventDispatcher {
  final EventManager _eventManager = EventManager();

  THEOplayerFlutterAPIImpl({BinaryMessenger? binaryMessenger}) {
    THEOplayerFlutterAPI.setup(this, binaryMessenger: binaryMessenger);
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
  void onSourceChange(SourceDescription? source) {
    _eventManager.dispatchEvent(SourceChangeEvent(source: source));
  }

  @override
  void onPlay(double currentTime) {
    _eventManager.dispatchEvent(PlayEvent(currentTime: currentTime));
  }

  @override
  void onPlaying(double currentTime) {
    _eventManager.dispatchEvent(PlayingEvent(currentTime: currentTime));
  }

  @override
  void onPause(double currentTime) {
    _eventManager.dispatchEvent(PauseEvent(currentTime: currentTime));
  }

  @override
  void onWaiting(double currentTime) {
    _eventManager.dispatchEvent(WaitingEvent(currentTime: currentTime));
  }

  @override
  void onDurationChange(double duration) {
    _eventManager.dispatchEvent(DurationChangeEvent(duration: duration));
  }

  @override
  void onProgress(double currentTime) {
    _eventManager.dispatchEvent(ProgressEvent(currentTime: currentTime));
  }

  @override
  void onTimeUpdate(double currentTime, int? currentProgramDateTime) {
    _eventManager.dispatchEvent(TimeUpdateEvent(currentTime: currentTime, currentProgramDateTime: currentProgramDateTime));
  }

  @override
  void onRateChange(double currentTime, double playbackRate) {
    _eventManager.dispatchEvent(RateChangeEvent(currentTime: currentTime, playbackRate: playbackRate));
  }

  @override
  void onSeeking(double currentTime) {
    _eventManager.dispatchEvent(SeekingEvent(currentTime: currentTime));
  }

  @override
  void onSeeked(double currentTime) {
    _eventManager.dispatchEvent(SeekedEvent(currentTime: currentTime));
  }

  @override
  void onVolumeChange(double currentTime, double volume) {
    _eventManager.dispatchEvent(VolumeChangeEvent(currentTime: currentTime, volume: volume));
  }

  @override
  void onResize(double currentTime, int width, int height) {
    _eventManager.dispatchEvent(ResizeEvent(currentTime: currentTime, width: width, height: height));
  }

  @override
  void onEnded(double currentTime) {
    _eventManager.dispatchEvent(EndedEvent(currentTime: currentTime));
  }

  @override
  void onError(String error) {
    _eventManager.dispatchEvent(ErrorEvent(error: error));
  }

  @override
  void onDestroy() {
    _eventManager.dispatchEvent(DestroyEvent());
  }

  @override
  void onReadyStateChange(double currentTime, ReadyState readyState) {
    _eventManager.dispatchEvent(ReadyStateChangeEvent(currentTime: currentTime, readyState: readyState));
  }

  @override
  void onLoadStart() {
    _eventManager.dispatchEvent(LoadStartEvent());
  }

  @override
  void onLoadedMetadata(double currentTime) {
    _eventManager.dispatchEvent(LoadedMetadataEvent(currentTime: currentTime));
  }

  @override
  void onLoadedData(double currentTime) {
    _eventManager.dispatchEvent(LoadedDataEvent(currentTime: currentTime));
  }

  @override
  void onCanPlay(double currentTime) {
    _eventManager.dispatchEvent(CanPlayEvent(currentTime: currentTime));
  }

  @override
  void onCanPlayThrough(double currentTime) {
    _eventManager.dispatchEvent(CanPlayThroughEvent(currentTime: currentTime));
  }

  void dispose() {
    _eventManager.clear();
  }
}
