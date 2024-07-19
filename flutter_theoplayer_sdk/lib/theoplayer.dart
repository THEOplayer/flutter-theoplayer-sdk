import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:theoplayer/widget/fullscreen_widget.dart';
import 'package:theoplayer_platform_interface/pigeon/apis.g.dart';
import 'package:theoplayer_platform_interface/theopalyer_config.dart';
import 'package:theoplayer_platform_interface/theoplayer_event_dispatcher_interface.dart';
import 'package:theoplayer_platform_interface/theoplayer_events.dart';
import 'package:theoplayer_platform_interface/theoplayer_view_controller_interface.dart';
import 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_audiotrack.dart';
import 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_videotrack.dart';
import 'package:theoplayer_platform_interface/track/texttrack/theoplayer_texttrack.dart';
import 'package:theoplayer/theoplayer_state.dart';
import 'package:theoplayer/theoplayer_tracklist_wrapper.dart';
import 'package:theoplayer/theoplayer_view.dart';

// TODO: check this, quick fix for the main.dart
// TODO: move exports into a separate file
export 'package:theoplayer_platform_interface/pigeon/apis.g.dart';
export 'package:theoplayer_platform_interface/theopalyer_config.dart';
export 'package:theoplayer_platform_interface/theoplayer_events.dart';
export 'package:theoplayer_platform_interface/theoplayer_view_controller_interface.dart';
export 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_audiotrack.dart';
export 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_audiotrack_events.dart';
export 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_videotrack.dart';
export 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_videotrack_events.dart';
export 'package:theoplayer_platform_interface/track/texttrack/theoplayer_texttrack_events.dart';
export 'package:theoplayer_platform_interface/track/texttrack/theoplayer_texttrack.dart';
export 'package:theoplayer/widget/chromeless_widget.dart';
export 'package:theoplayer/widget/fullscreen_widget.dart';

/// Callback that's used at player creation.
/// This is called once the underlying native THEOplayerView is fully created and available to use.
typedef PlayerCreatedCallback = void Function();

/// Callback that's triggered every time the internal player state is changing. See [THEOplayer.setStateListener].
typedef StateChangeListener = void Function();

/// Signature for a function that builds a fullscreen widget given an [THEOplayer].
///
/// Used by [THEOplayer.fullscreenBuilder].
typedef FullscreenWidgetBuilder = Widget Function(BuildContext context, THEOplayer theoplayer);

/// Class to initialize and interact with THEOplayer
class THEOplayer implements EventDispatcher {
  final THEOplayerConfig theoPlayerConfig;
  final PlayerCreatedCallback? onCreate;
  late final FullscreenWidgetBuilder _fullscreenBuilder;
  late final PlayerState _playerState;
  late final THEOplayerView _tpv;
  late THEOplayerViewController? _theoPlayerViewController;
  AppLifecycleListener? _lifecycleListener;
  late BuildContext _currentContext;

  final globalKey = GlobalKey();

  final TextTracksHolder _textTrackListHolder = TextTracksHolder();
  final AudioTracksHolder _audioTrackListHolder = AudioTracksHolder();
  final VideoTracksHolder _videoTrackListHolder = VideoTracksHolder();

  /// Initialize THEOplayer with a [THEOplayerConfig].
  /// [onCreate] is called once the underlying native THEOplayerView is fully created and available to use.

  THEOplayer({required this.theoPlayerConfig, this.onCreate, FullscreenWidgetBuilder? fullscreenBuilder}) {
    _playerState = PlayerState();
    _tpv = THEOplayerView(
        key: globalKey,
        theoPlayerConfig: theoPlayerConfig,
        onCreated: (THEOplayerViewController viewController, BuildContext context) {
          _currentContext = context;
          _theoPlayerViewController = viewController;
          _playerState.setViewController(_theoPlayerViewController!);
          _textTrackListHolder.setup(viewController.getTextTracks());
          _audioTrackListHolder.setup(viewController.getAudioTracks());
          _videoTrackListHolder.setup(viewController.getVideoTracks());
          _setupLifeCycleListeners();
          onCreate?.call();
          _playerState.initialized();
        });
    _fullscreenBuilder = fullscreenBuilder ??
        (BuildContext context, THEOplayer theoplayer) {
          return FullscreenStatefulWidget(
            theoplayer: theoplayer,
            fullscreenConfig: theoPlayerConfig.fullscreenConfig,
          );
        };
  }

  void _setupLifeCycleListeners() {
    _lifecycleListener = AppLifecycleListener(onResume: () {
      _theoPlayerViewController?.onLifecycleResume();
    }, onPause: () {
      _theoPlayerViewController?.onLifecyclePause();
    }, onStateChange: (state) {
      if (kDebugMode) {
        print("THEOplayer: Detected lifecycle change: $state");
      }
    });
  }

  /// Returns the player widget that can be added to the view hierarchy to show videos
  Widget getView() {
    return _tpv;
  }

  /// List of text tracks of the current source.
  TextTracks getTextTracks() {
    return _textTrackListHolder;
  }

