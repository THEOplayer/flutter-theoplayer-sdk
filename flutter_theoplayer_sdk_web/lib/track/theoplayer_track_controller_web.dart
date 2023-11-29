import 'package:flutter_theoplayer_sdk_platform_interface/track/mediatrack/theoplayer_audiotrack.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/track/mediatrack/theoplayer_videotrack.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/track/texttrack/theoplayer_texttrack.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/track/theoplayer_track_controller_interface.dart';
import 'package:flutter_theoplayer_sdk_web/theoplayer_api_web.dart';
import 'package:flutter_theoplayer_sdk_web/track/texttrack/theoplayer_texttracklist_impl_web.dart';
import 'package:flutter_theoplayer_sdk_web/track/audiotrack/theoplayer_audiotracklist_impl_web.dart';
import 'package:flutter_theoplayer_sdk_web/track/videotrack/theoplayer_videotracklist_impl_web.dart';

class THEOplayerTrackControllerWeb extends THEOplayerTrackControllerInterface {
  static const String TAG = "THEOplayerTextTrackControllerWeb";

  final THEOplayerJS _theoplayerJS;
  late final TextTrackListImplWeb _textTracksImpl;
  late final AudioTrackListImplWeb _audioTracksImpl;
  late final VideoTrackListImplWeb _videoTracksImpl;

  THEOplayerTrackControllerWeb(this._theoplayerJS) {
    _textTracksImpl = TextTrackListImplWeb(_theoplayerJS.textTracks);
    _audioTracksImpl = AudioTrackListImplWeb(_theoplayerJS.audioTracks);
    _videoTracksImpl = VideoTrackListImplWeb(_theoplayerJS.videoTracks);

  }
  
  @override
  void dispose() {
    _textTracksImpl.dispose();
  }
  
  @override
  TextTracks getTextTracks() {
    return _textTracksImpl;
  }

  @override
  AudioTracks getAudioTracks() {
    return _audioTracksImpl;
  }

  @override
  VideoTracks getVideoTracks() {
    return _videoTracksImpl;
  }

}
