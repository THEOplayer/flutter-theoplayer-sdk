import 'package:flutter_theoplayer_sdk_platform_interface/theoplayer_event_manager.dart';
import 'package:theoplayer/theoplayer.dart';

class PlayerState {
  late THEOplayerViewController _theoPlayerViewController;
  StateChangeListener? _stateChangeListener;

  //TODO: find a better place and better access control?
  EventManager eventManager = EventManager();

  SourceDescription? source;
  bool isAutoplay = false;
  bool isPaused = true;
  double currentTime = 0.0;
  DateTime? currentProgramDateTime;
  double duration = 0.0;
  double playbackRate = 0.0;
  double volume = 1.0;
  bool muted = false;
  PreloadType preload = PreloadType.none;
  ReadyState readyState = ReadyState.have_nothing;
  bool isSeeking = false;
  bool isEnded = false;
  int videoWidth = 0;
  int videoHeight = 0;
  List<TimeRange?> buffered = [];
  List<TimeRange?> seekable = [];
  List<TimeRange?> played = [];
  String? error;

  bool isInitialized = false;

  PlayerState() {
    resetState();
  }

  void setViewController(THEOplayerViewController theoPlayerViewController) {
    _theoPlayerViewController = theoPlayerViewController;
    _attachEventListeners();
  }

  void initialized() {
    isInitialized = true;
    _stateChangeListener?.call();
  }

  void _attachEventListeners() {
    _theoPlayerViewController.addEventListener(PlayerEventTypes.SOURCECHANGE, sourceChangeEventListener);
    _theoPlayerViewController.addEventListener(PlayerEventTypes.PLAY, playEventListener);
    _theoPlayerViewController.addEventListener(PlayerEventTypes.PLAYING, playingEventListener);
    _theoPlayerViewController.addEventListener(PlayerEventTypes.PAUSE, pauseEventListener);
    _theoPlayerViewController.addEventListener(PlayerEventTypes.WAITING, waitingEventListener);
    _theoPlayerViewController.addEventListener(PlayerEventTypes.DURATIONCHANGE, durationChangeEventListener);
    _theoPlayerViewController.addEventListener(PlayerEventTypes.PROGRESS, progressEventListener);
    _theoPlayerViewController.addEventListener(PlayerEventTypes.TIMEUPDATE, timeUpdateEventListener);
    _theoPlayerViewController.addEventListener(PlayerEventTypes.RATECHANGE, rateChangeEventListener);
    _theoPlayerViewController.addEventListener(PlayerEventTypes.SEEKING, seekingEventListener);
    _theoPlayerViewController.addEventListener(PlayerEventTypes.SEEKED, seekedEventListener);
    _theoPlayerViewController.addEventListener(PlayerEventTypes.VOLUMECHANGE, volumeChangeEventListener);
    _theoPlayerViewController.addEventListener(PlayerEventTypes.RESIZE, resizeEventListener);
    _theoPlayerViewController.addEventListener(PlayerEventTypes.ENDED, endedEventListener);
    _theoPlayerViewController.addEventListener(PlayerEventTypes.ERROR, errorEventListener);
    _theoPlayerViewController.addEventListener(PlayerEventTypes.DESTROY, destroyEventListener);
    _theoPlayerViewController.addEventListener(PlayerEventTypes.READYSTATECHANGE, readyStateChangeEventListener);
  }

  void _removeEventListeners() {
    _theoPlayerViewController.removeEventListener(PlayerEventTypes.SOURCECHANGE, sourceChangeEventListener);
    _theoPlayerViewController.removeEventListener(PlayerEventTypes.PLAY, playEventListener);
    _theoPlayerViewController.removeEventListener(PlayerEventTypes.PLAYING, playingEventListener);
    _theoPlayerViewController.removeEventListener(PlayerEventTypes.PAUSE, pauseEventListener);
    _theoPlayerViewController.removeEventListener(PlayerEventTypes.WAITING, waitingEventListener);
    _theoPlayerViewController.removeEventListener(PlayerEventTypes.DURATIONCHANGE, durationChangeEventListener);
    _theoPlayerViewController.removeEventListener(PlayerEventTypes.PROGRESS, progressEventListener);
    _theoPlayerViewController.removeEventListener(PlayerEventTypes.TIMEUPDATE, timeUpdateEventListener);
    _theoPlayerViewController.removeEventListener(PlayerEventTypes.RATECHANGE, rateChangeEventListener);
    _theoPlayerViewController.removeEventListener(PlayerEventTypes.SEEKING, seekingEventListener);
    _theoPlayerViewController.removeEventListener(PlayerEventTypes.SEEKED, seekedEventListener);
    _theoPlayerViewController.removeEventListener(PlayerEventTypes.VOLUMECHANGE, volumeChangeEventListener);
    _theoPlayerViewController.removeEventListener(PlayerEventTypes.RESIZE, resizeEventListener);
    _theoPlayerViewController.removeEventListener(PlayerEventTypes.ENDED, endedEventListener);
    _theoPlayerViewController.removeEventListener(PlayerEventTypes.ERROR, errorEventListener);
    _theoPlayerViewController.removeEventListener(PlayerEventTypes.DESTROY, destroyEventListener);
    _theoPlayerViewController.removeEventListener(PlayerEventTypes.READYSTATECHANGE, readyStateChangeEventListener);
  }

