import 'package:flutter_theoplayer_sdk_platform_interface/track/mediatrack/theoplayer_audiotrack.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/track/mediatrack/theoplayer_audiotrack_impl.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/track/mediatrack/theoplayer_audiotrack_events.dart';
import 'package:flutter_theoplayer_sdk_web/theoplayer_api_event_web.dart';
import 'package:flutter_theoplayer_sdk_web/theoplayer_api_web.dart';
import 'package:flutter_theoplayer_sdk_web/track/audiotrack/theoplayer_audiotrack_impl_web.dart';
import 'package:flutter_theoplayer_sdk_web/track/texttrack/theoplayer_texttrack_impl_web.dart';
import 'package:flutter_theoplayer_sdk_web/transformers_web.dart';
import 'package:js/js.dart';

class AudioTrackListImplWeb extends AudioTracksImpl {

  final THEOplayerArrayList<THEOplayerAudioTrack> _theoPlayerAudioTracks;

  late final addTrackEventListener;
  late final removeTrackEventListener;
  late final changeTrackEventListener;


  AudioTrackListImplWeb(this._theoPlayerAudioTracks) {

    addTrackEventListener = allowInterop((AddAudioTrackEventJS event){
      var track = event.track;

      AudioQualities qualities = toFlutterAudioQualities(track.qualities);

      var flutterTrack = AudioTrackImplWeb(
        track.id, 
        track.uid, 
        track.label, 
        track.language, 
        track.kind,
        qualities,
        track.enabled,
        track
      );
      add(flutterTrack);
      dispatchEvent(AddAudioTrackEvent(track: flutterTrack));
    });

    removeTrackEventListener = allowInterop((RemoveAudioTrackEventJS event){
      var track = event.track;
      
      var flutterTrack = firstWhereOrNull((item) => item.uid == track.uid);
      if (flutterTrack == null) {
        return;
      }

      remove(flutterTrack);
      dispatchEvent(RemoveAudioTrackEvent(track: flutterTrack));
    });

    //only triggered for enable/disable
    changeTrackEventListener = allowInterop((AudioTrackListChangeEventJS event){
      var track = event.track;

      var flutterTrack = firstWhereOrNull((item) => item.uid == track.uid);
      if (flutterTrack == null) {
        return;
      }

      dispatchEvent(AudioTrackListChangeEvent(track: flutterTrack));
    });

    _theoPlayerAudioTracks.addEventListener(AudioTracksEventTypes.ADDTRACK.toLowerCase(), addTrackEventListener);
    _theoPlayerAudioTracks.addEventListener(AudioTracksEventTypes.REMOVETRACK.toLowerCase(), removeTrackEventListener);
    _theoPlayerAudioTracks.addEventListener(AudioTracksEventTypes.CHANGE.toLowerCase(), changeTrackEventListener);

  }

  void dispose() {
    super.dispose();
    _theoPlayerAudioTracks.removeEventListener(AudioTracksEventTypes.ADDTRACK.toLowerCase(), addTrackEventListener);
    _theoPlayerAudioTracks.removeEventListener(AudioTracksEventTypes.REMOVETRACK.toLowerCase(), removeTrackEventListener);
    _theoPlayerAudioTracks.removeEventListener(AudioTracksEventTypes.CHANGE.toLowerCase(), changeTrackEventListener);

    forEach((element) {
      dispatchEvent(RemoveAudioTrackEvent(track: element));
      (element as TextTrackImplWeb).dispose();
    });

    clear();
  }

  
}
