import 'package:pigeon/pigeon.dart';

import '../models/preload_type.dart';
import '../models/ready_state.dart';
import '../models/source.dart';
import '../models/timerange.dart';

//Talking to the native
@HostApi()
abstract class THEOplayerNativeAPI {
  void setSource(SourceDescription? source);

  SourceDescription? getSource();

  void setAutoplay(bool autoplay);

  bool isAutoplay();

  void play();

  void pause();

  bool isPaused();

  void setCurrentTime(double currentTime);

  double getCurrentTime();

  void setCurrentProgramDateTime(int currentProgramDateTime);

  int? getCurrentProgramDateTime();

  double getDuration();

  void setPlaybackRate(double playbackRate);

  double getPlaybackRate();

  void setVolume(double volume);

  double getVolume();

  void setMuted(bool muted);

  bool isMuted();

  void setPreload(PreloadType preload);

  PreloadType getPreload();

  ReadyState getReadyState();

  bool isSeeking();

  bool isEnded();

  int getVideoWidth();

  int getVideoHeight();

  List<TimeRange> getBuffered();

  List<TimeRange> getSeekable();

  List<TimeRange> getPlayed();

  void setAllowBackgroundPlayback(bool allowBackgroundPlayback);

  bool allowBackgroundPlayback();

  String? getError();

  void stop();

  void dispose();

  // application lifecycle listeners
  void onLifecycleResume();
  
  void onLifecyclePause();

  void configureSurface(int surfaceId, int width, int height);

}
