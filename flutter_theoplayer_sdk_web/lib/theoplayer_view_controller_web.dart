import 'package:theoplayer_platform_interface/pigeon/apis.g.dart' as PlatformInterface;
import 'package:theoplayer_platform_interface/theopalyer_config.dart';
import 'package:theoplayer_platform_interface/theoplayer_event_dispatcher_interface.dart' as PlatformInterfaceEventDispatcher;
import 'package:theoplayer_platform_interface/theoplayer_events.dart' as PlatformInterfaceEvents;
import 'package:theoplayer_platform_interface/theoplayer_view_controller_interface.dart';
import 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_audiotrack.dart';
import 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_videotrack.dart';
import 'package:theoplayer_platform_interface/track/texttrack/theoplayer_texttrack.dart';
import 'package:theoplayer_web/player_event_forwarder_web.dart';
import 'package:theoplayer_web/theoplayer_api_web.dart';
import 'package:theoplayer_web/track/theoplayer_track_controller_web.dart';
import 'package:theoplayer_web/transformers_web.dart';
import 'package:web/web.dart';

class THEOplayerViewControllerWeb extends THEOplayerViewController {
  final HTMLElement _playerWrapperDiv;
  late final String _channelSuffix;
  late final THEOplayerJS _theoPlayerJS;
  late final PlayerEventForwarderWeb _eventForwarder;
  late final THEOplayerTrackControllerWeb _tracksController;

  THEOplayerViewControllerWeb(int id, this._playerWrapperDiv, THEOplayerConfig theoPlayerConfig) : super(id) {
    _channelSuffix = id.toString();
    _theoPlayerJS = THEOplayerJS(
        _playerWrapperDiv,
        THEOplayerConfigParams(
          license: theoPlayerConfig.getLicense(),
          licenseUrl: theoPlayerConfig.getLicenseUrl(),
        ));
    _eventForwarder = PlayerEventForwarderWeb(_theoPlayerJS);
    _tracksController = THEOplayerTrackControllerWeb(_theoPlayerJS);
  }

  String get channelSuffix => _channelSuffix;

  @override
  void addEventListener(String eventType, PlatformInterfaceEventDispatcher.EventListener<PlatformInterfaceEvents.Event> listener) {
    _eventForwarder.addEventListener(eventType, listener);
  }

  @override
  void removeEventListener(String eventType, PlatformInterfaceEventDispatcher.EventListener<PlatformInterfaceEvents.Event> listener) {
    _eventForwarder.removeEventListener(eventType, listener);
  }

  @override
  void dispose() {
    _eventForwarder.clear();
    _tracksController.dispose();
  }

  @override
  Future<DateTime?> getCurrentProgramDateTime() {
    int? currentProgramDateTime = _theoPlayerJS.currentProgramDateTime?.getTime();
    if (currentProgramDateTime == null) {
      return Future.value(null);
    }
    return Future.value(DateTime.fromMillisecondsSinceEpoch(currentProgramDateTime));
  }

  @override
  Future<double> getCurrentTime() {
    return Future.value(_theoPlayerJS.currentTime);
  }

  @override
  Future<double> getDuration() {
    return Future.value(_theoPlayerJS.duration);
  }

  @override
  Future<double> getPlaybackRate() {
    return Future.value(_theoPlayerJS.playbackRate);
  }

  @override
  Future<PlatformInterface.PreloadType> getPreload() {
    return Future.value(PlatformInterface.PreloadType.values.byName(_theoPlayerJS.preload));
  }

  @override
  Future<PlatformInterface.ReadyState> getReadyState() {
    PlatformInterface.ReadyState readyState = toFlutterReadyState(_theoPlayerJS.readyState);
    return Future.value(readyState);
  }

  @override
  Future<PlatformInterface.SourceDescription?> getSource() {
    PlatformInterface.SourceDescription? source = toFlutterSourceDescription(_theoPlayerJS.source);
    return Future.value(source);
  }

  @override
  Future<double> getVolume() {
    return Future.value(_theoPlayerJS.volume);
  }

  @override
  Future<bool> isAutoplay() {
    return Future.value(_theoPlayerJS.autoplay);
  }

