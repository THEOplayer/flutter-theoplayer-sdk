import 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_audiotrack.dart';
import 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_videotrack.dart';
import 'package:theoplayer_platform_interface/track/texttrack/theoplayer_texttrack.dart';

abstract class THEOplayerTrackControllerInterface {
  static const String TAG = "THEOplayerTrackControllerInterface";

  TextTracks getTextTracks();

  AudioTracks getAudioTracks();

  VideoTracks getVideoTracks();

  void dispose();
}
