import 'package:theoplayer_platform_interface/pigeon_binary_messenger_wrapper.dart';
import 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_audiotrack.dart';
import 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_flutter_audiotracks_api.dart';
import 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_flutter_videotracks_api.dart';
import 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_videotrack.dart';
import 'package:theoplayer_platform_interface/track/texttrack/theoplayer_flutter_texttracks_api.dart';
import 'package:theoplayer_platform_interface/track/texttrack/theoplayer_texttrack.dart';
import 'package:theoplayer_platform_interface/track/theoplayer_track_controller_interface.dart';

class THEOplayerTrackControllerMobile extends THEOplayerTrackControllerInterface {
  static const String TAG = "THEOplayerTextTrackControllerMobile";

  late final PigeonBinaryMessengerWrapper _pigeonMessenger;
  late final THEOplayerFlutterTextTracksAPIImpl _textTrackAPI;
  late final THEOplayerFlutterAudioTracksAPIImpl _audioTrackAPI;
  late final THEOplayerFlutterVideoTracksAPIImpl _videoTrackAPI;

  THEOplayerTrackControllerMobile(String channelSuffix) {
    _pigeonMessenger = PigeonBinaryMessengerWrapper(suffix: channelSuffix);
    _textTrackAPI = THEOplayerFlutterTextTracksAPIImpl(binaryMessenger: _pigeonMessenger);
    _audioTrackAPI = THEOplayerFlutterAudioTracksAPIImpl(binaryMessenger: _pigeonMessenger);
    _videoTrackAPI = THEOplayerFlutterVideoTracksAPIImpl(binaryMessenger: _pigeonMessenger);
  }

  @override
  TextTracks getTextTracks() {
    return _textTrackAPI.getTextTracks();
  }

  @override
  AudioTracks getAudioTracks() {
    return _audioTrackAPI.getAudioTracks();
  }

  @override
  VideoTracks getVideoTracks() {
    return _videoTrackAPI.getVideoTracks();
  }

  void dispose() {
    _textTrackAPI.dispose();
    _audioTrackAPI.dispose();
  }
}