  @override
  Future<bool> isEnded() {
    return Future.value(_theoPlayerJS.ended);
  }

  @override
  Future<bool> isMuted() {
    return Future.value(_theoPlayerJS.muted);
  }

  @override
  Future<bool> isPaused() {
    return Future.value(_theoPlayerJS.paused);
  }

  @override
  Future<bool> isSeeking() {
    return Future.value(_theoPlayerJS.seeking);
  }

  @override
  void pause() {
    _theoPlayerJS.pause();
  }

  @override
  void play() {
    _theoPlayerJS.play();
  }

  @override
  void setAutoplay(bool autoplay) {
    _theoPlayerJS.autoplay = autoplay;
  }

  @override
  void setCurrentProgramDateTime(DateTime currentProgramDateTime) {
    _theoPlayerJS.currentProgramDateTime = JSDate(currentProgramDateTime.millisecondsSinceEpoch);
  }

  @override
  void setCurrentTime(double currentTime) {
    _theoPlayerJS.currentTime = currentTime;
  }

  @override
  void setMuted(bool muted) {
    _theoPlayerJS.muted = muted;
  }

  @override
  void setPlaybackRate(double playbackRate) {
    _theoPlayerJS.playbackRate = playbackRate;
  }

  @override
  void setPreload(PlatformInterface.PreloadType preload) {
    _theoPlayerJS.preload = preload.name;
  }

  @override
  void setSource({required PlatformInterface.SourceDescription? source}) {
    if (source == null) {
      return;
    }

    _theoPlayerJS.source = toSourceDescription(source);
  }

  @override
  void setVolume(double volume) {
    _theoPlayerJS.volume = volume;
  }

  @override
  void stop() {
    _theoPlayerJS.stop();
  }

  @override
  Future<List<PlatformInterface.TimeRange?>> getBuffered() {
    List<PlatformInterface.TimeRange> ranges = [];
    for (var i = 0; i < _theoPlayerJS.buffered.length; i++) {
      ranges.add(PlatformInterface.TimeRange(start: _theoPlayerJS.buffered.start(i), end: _theoPlayerJS.buffered.end(i)));
    }
    return Future.value(ranges);
  }

  @override
  Future<String?> getError() {
    return Future.value(_theoPlayerJS.error?.message);
  }

  @override
  Future<List<PlatformInterface.TimeRange?>> getPlayed() {
    List<PlatformInterface.TimeRange> ranges = [];
    for (var i = 0; i < _theoPlayerJS.played.length; i++) {
      ranges.add(PlatformInterface.TimeRange(start: _theoPlayerJS.played.start(i), end: _theoPlayerJS.played.end(i)));
    }
    return Future.value(ranges);
  }

  @override
  Future<List<PlatformInterface.TimeRange?>> getSeekable() {
    List<PlatformInterface.TimeRange> ranges = [];
    for (var i = 0; i < _theoPlayerJS.seekable.length; i++) {
      ranges.add(PlatformInterface.TimeRange(start: _theoPlayerJS.seekable.start(i), end: _theoPlayerJS.seekable.end(i)));
    }
    return Future.value(ranges);
  }

  @override
  Future<int> getVideoHeight() {
    return Future.value(_theoPlayerJS.videoHeight);
  }

  @override
  Future<int> getVideoWidth() {
    return Future.value(_theoPlayerJS.videoWidth);
  }

  @override
  Future<bool> allowBackgroundPlayback() {
    return Future.value(true);
  }

  @override
  void setAllowBackgroundPlayback(bool allowBackgroundPlayback) {
    // do nothing
  }

  @override
  TextTracks getTextTracks() {
    return _tracksController.getTextTracks();
  }

  @override
  AudioTracks getAudioTracks() {
    return _tracksController.getAudioTracks();
  }

  @override
  VideoTracks getVideoTracks() {
    return _tracksController.getVideoTracks();
  }
  
  @override
  void onLifecyclePause() {
    // do nothing
  }
  
  @override
  void onLifecycleResume() {
    // do nothing
  }

  @override
  void setPresentationMode(PresentationMode presenationMode) {
    // TODO: implement setPresentationMode
  }
}
