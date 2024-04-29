import 'package:theoplayer_platform_interface/pigeon/apis.g.dart';
import 'package:theoplayer_platform_interface/theoplayer_event_dispatcher_interface.dart';
import 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_audiotrack.dart';
import 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_videotrack.dart';
import 'package:theoplayer_platform_interface/track/texttrack/theoplayer_texttrack.dart';

abstract class THEOplayerViewController implements EventDispatcher {
  static const String TAG = "THEOplayerViewController";

  THEOplayerViewController(int id) {}

  String get channelSuffix;

  void setSource({required SourceDescription? source});

  Future<SourceDescription?> getSource();

  void setAutoplay(bool autoplay);

  Future<bool> isAutoplay();

  void play();

  void pause();

  Future<bool> isPaused();

  void setCurrentTime(double currentTime);

  Future<double> getCurrentTime();

  void setCurrentProgramDateTime(DateTime currentProgramDateTime);

  Future<DateTime?> getCurrentProgramDateTime();

  Future<double> getDuration();

  void setPlaybackRate(double playbackRate);

  Future<double> getPlaybackRate();

  void setVolume(double volume);

  Future<double> getVolume();

  void setMuted(bool muted);

  Future<bool> isMuted();

  void setPreload(PreloadType preload);

  Future<PreloadType> getPreload();

  Future<ReadyState> getReadyState();

  Future<bool> isSeeking();

  Future<bool> isEnded();

  Future<int> getVideoWidth();

  Future<int> getVideoHeight();

  Future<List<TimeRange?>> getBuffered();

  Future<List<TimeRange?>> getSeekable();

  Future<List<TimeRange?>> getPlayed();

  void setAllowBackgroundPlayback(bool allowBackgroundPlayback);

  Future<bool> allowBackgroundPlayback();

  Future<String?> getError();

  TextTracks getTextTracks();

  AudioTracks getAudioTracks();

  VideoTracks getVideoTracks();

  void stop();

  void dispose();

  // application lifecycle listeners
  void onLifecycleResume();
  
  void onLifecyclePause();

  //PresentationMode getPresentationMode();

  void setPresentationMode(PresentationMode presentationMode, AutomaticFullscreenExitListener? automaticFullscreenExitListener);

}

typedef AutomaticFullscreenExitListener = void Function();

enum PresentationMode {
  INLINE, FULLSCREEN, PIP,
}
