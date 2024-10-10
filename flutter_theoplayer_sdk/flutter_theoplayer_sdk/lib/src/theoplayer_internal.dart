import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:theoplayer/src/widget/fullscreen_widget.dart';
import 'package:theoplayer/src/widget/presentationmode_aware_widget.dart';
import 'package:theoplayer_platform_interface/helpers/logger.dart';
import 'package:theoplayer_platform_interface/pigeon/apis.g.dart';
import 'package:theoplayer_platform_interface/platform/platform_activity_service.dart';
import 'package:theoplayer_platform_interface/theopalyer_config.dart';
import 'package:theoplayer_platform_interface/theoplayer_event_dispatcher_interface.dart';
import 'package:theoplayer_platform_interface/theoplayer_events.dart';
import 'package:theoplayer_platform_interface/theoplayer_view_controller_interface.dart';
import 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_audiotrack.dart';
import 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_videotrack.dart';
import 'package:theoplayer_platform_interface/track/texttrack/theoplayer_texttrack.dart';
import 'package:theoplayer/src/theoplayer_state.dart';
import 'package:theoplayer/src/theoplayer_tracklist_wrapper.dart';
import 'package:theoplayer/src/theoplayer_view.dart';

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
  PlatformActivityServiceListener? _platformActivityServiceListener;
  late BuildContext _currentContext;

  final globalKey = GlobalKey();

  final TextTracksHolder _textTrackListHolder = TextTracksHolder();
  final AudioTracksHolder _audioTrackListHolder = AudioTracksHolder();
  final VideoTracksHolder _videoTrackListHolder = VideoTracksHolder();

  // internal helpers
  PresentationMode _presentationModeBeforePip = PresentationMode.INLINE;
  bool _manualInterventionForPipRestoration = false;
  bool _manualInterventionForFullscreenRestoration = false;

  /// Initialize THEOplayer with a [THEOplayerConfig].
  /// [onCreate] is called once the underlying native THEOplayerView is fully created and available to use.

  THEOplayer({required this.theoPlayerConfig, this.onCreate, FullscreenWidgetBuilder? fullscreenBuilder}) {
    debugLog("THEOplayer: constructor");

    _playerState = PlayerState();
    _tpv = THEOplayerView(
        key: globalKey,
        theoPlayerConfig: theoPlayerConfig,
        onCreated: (THEOplayerViewController viewController, BuildContext context) {
          _currentContext = context;
          _theoPlayerViewController = viewController;
          debugLog("THEOplayer_$id: onCreated");
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

  int get id => _theoPlayerViewController?.id ?? -1;

  void _setupLifeCycleListeners() {
    print("THEOplayer_$id: _setupLifeCycleListeners");
    _lifecycleListener = AppLifecycleListener(onResume: () {
      _theoPlayerViewController?.onLifecycleResume();
    }, onPause: () {
      _theoPlayerViewController?.onLifecyclePause();
    }, onStateChange: (state) {
      debugLog("THEOplayer_$id: Detected lifecycle change: $state");
    });

    _platformActivityServiceListener = _PlayerPlatformActivityServiceListener(player: this);
    PlatformActivityService.instance.addPlatformActivityServiceListener(_platformActivityServiceListener!);
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
  /// Useful if audio-only playback is required in the background.
  ///
  /// Remarks:
  /// * on Web this flag has no impact.
  /// * on Android and iOS manual implementation is still required to connect the player to the Notification Center APIs to be able to control the playback from outside the app.
  void setAllowBackgroundPlayback(bool allowBackgroundPlayback) {
    _playerState.allowBackgroundPlayback = allowBackgroundPlayback;
    _theoPlayerViewController?.setAllowBackgroundPlayback(allowBackgroundPlayback);
  }

  /// Whether playback continues when the app goes to background.
  bool allowBackgroundPlayback() {
    return _playerState.allowBackgroundPlayback;
  }

  /// Set whether playback continues Picture-in-Picture mode when the app goes to background.
  ///
  /// Remarks:
  /// * on Web this flag has no impact.
  /// * on Android and iOS if this flag is TRUE, the player will go to Picture-in-Picture mode when the user presses the home button. (puts the application into background)
  /// * on Android and iOS there can be only one player with this flag set to TRUE. (having multiple ones can cause unexpected behaviour)
  /// * on iOS the player has to be not paused when entering Picture-in-Picture
  void setAllowAutomaticPictureInPicture(bool allowAutomaticPictureInPicture) {
    _playerState.allowAutomaticPictureInPicture = allowAutomaticPictureInPicture;
    _theoPlayerViewController?.setAllowAutomaticPictureInPicture(allowAutomaticPictureInPicture);
  }

  /// Whether playback continues in Picture-in-Picture when the app goes to background.
  bool allowAutomaticPictureInPicture() {
    //NOTE: we don't rely on the underlying native state
    return _playerState.allowAutomaticPictureInPicture;
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

  /// Returns the current [PresentationMode]
  PresentationMode getPresentationMode() {
    return _playerState.presentationMode;
  }

  /// Sets the current [PresentationMode] for the player
  ///
  /// Remarks:
  /// * [PresentationMode.INLINE]: The player is shown in its original location on the page/in the app
  /// * [PresentationMode.FULLSCREEN]: The player fills the entire screen (by presenting a new fullscreen view in the view hierarchy).
  ///   Check [THEOplayerConfig.fullscreenConfig] and [THEOplayer.fullscreenConfig] for more customization.
  /// * [PresentationMode.PIP]: The player is shown in Picture-in-Picture mode. ONLY AVAILABLE ON WEB! For Android and iOS check [setAllowAutomaticPictureInPicture].
  void setPresentationMode(PresentationMode presentationMode) {
    if (!kIsWeb && presentationMode == PresentationMode.PIP) {
      print("Programmatically setting Picture-in-Picture mode it not possible on ${defaultTargetPlatform.name}! Please check the `setAllowAutomaticPictureInPicture()` API.");
      return;
    }
    
    _setPresentationMode(presentationMode);
  }

  /// Picture-in-Picture flow
  ///
  /// - ENTERing PIP mode
  ///
  ///                   ┌────────────────────────┐             ┌──────────────────────────────────────┐                   ┌────────────────────────────┐
  ///                   │                        │             │                                      │                   │                            │
  ///  WEB              │setPresentationMode(PiP)├────────────►│videoElement.requestPictureInPicture()├──────────────────►│   Browser entered PiP mode │
  ///                   │                        │             │                                      │                   │                            │
  ///                   └────────────────────────┘             └──────────────────────────────────────┘                   └────────────────────────────┘
  ///
  /// - EXITing PIP mode by closing the PIP window
  ///   - WebEventTypes.PICTUREINPICTURE_EXIT is triggered from the video element ───► resolves setPresentationMode(PIP) callback
  ///
  ///
  ///
  ///
  ///
  /// - ENTERing PIP mode
  ///                                    ┌─────────────────┐                                 ┌─────────────────────────────┐
  ///                                    │ onUserLeaveHint │                                 │new _FakePiPFullscreenWindow │
  /// ANDROID           ┌───────────────►│   from native   ┼──────────────────┐    ┌────────►│  with stretched fullscreen  ├─────────────────┐
  ///                   │                └─────────────────┘                  │    │         │           player            │                 │
  ///                   │                                                     │    │         └─────────────────────────────┘                 │
  ///                   │                                                     ▼    │                                                         ▼
  ///         ┌─────────┼──────────┐                                  ┌────────────┴──┐                                            ┌───────────────────┐
  ///         │ Application moving │                                  │onUserLeaveHint│                                            │Application entered│
  ///         │   to background    │                                  │  in Flutter   │                                            │     PiP mode      │
  ///         └─────────┬──────────┘                                  └────────────┬──┘                                            └───────────────────┘
  ///                   │                                                     ▲    │                                                         ▲
  ///                   │                                                     │    │                                                         │
  ///                   │          ┌─────────────────────────────┐            │    │            ┌─────────────────────────┐                  │
  ///                   │          │ xxxWillStartPictureInPicture│            │    │            │ AVplayer transitions to │                  │
  ///  iOS              └─────────►│        from native          ├────────────┘    └───────────►│    Picture-in-Picture   ├──────────────────┘
  ///                              └─────────────────────────────┘                              └─────────────────────────┘
  ///
  /// - EXITing PIP mode by closing the PIP window
  ///   - ANDROID:
  ///     - `onConfigurationChanged` detected by the PipHandler on the Activity
  ///     - `onExitPictureInPicture` called in Flutter
  ///     - `_FakePiPFullscreenWindow` is popped
  ///     - player is back in the previous presentation mode
  ///
  ///   - iOS:
  ///     - `pictureInPictureControllerWillStopPictureInPicture` is called in the native player
  ///     - AVplayer transitions back to inline
  ///     - `onExitPictureInPicture` called in Flutter
  ///     - player is back in the previous presentation mode
  ///

  void _setPresentationMode(PresentationMode presentationMode, {bool userTriggered = true}) {
    if (_playerState.presentationMode == presentationMode) {
      return;
    }

    PresentationMode previousPresentationMode = _playerState.presentationMode;
    _playerState.presentationMode = presentationMode;

    switch (presentationMode) {
      case PresentationMode.FULLSCREEN:
        _manualInterventionForFullscreenRestoration = false;

        if (previousPresentationMode == PresentationMode.INLINE) {
          _enterFullscreen();
        } else if (previousPresentationMode == PresentationMode.PIP) {
          debugLog("THEOplayer_$id: Back to fullscreen from PiP");
          if (kIsWeb) {
            // we need this to avoid the callback on the previous setPresentationMode()  override the presentation mode we need for fullscreen.
            // TODO: try to kill it
            _manualInterventionForPipRestoration = true;
            // on web first we need to exit fullscreen and go back to inline
            _theoPlayerViewController?.setPresentationMode(PresentationMode.INLINE, null);
            _enterFullscreen();
          } else {
            if (Platform.isIOS) {
              //do nothing, AVplayer will do the transition
            } else {
              Navigator.of(_currentContext, rootNavigator: true).pop();
            }
          }
        }
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
        } else if (previousPresentationMode == PresentationMode.PIP) {
          debugLog("THEOplayer_$id: Back to inline from PiP");
          if (kIsWeb) {
            //TODO: try to move the logic of "if kIsWeb" inside the underlying viewController, so we don't need any platform check.
            _theoPlayerViewController?.setPresentationMode(PresentationMode.INLINE, null);
          } else {
            if (Platform.isIOS) {
              //do nothing, AVplayer will do the transition
            } else {
              Navigator.of(_currentContext, rootNavigator: true).pop();
            }
          }
        }


      case PresentationMode.PIP:

          _manualInterventionForPipRestoration = false;
          _presentationModeBeforePip = previousPresentationMode;

          if (kIsWeb) {
            if (previousPresentationMode == PresentationMode.FULLSCREEN) {
              // we need this to avoid the callback on the previous setPresentationMode()  override the presentation mode we need for pip.
              // TODO: try to kill it
              _manualInterventionForFullscreenRestoration = true;
              // first exit fullscreen before going into PiP
              // we are faking a transition without real presentationMode change
              // TODO: make this cleaner
              _presentationModeBeforePip = PresentationMode.INLINE;
              _theoPlayerViewController?.setPresentationMode(PresentationMode.INLINE, null);
              Navigator.of(_currentContext, rootNavigator: true).pop();

            }

            _theoPlayerViewController?.setPresentationMode(PresentationMode.PIP, (){
              debugLog("THEOplayer_$id: reset presentationMode after PIP: $_presentationModeBeforePip}");
              if (!_manualInterventionForPipRestoration) {
                _playerState.presentationMode = _presentationModeBeforePip;
              }
            });
          } else {
            // manually transition to PIP
            // right now it is disabled, we don't support this due to inconsistency between iOS and Android

            /*
            if (userTriggered) {
              PlatformActivityService.instance.triggerEnterPictureInPicture();
            }
            */
          }

      default:
        print("THEOplayer_$id: Unsupported presentationMode $presentationMode");
    }
  }

  void _enterFullscreen() {
    Future? fullscreenPresentingFuture;

    fullscreenPresentingFuture = Navigator.of(_currentContext, rootNavigator: true).push(MaterialPageRoute(
        builder: (context) {
          return _fullscreenBuilder(context, this);
        },
        settings: null));
    
    fullscreenPresentingFuture.then((value) => _restorePlayerStateAfterLeavingFullscreen());
    
    //only used on web for now:
    _theoPlayerViewController?.setPresentationMode(PresentationMode.FULLSCREEN, () {
      if (fullscreenPresentingFuture != null) {
        Navigator.of(_currentContext, rootNavigator: true).maybePop();
      }
    });
  }

  void _restorePlayerStateAfterLeavingFullscreen() {
    debugLog("THEOplayer_$id: Exit fullscreen");

    if (!_manualInterventionForFullscreenRestoration) {
      _playerState.presentationMode = PresentationMode.INLINE;
    }

    SystemChrome.setPreferredOrientations(theoPlayerConfig.fullscreenConfig.preferredRestoredOrientations).then((value) => {
      SystemChrome.restoreSystemUIOverlays()
    });

    //only used on web for now:
    if (!_manualInterventionForFullscreenRestoration) {
      _theoPlayerViewController?.setPresentationMode(PresentationMode.INLINE, null);
    }
  }

  /// Releases and destroys all resources
  void dispose() {
    if (_platformActivityServiceListener != null) {
      PlatformActivityService.instance.removePlatformActivityServiceListener(_platformActivityServiceListener!);
    }

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

/// Platform listener that receives PiP-related events from native.
/// Only used on Android and iOS
class _PlayerPlatformActivityServiceListener implements PlatformActivityServiceListener {

  THEOplayer player;

  _PlayerPlatformActivityServiceListener({required this.player});

  @override
  void onExitPictureInPicture() {
    debugLog("THEOplayer_$playerID: PlayerPlatformActivityServiceListener onExitPictureInPicture");

    if (!player.allowAutomaticPictureInPicture()) {
      debugLog("THEOplayer_$playerID: PlayerPlatformActivityServiceListener onExitPictureInPicture not for me");
      return;
    }

    player._setPresentationMode(player._presentationModeBeforePip);

  }


  @override
  void onUserLeaveHint() {
    debugLog("THEOplayer_$playerID:: PlayerPlatformActivityServiceListener onUserLeaveHint");


    if (!player.allowAutomaticPictureInPicture()) {
      debugLog("THEOplayer_$playerID: PlayerPlatformActivityServiceListener onUserLeaveHint not for me");
      return;
    }

    player._setPresentationMode(PresentationMode.PIP, userTriggered: false);

    if (Platform.isIOS) {
      //do nothing, AVplayer will do the transition
    } else {
      var pipModeFullscreenWidget = _FakePiPFullscreenWindow(player: player);

      MaterialPageRoute pipRoute = MaterialPageRoute(
          builder: (context) {
            return pipModeFullscreenWidget;
          },
          settings: null);

      Navigator.of(player._currentContext, rootNavigator: true).push(pipRoute);
    }
  }

  @override
  void onPlayActionReceived() {
    debugLog("THEOplayer_$playerID:: PlayerPlatformActivityServiceListener onPlayActionReceived");


    if (!player.allowAutomaticPictureInPicture()) {
      debugLog("THEOplayer_$playerID: PlayerPlatformActivityServiceListener onPlayActionReceived not for me");
      return;
    }

    player.play();

  }

  @override
  void onPauseActionReceived() {
    debugLog("THEOplayer_$playerID:: PlayerPlatformActivityServiceListener onPauseActionReceived");


    if (!player.allowAutomaticPictureInPicture()) {
      debugLog("THEOplayer_$playerID: PlayerPlatformActivityServiceListener onPauseActionReceived not for me");
      return;
    }

    player.pause();

  }

  @override
  int get playerID => player.id;

}
/// We use this widget to present the player in "fullscreen" to make it fully visible in PiP without any UI elements
class _FakePiPFullscreenWindow extends StatelessWidget {
  const _FakePiPFullscreenWindow({
    super.key,
    required this.player,
  });

  final THEOplayer player;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child: Align(
            alignment: Alignment.center,
            child: AspectRatio(
                aspectRatio: player.getVideoWidth() / player.getVideoHeight(),
                child: PresentationModeAwareWidget(player: player, presentationModeToCheck: const [PresentationMode.PIP]))));
  }
}
