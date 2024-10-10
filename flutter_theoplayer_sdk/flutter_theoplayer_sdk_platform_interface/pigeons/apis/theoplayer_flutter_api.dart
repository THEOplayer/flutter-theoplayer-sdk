import 'package:pigeon/pigeon.dart';

import '../models/ready_state.dart';
import '../models/source.dart';

//Talking from Native to Dart
@FlutterApi()
abstract class THEOplayerFlutterAPI {
  void onSourceChange(SourceDescription? source);

  void onPlay(double currentTime);

  void onPlaying(double currentTime);

  void onPause(double currentTime);

  void onWaiting(double currentTime);

  void onDurationChange(double duration);

  void onProgress(double currentTime);

  void onTimeUpdate(double currentTime, int? currentProgramDateTime);

  void onRateChange(double currentTime, double playbackRate);

  void onSeeking(double currentTime);

  void onSeeked(double currentTime);

  void onVolumeChange(double currentTime, double volume);

  void onResize(double currentTime, int width, int height);

  void onEnded(double currentTime);

  void onError(String error);

  void onDestroy();

  void onReadyStateChange(double currentTime, ReadyState readyState);

  void onLoadStart();

  void onLoadedMetadata(double currentTime);

  void onLoadedData(double currentTime);

  void onCanPlay(double currentTime);

  void onCanPlayThrough(double currentTime);
}
