import 'package:flutter_theoplayer_sdk_platform_interface/pigeon/apis.g.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/pigeon_binary_messenger_wrapper.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/theoplayer_event_dispatcher_interface.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/theoplayer_events.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/theoplayer_flutter_api.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/theoplayer_view_controller_interface.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/track/mediatrack/theoplayer_audiotrack.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/track/mediatrack/theoplayer_videotrack.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/track/texttrack/theoplayer_texttrack.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/track/theoplayer_track_controller_mobile.dart';

class THEOplayerViewControllerMobile extends THEOplayerViewController {
  static const String TAG = "THEOplayerViewControllerMobile";

  late final String _channelSuffix;
  late final PigeonBinaryMessengerWrapper _pigeonMessenger;
  late final THEOplayerNativeAPI _nativeAPI;
  late final THEOplayerFlutterAPIImpl _flutterAPI;
  late final THEOplayerTrackControllerMobile _trackController;

  THEOplayerViewControllerMobile(int id) : super(id) {
    _channelSuffix = 'id_$id';
    _pigeonMessenger = PigeonBinaryMessengerWrapper(suffix: _channelSuffix);
    _nativeAPI = THEOplayerNativeAPI(binaryMessenger: _pigeonMessenger);
    _flutterAPI = THEOplayerFlutterAPIImpl(binaryMessenger: _pigeonMessenger);
    _trackController = THEOplayerTrackControllerMobile(_channelSuffix);
  }

  String get channelSuffix => _channelSuffix;

  void addEventListener(String eventType, EventListener<Event> listener) {
    _flutterAPI.addEventListener(eventType, listener);
  }

  void removeEventListener(String eventType, EventListener<Event> listener) {
    _flutterAPI.removeEventListener(eventType, listener);
  }

  //invoke methods in native
  void setSource({required SourceDescription? source}) async {
    print("${THEOplayerViewControllerMobile.TAG} setSource: ${source?.sources.first?.src}");
    _nativeAPI.setSource(source);
  }

  Future<SourceDescription?> getSource() {
    return _nativeAPI.getSource();
  }

  void setAutoplay(bool autoplay) async {
    _nativeAPI.setAutoplay(autoplay);
  }

  Future<bool> isAutoplay() {
    return _nativeAPI.isAutoplay();
  }

  void play() async {
    _nativeAPI.play();
  }

  void pause() async {
    _nativeAPI.pause();
  }

  Future<bool> isPaused() {
    return _nativeAPI.isPaused();
  }

  void setCurrentTime(double currentTime) async {
    _nativeAPI.setCurrentTime(currentTime);
  }

  Future<double> getCurrentTime() {
    return _nativeAPI.getCurrentTime();
  }

  void setCurrentProgramDateTime(DateTime currentProgramDateTime) async {
    _nativeAPI.setCurrentProgramDateTime(currentProgramDateTime.millisecondsSinceEpoch);
  }

  Future<DateTime?> getCurrentProgramDateTime() async {
    var currentProgramDateTime = await _nativeAPI.getCurrentProgramDateTime();
    if (currentProgramDateTime == null) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(currentProgramDateTime);
  }

  Future<double> getDuration() {
    return _nativeAPI.getDuration();
  }

  void setPlaybackRate(double playbackRate) async {
    _nativeAPI.setPlaybackRate(playbackRate);
  }

  Future<double> getPlaybackRate() {
    return _nativeAPI.getPlaybackRate();
  }

  void setVolume(double volume) async {
    _nativeAPI.setVolume(volume);
  }

  Future<double> getVolume() {
    return _nativeAPI.getVolume();
  }

  void setMuted(bool muted) async {
    _nativeAPI.setMuted(muted);
  }

  Future<bool> isMuted() {
    return _nativeAPI.isMuted();
  }

  void setPreload(PreloadType preload) async {
    _nativeAPI.setPreload(preload);
  }

  Future<PreloadType> getPreload() {
    return _nativeAPI.getPreload();
  }

  Future<ReadyState> getReadyState() {
    return _nativeAPI.getReadyState();
  }

  Future<bool> isSeeking() {
    return _nativeAPI.isSeeking();
  }

  Future<bool> isEnded() {
    return _nativeAPI.isEnded();
  }

  Future<int> getVideoWidth() {
    return _nativeAPI.getVideoWidth();
  }

  Future<int> getVideoHeight() {
    return _nativeAPI.getVideoHeight();
  }

  Future<List<TimeRange?>> getBuffered() {
    return _nativeAPI.getBuffered();
  }

  Future<List<TimeRange?>> getSeekable() {
    return _nativeAPI.getSeekable();
  }

  Future<List<TimeRange?>> getPlayed() {
    return _nativeAPI.getPlayed();
  }

  Future<String?> getError() {
    return _nativeAPI.getError();
  }

  void stop() async {
    _nativeAPI.stop();
  }

  void dispose() {
    _nativeAPI.dispose();
    _flutterAPI.dispose();
  }

  @override
  TextTracks getTextTracks() {
    return _trackController.getTextTracks();
  }

  @override
  AudioTracks getAudioTracks() {
    return _trackController.getAudioTracks();
  }

  @override
  VideoTracks getVideoTracks() {
    return _trackController.getVideoTracks();
  }
}
