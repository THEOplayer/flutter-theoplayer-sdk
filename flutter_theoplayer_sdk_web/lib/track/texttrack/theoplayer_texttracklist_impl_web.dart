import 'package:flutter_theoplayer_sdk_platform_interface/track/texttrack/theoplayer_texttrack.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/track/texttrack/theoplayer_texttrack_impl.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/track/texttrack/theoplayer_texttrack_events.dart';
import 'package:flutter_theoplayer_sdk_web/theoplayer_api_web.dart';
import 'package:flutter_theoplayer_sdk_web/track/texttrack/theoplayer_texttrack_impl_web.dart';
import 'package:flutter_theoplayer_sdk_web/transformers_web.dart';
import 'package:js/js.dart';

class TextTrackListImplWeb extends TextTracksImpl {

  final THEOplayerArrayList<THEOplayerTextTrack> _theoPlayerTextTracks;

  late final addTrackEventListener;
  late final removeTrackEventListener;
  late final changeTrackEventListener;


  TextTrackListImplWeb(this._theoPlayerTextTracks) {

    addTrackEventListener = allowInterop((event){
      var track = event.track as THEOplayerTextTrack;
      var flutterTrack = TextTrackImplWeb(
        track.id, 
        track.uid, 
        track.label, 
        track.language, 
        track.kind, 
        track.inBandMetadataTrackDispatchType, 
        toFlutterTextTrackReadyState(track.readyState), 
        toFlutterTextTrackType(track.type), 
        new Cues(),
        new Cues(),
        track.src, 
        track.forced, 
        toFlutterTextTrackMode(track.mode),
        track
      );
      add(flutterTrack);
      dispatchEvent(AddTextTrackEvent(track: flutterTrack));
    });

    removeTrackEventListener = allowInterop((event){
      var track = event.track as THEOplayerTextTrack;
      
      var flutterTrack = firstWhereOrNull((item) => item.uid == track.uid);
      if (flutterTrack == null) {
        return;
      }

      remove(flutterTrack);
      dispatchEvent(RemoveTextTrackEvent(track: flutterTrack));
    });

    //only triggered for enable/disable
    changeTrackEventListener = allowInterop((event){
      var track = event.track as THEOplayerTextTrack;

      var flutterTrack = firstWhereOrNull((item) => item.uid == track.uid);
      if (flutterTrack == null) {
        return;
      }

      dispatchEvent(TextTrackListChangeEvent(track: flutterTrack));
    });

    _theoPlayerTextTracks.addEventListener(TextTracksEventTypes.ADDTRACK.toLowerCase(), addTrackEventListener);
    _theoPlayerTextTracks.addEventListener(TextTracksEventTypes.REMOVETRACK.toLowerCase(), removeTrackEventListener);
    _theoPlayerTextTracks.addEventListener(TextTracksEventTypes.CHANGE.toLowerCase(), changeTrackEventListener);

  }

  void dispose() {
    super.dispose();
    _theoPlayerTextTracks.removeEventListener(TextTracksEventTypes.ADDTRACK.toLowerCase(), addTrackEventListener);
    _theoPlayerTextTracks.removeEventListener(TextTracksEventTypes.REMOVETRACK.toLowerCase(), removeTrackEventListener);
    _theoPlayerTextTracks.removeEventListener(TextTracksEventTypes.CHANGE.toLowerCase(), changeTrackEventListener);

    forEach((element) {
      dispatchEvent(RemoveTextTrackEvent(track: element));
      (element as TextTrackImplWeb).dispose();
    });

    clear();
  }

  
}