  /// List of audio tracks of the current source.
  AudioTracks getAudioTracks() {
    return _audioTrackListHolder;
  }

  /// List of video tracks of the current source.
  VideoTracks getVideoTracks() {
    return _videoTrackListHolder;
  }

  /// [StateChangeListener] that's triggered every time the internal player state is changing.
  /// For more granular control use [addEventListener] instead.
  void setStateListener(StateChangeListener listener) {
    _playerState.setStateListener(listener);
  }

  /// Set current source which describes desired playback of a media resource.
  void setSource(SourceDescription source) {
    _playerState.resetState();
    _theoPlayerViewController?.setSource(source: source);
  }

  /// The current source which describes desired playback of a media resource.
  ///
  /// Remarks:
  /// * Changing source will [stop] the previous source.
  SourceDescription? getSource() {
    return _playerState.source;
  }

  /// Set whether the player should immediately start playback after source change.
  void setAutoplay(bool autoplay) {
    _playerState.isAutoplay = autoplay;
    _theoPlayerViewController?.setAutoplay(autoplay);
  }

  /// The current value of whether the player should immediately start playback after source change.
  bool isAutoplay() {
    return _playerState.isAutoplay;
  }

  /// Start or resume playback.
  void play() {
    _theoPlayerViewController?.play();
  }

  /// Pause playback.
  void pause() {
    _theoPlayerViewController?.pause();
  }

  /// Whether the player is paused.
  bool isPaused() {
    return _playerState.isPaused;
  }

  /// Set the current playback position of the media, in seconds.
  void setCurrentTime(double currentTime) {
    _theoPlayerViewController?.setCurrentTime(currentTime);
  }

  /// The current playback position of the media, in seconds.
  double getCurrentTime() {
    return _playerState.currentTime;
  }

  /// Set the current playback position of the media, as a timestamp.
  void setCurrentProgramDateTime(DateTime currentProgramDateTime) {
    _theoPlayerViewController?.setCurrentProgramDateTime(currentProgramDateTime);
  }

  /// The current playback position of the media, as a timestamp.
  ///
  /// Remarks:
  /// * The relation between [getCurrentProgramDateTime] and [getCurrentTime] is determined by the manifest.
  DateTime? getCurrentProgramDateTime() {
    return _playerState.currentProgramDateTime;
  }

  /// The duration of the media, in seconds.
  double getDuration() {
    return _playerState.duration;
  }

  /// Set the playback rate of the media.
  ///
  /// Remarks:
  /// * Playback rate is represented by a number where 1 is default playback speed.
  /// * Playback rate must be a positive number.
  /// * It is recommended that you limit the range to between 0.5 and 4.
  ///
  /// Example:
  /// * playbackRate = 0.70 will slow down the playback rate of the media by 30%.
  /// * playbackRate = 1.25 will speed up the playback rate of the media by 25%.
  void setPlaybackRate(double playbackRate) {
    _playerState.playbackRate = playbackRate;
    _theoPlayerViewController?.setPlaybackRate(playbackRate);
  }

  /// The playback rate of the media.
  double getPlaybackRate() {
    return _playerState.playbackRate;
  }

  /// Set the volume of the audio.
  ///
  /// Remarks:
  /// * Volume is represented by a floating point number between 0.0 and 1.0.
  ///
  /// Example:
  /// * volume = 0.7 will reduce the audio volume of the media by 30%.
  void setVolume(double volume) {
    _theoPlayerViewController?.setVolume(volume);
  }

  /// The volume of the audio.
  double getVolume() {
    return _playerState.volume;
  }

  /// Set whether audio is muted.
  ///
  /// Remarks:
  /// * on Web only muted autplay is allowed.
  void setMuted(bool muted) {
    _playerState.muted = muted;
    _theoPlayerViewController?.setMuted(muted);
  }

  /// Whether audio is muted.
  bool isMuted() {
    return _playerState.muted;
  }

  /// The preload type of the player, represented by a value from the following list:
  /// * [PreloadType.none] : The player will not load anything on source change.
  /// * [PreloadType.metadata] : The player will immediately load metadata on source change.
  /// * [PreloadType.auto] : The player will immediately load metadata and media on source change.
  ///
  /// Remarks:
  /// * 'metadata' loads enough resources to be able to determine the [THEOplayer.getDuration].
  /// * 'auto' loads media up to ABRConfiguration.targetBuffer.
  ///
  /// * ABRConfiguration is not exposed yet in Flutter.
  void setPreload(PreloadType preload) {
    _playerState.preload = preload;
    _theoPlayerViewController?.setPreload(preload);
  }

  /// The preload setting of the player.
  PreloadType getPreload() {
    return _playerState.preload;
  }

  /// The ready state of the player, represented by a value from the following list:
  /// * [ReadyState.have_nothing] : The player has no information about the duration of its source.
  /// * [ReadyState.have_metadata] : The player has information about the duration of its source.
  /// * [ReadyState.have_current_data] : The player has its current frame in its buffer.
  /// * [ReadyState.have_future_data] : The player has enough data for immediate playback.
  /// * [ReadyState.have_enough_data] : The player has enough data for continuous playback.
  ReadyState getReadyState() {
    return _playerState.readyState;
  }

