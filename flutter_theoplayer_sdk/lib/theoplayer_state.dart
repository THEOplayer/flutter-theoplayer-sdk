import 'package:theoplayer_platform_interface/theoplayer_event_manager.dart';
import 'package:theoplayer/theoplayer.dart';

//TODO: move this into theoplayer.dart

/// Internal Flutter representation of the underlying native THEOplayer state.
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
  bool allowBackgroundPlayback = false;
  String? error;

  bool isInitialized = false;

  PresentationMode _presenationMode = PresentationMode.INLINE;

  PresentationMode get presentationMode {
    return _presenationMode;
  }

  set presentationMode(PresentationMode presentationMode) {
    _presenationMode = presentationMode;
    eventManager.dispatchEvent(PresentationModeChangeEvent(currentTime: currentTime, presentationMode: presentationMode));
    _stateChangeListener?.call();
  }

  PlayerState() {
    resetState();
  }

  /// Method to setup the connection with the platform-specific [THEOplayerViewController] classes.
  void setViewController(THEOplayerViewController theoPlayerViewController) {
    _theoPlayerViewController = theoPlayerViewController;
    _attachEventListeners();
  }

  /// Use it signal that the native player creation is done.
  void initialized() {
    isInitialized = true;
    _stateChangeListener?.call();
  }

  void _attachEventListeners() {
    _theoPlayerViewController.addEventListener(PlayerEventTypes.SOURCECHANGE, _sourceChangeEventListener);
    _theoPlayerViewController.addEventListener(PlayerEventTypes.PLAY, _playEventListener);
    _theoPlayerViewController.addEventListener(PlayerEventTypes.PLAYING, _playingEventListener);
    _theoPlayerViewController.addEventListener(PlayerEventTypes.PAUSE, _pauseEventListener);
    _theoPlayerViewController.addEventListener(PlayerEventTypes.WAITING, _waitingEventListener);
    _theoPlayerViewController.addEventListener(PlayerEventTypes.DURATIONCHANGE, _durationChangeEventListener);
    _theoPlayerViewController.addEventListener(PlayerEventTypes.PROGRESS, _progressEventListener);
    _theoPlayerViewController.addEventListener(PlayerEventTypes.TIMEUPDATE, _timeUpdateEventListener);
    _theoPlayerViewController.addEventListener(PlayerEventTypes.RATECHANGE, _rateChangeEventListener);
    _theoPlayerViewController.addEventListener(PlayerEventTypes.SEEKING, _seekingEventListener);
    _theoPlayerViewController.addEventListener(PlayerEventTypes.SEEKED, _seekedEventListener);
    _theoPlayerViewController.addEventListener(PlayerEventTypes.VOLUMECHANGE, _volumeChangeEventListener);
    _theoPlayerViewController.addEventListener(PlayerEventTypes.RESIZE, _resizeEventListener);
    _theoPlayerViewController.addEventListener(PlayerEventTypes.ENDED, _endedEventListener);
    _theoPlayerViewController.addEventListener(PlayerEventTypes.ERROR, _errorEventListener);
    _theoPlayerViewController.addEventListener(PlayerEventTypes.DESTROY, _destroyEventListener);
    _theoPlayerViewController.addEventListener(PlayerEventTypes.READYSTATECHANGE, _readyStateChangeEventListener);
  }

  void _removeEventListeners() {
    _theoPlayerViewController.removeEventListener(PlayerEventTypes.SOURCECHANGE, _sourceChangeEventListener);
    _theoPlayerViewController.removeEventListener(PlayerEventTypes.PLAY, _playEventListener);
    _theoPlayerViewController.removeEventListener(PlayerEventTypes.PLAYING, _playingEventListener);
    _theoPlayerViewController.removeEventListener(PlayerEventTypes.PAUSE, _pauseEventListener);
    _theoPlayerViewController.removeEventListener(PlayerEventTypes.WAITING, _waitingEventListener);
    _theoPlayerViewController.removeEventListener(PlayerEventTypes.DURATIONCHANGE, _durationChangeEventListener);
    _theoPlayerViewController.removeEventListener(PlayerEventTypes.PROGRESS, _progressEventListener);
    _theoPlayerViewController.removeEventListener(PlayerEventTypes.TIMEUPDATE, _timeUpdateEventListener);
    _theoPlayerViewController.removeEventListener(PlayerEventTypes.RATECHANGE, _rateChangeEventListener);
    _theoPlayerViewController.removeEventListener(PlayerEventTypes.SEEKING, _seekingEventListener);
    _theoPlayerViewController.removeEventListener(PlayerEventTypes.SEEKED, _seekedEventListener);
    _theoPlayerViewController.removeEventListener(PlayerEventTypes.VOLUMECHANGE, _volumeChangeEventListener);
    _theoPlayerViewController.removeEventListener(PlayerEventTypes.RESIZE, _resizeEventListener);
    _theoPlayerViewController.removeEventListener(PlayerEventTypes.ENDED, _endedEventListener);
    _theoPlayerViewController.removeEventListener(PlayerEventTypes.ERROR, _errorEventListener);
    _theoPlayerViewController.removeEventListener(PlayerEventTypes.DESTROY, _destroyEventListener);
    _theoPlayerViewController.removeEventListener(PlayerEventTypes.READYSTATECHANGE, _readyStateChangeEventListener);
  }

  /// Sets a [StateChangeListener] that gets triggered on every state change.
  void setStateListener(StateChangeListener listener) {
    _stateChangeListener = listener;
  }

  void _sourceChangeEventListener(Event event) {
    source = (event as SourceChangeEvent).source;
    eventManager.dispatchEvent(event);
    _stateChangeListener?.call();
  }

  void _playEventListener(Event event) {
    isPaused = false;
    isEnded = false;
    eventManager.dispatchEvent(event);
    _stateChangeListener?.call();
  }

  void _playingEventListener(Event event) {
    eventManager.dispatchEvent(event);
    _stateChangeListener?.call();
  }

  void _pauseEventListener(Event event) {
    isPaused = true;
    eventManager.dispatchEvent(event);
    _stateChangeListener?.call();
  }

  void _waitingEventListener(Event event) {
    eventManager.dispatchEvent(event);
    _stateChangeListener?.call();
  }

  void _durationChangeEventListener(Event event) {
    duration = (event as DurationChangeEvent).duration;
    eventManager.dispatchEvent(event);
    _stateChangeListener?.call();
  }

  void _progressEventListener(Event event) {
    _theoPlayerViewController.getBuffered().then((value) => buffered = value);
    _theoPlayerViewController.getSeekable().then((value) => seekable = value);
    _theoPlayerViewController.getPlayed().then((value) => played = value);
    eventManager.dispatchEvent(event);
    _stateChangeListener?.call();
  }

  void _timeUpdateEventListener(Event event) {
    TimeUpdateEvent timeupdateEvent = event as TimeUpdateEvent;
    currentTime = timeupdateEvent.currentTime;
    int? programDateTime = timeupdateEvent.currentProgramDateTime;
    if (programDateTime == null) {
      currentProgramDateTime = null;
    } else {
      DateTime.fromMillisecondsSinceEpoch(programDateTime);
    }
    eventManager.dispatchEvent(event);
    _stateChangeListener?.call();
  }

  void _rateChangeEventListener(Event event) {
    playbackRate = (event as RateChangeEvent).playbackRate;
    eventManager.dispatchEvent(event);
    _stateChangeListener?.call();
  }

  void _seekingEventListener(Event event) {
    isSeeking = true;
    isEnded = false;
    eventManager.dispatchEvent(event);
    _stateChangeListener?.call();
  }

  void _seekedEventListener(Event event) {
    isSeeking = false;
    eventManager.dispatchEvent(event);
    _stateChangeListener?.call();
  }

  void _volumeChangeEventListener(Event event) {
    volume = (event as VolumeChangeEvent).volume;
    eventManager.dispatchEvent(event);
    _stateChangeListener?.call();
  }

  void _resizeEventListener(Event event) {
    ResizeEvent resizeEvent = event as ResizeEvent;
    videoWidth = resizeEvent.width;
    videoHeight = resizeEvent.height;
    eventManager.dispatchEvent(event);
    _stateChangeListener?.call();
  }

  void _endedEventListener(Event event) {
    isEnded = true;
    eventManager.dispatchEvent(event);
    _stateChangeListener?.call();
  }

  void _errorEventListener(Event event) {
    error = (event as ErrorEvent).error;
    eventManager.dispatchEvent(event);
    _stateChangeListener?.call();
  }

  void _destroyEventListener(Event event) {
    resetState();
    eventManager.dispatchEvent(event);
    _stateChangeListener?.call();
  }

  void _readyStateChangeEventListener(Event event) {
    readyState = (event as ReadyStateChangeEvent).readyState;
    eventManager.dispatchEvent(event);
    _stateChangeListener?.call();
  }

  /// Method to reset the player state.
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
    _presenationMode = PresentationMode.INLINE;
  }

  /// Method to clean the internal state on player dispose.
  void dispose() {
    isInitialized = false;
    _removeEventListeners();
    eventManager.clear();
    resetState();
  }
}