  void setStateListener(StateChangeListener listener) {
    _stateChangeListener = listener;
  }

  void sourceChangeEventListener(Event event) {
    source = (event as SourceChangeEvent).source;
    eventManager.dispatchEvent(event);
    _stateChangeListener?.call();
  }

  void playEventListener(Event event) {
    isPaused = false;
    isEnded = false;
    eventManager.dispatchEvent(event);
    _stateChangeListener?.call();
  }

  void playingEventListener(Event event) {
    eventManager.dispatchEvent(event);
    _stateChangeListener?.call();
  }

  void pauseEventListener(Event event) {
    isPaused = true;
    eventManager.dispatchEvent(event);
    _stateChangeListener?.call();
  }

  void waitingEventListener(Event event) {
    eventManager.dispatchEvent(event);
    _stateChangeListener?.call();
  }

  void durationChangeEventListener(Event event) {
    duration = (event as DurationChangeEvent).duration;
    eventManager.dispatchEvent(event);
    _stateChangeListener?.call();
  }

  void progressEventListener(Event event) {
    _theoPlayerViewController.getBuffered().then((value) => buffered = value);
    _theoPlayerViewController.getSeekable().then((value) => seekable = value);
    _theoPlayerViewController.getPlayed().then((value) => played = value);
    eventManager.dispatchEvent(event);
    _stateChangeListener?.call();
  }

  void timeUpdateEventListener(Event event) {
    currentTime = (event as TimeUpdateEvent).currentTime;
    int? programDateTime = (event as TimeUpdateEvent).currentProgramDateTime;
    if (programDateTime == null) {
      currentProgramDateTime = null;
    } else {
      DateTime.fromMillisecondsSinceEpoch(programDateTime);
    }
    eventManager.dispatchEvent(event);
    _stateChangeListener?.call();
  }

  void rateChangeEventListener(Event event) {
    playbackRate = (event as RateChangeEvent).playbackRate;
    eventManager.dispatchEvent(event);
    _stateChangeListener?.call();
  }

  void seekingEventListener(Event event) {
    isSeeking = true;
    isEnded = false;
    eventManager.dispatchEvent(event);
    _stateChangeListener?.call();
  }

  void seekedEventListener(Event event) {
    isSeeking = false;
    eventManager.dispatchEvent(event);
    _stateChangeListener?.call();
  }

  void volumeChangeEventListener(Event event) {
    volume = (event as VolumeChangeEvent).volume;
    eventManager.dispatchEvent(event);
    _stateChangeListener?.call();
  }

  void resizeEventListener(Event event) {
    videoWidth = (event as ResizeEvent).width;
    videoHeight = (event as ResizeEvent).height;
    eventManager.dispatchEvent(event);
    _stateChangeListener?.call();
  }

  void endedEventListener(Event event) {
    isEnded = true;
    eventManager.dispatchEvent(event);
    _stateChangeListener?.call();
  }

  void errorEventListener(Event event) {
    error = (event as ErrorEvent).error;
    eventManager.dispatchEvent(event);
    _stateChangeListener?.call();
  }

  void destroyEventListener(Event event) {
    resetState();
    eventManager.dispatchEvent(event);
    _stateChangeListener?.call();
  }

  void readyStateChangeEventListener(Event event) {
    readyState = (event as ReadyStateChangeEvent).readyState;
    eventManager.dispatchEvent(event);
    _stateChangeListener?.call();
  }

  void resetState() {
    source = null;
    isPaused = true;
    currentTime = 0.0;
    currentProgramDateTime = null;
    duration = 0.0;
    volume = 1.0;
    readyState = ReadyState.have_nothing;
    isSeeking = false;
    isEnded = false;
    videoWidth = 0;
    videoHeight = 0;
    buffered = [];
    seekable = [];
    played = [];
    error = null;
  }

  void dispose() {
    _removeEventListeners();
    eventManager.clear();
    resetState();
  }
}