  /// Whether the player is seeking.
  bool isSeeking() {
    return _playerState.isSeeking;
  }

  bool isInitialized() {
    return _playerState.isInitialized;
  }

  /// Whether playback of the media is ended.
  bool isEnded() {
    return _playerState.isEnded;
  }

  /// The width of the active video rendition, in pixels.
  int getVideoWidth() {
    return _playerState.videoWidth;
  }

  /// The height of the active video rendition, in pixels.
  int getVideoHeight() {
    return _playerState.videoHeight;
  }

  /// Returns a [TimeRange] list object that represents the ranges of the media resource that the player has buffered.
  List<TimeRange?> getBuffered() {
    return _playerState.buffered;
  }

  /// Returns a [TimeRange] list object that represents the ranges of the media resource that are seekable by the player.
  ///
  /// Remarks:
  /// * On source change, seekable becomes available after [getReadyState] is at least HAVE_METADATA.
  List<TimeRange?> getSeekable() {
    return _playerState.seekable;
  }

  /// Returns a [TimeRange] list object that represents the ranges of the media resource that the player has played.
  List<TimeRange?> getPlayed() {
    return _playerState.played;
  }

  /// Set whether playback continues when the app goes to background.
  ///
  /// Remarks:
  /// * on Web this flag has no impact.
  void setAllowBackgroundPlayback(bool allowBackgroundPlayback) {
    _playerState.allowBackgroundPlayback = allowBackgroundPlayback;
    _theoPlayerViewController?.setAllowBackgroundPlayback(allowBackgroundPlayback);
  }

  /// Whether playback continues when the app goes to background.
  bool allowBackgroundPlayback() {
    return _playerState.allowBackgroundPlayback;
  }

  /// The last error that occurred for the current source, if any.
  String? getError() {
    return _playerState.error;
  }

  /// Stop playback.
  ///
  /// Remarks:
  /// * All resources associated with the current source are released.
  /// * The player can be reused by setting a new source with [setSource].
  void stop() {
    _theoPlayerViewController?.stop();
    _playerState.resetState();
  }

  PresentationMode getPresentationMode() {
    return _playerState.presentationMode;
  }

  void setPresentationMode(PresentationMode presentationMode) {
    if (_playerState.presentationMode == presentationMode) {
      return;
    }

    PresentationMode previousPresentationMode = _playerState.presentationMode;
    _playerState.presentationMode = presentationMode;

    Future? fullscreenPresentingFuture;

    switch (presentationMode) {
      case PresentationMode.FULLSCREEN:
        fullscreenPresentingFuture = Navigator.of(_currentContext, rootNavigator: true).push(MaterialPageRoute(
            builder: (context) {
              return _fullscreenBuilder(context, this);
            },
            settings: null));

        fullscreenPresentingFuture.then((value) => restorePlayerStateAfterLeavingFullscreen());

        //only used on web for now:
        _theoPlayerViewController?.setPresentationMode(presentationMode, () {
          if (fullscreenPresentingFuture != null) {
            Navigator.of(_currentContext, rootNavigator: true).maybePop();
          }
        });
      case PresentationMode.INLINE:
        if (previousPresentationMode == PresentationMode.FULLSCREEN) {
          if (kIsWeb) {
            // web is smoother with maybePop()
            // TODO: check later
            Navigator.of(_currentContext, rootNavigator: true).maybePop();
          } else {
            Navigator.of(_currentContext, rootNavigator: true).pop();
          }
          //NOTE: fullscreenPresentingFuture still will be called, if any
        }
      default:
        print("Unsupported presentationMode $presentationMode");
    }
  }

  void restorePlayerStateAfterLeavingFullscreen() {
    if (kDebugMode) {
      print("THEOplayer: Exit fullscreen");
    }
    _playerState.presentationMode = PresentationMode.INLINE;
    SystemChrome.setPreferredOrientations(theoPlayerConfig.fullscreenConfig.preferredRestoredOrientations).then((value) => {
      SystemChrome.restoreSystemUIOverlays()
    });

    //only used on web for now:
    _theoPlayerViewController?.setPresentationMode(PresentationMode.INLINE, null);
  }

  /// Releases and destroys all resources
  void dispose() {
    _lifecycleListener?.dispose();
    _theoPlayerViewController?.dispose();
    _playerState.dispose();
    _textTrackListHolder.dispose();
    _audioTrackListHolder.dispose();
  }

  /// Add the given listener for the given [PlayerEventTypes] type(s).
  @override
  void addEventListener(String eventType, EventListener<Event> listener) {
    _playerState.eventManager.addEventListener(eventType, listener);
  }

  /// Remove the given listener for the given [PlayerEventTypes] type(s).
  @override
  void removeEventListener(String eventType, EventListener<Event> listener) {
    _playerState.eventManager.removeEventListener(eventType, listener);
  }
}
