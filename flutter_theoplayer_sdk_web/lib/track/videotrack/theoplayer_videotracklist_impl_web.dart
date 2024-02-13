import 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_videotrack.dart';
import 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_videotrack_events.dart';
import 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_videotrack_impl.dart';
import 'package:theoplayer_web/theoplayer_api_event_web.dart';
import 'package:theoplayer_web/theoplayer_api_web.dart';
import 'package:theoplayer_web/track/texttrack/theoplayer_texttrack_impl_web.dart';
import 'package:theoplayer_web/track/videotrack/theoplayer_videotrack_impl_web.dart';
import 'package:theoplayer_web/transformers_web.dart';
import 'package:js/js.dart';

class VideoTrackListImplWeb extends VideoTracksImpl {

  final THEOplayerArrayList<THEOplayerVideoTrack> _theoPlayerVideoTracks;

  late final addTrackEventListener;
  late final removeTrackEventListener;
  late final changeTrackEventListener;


  VideoTrackListImplWeb(this._theoPlayerVideoTracks) {

    addTrackEventListener = allowInterop((AddVideoTrackEventJS event){
      var track = event.track;

      VideoQualities qualities = toFlutterVideoQualities(track.qualities);

      var flutterTrack = VideoTrackImplWeb(
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
      dispatchEvent(AddVideoTrackEvent(track: flutterTrack));
    });

    removeTrackEventListener = allowInterop((RemoveVideoTrackEventJS event){
      var track = event.track;
      
      var flutterTrack = firstWhereOrNull((item) => item.uid == track.uid);
      if (flutterTrack == null) {
        return;
      }

      remove(flutterTrack);
      dispatchEvent(RemoveVideoTrackEvent(track: flutterTrack));
    });

    //only triggered for enable/disable
    changeTrackEventListener = allowInterop((VideoTrackListChangeEventJS event){
      var track = event.track;

      var flutterTrack = firstWhereOrNull((item) => item.uid == track.uid);
      if (flutterTrack == null) {
        return;
      }

      dispatchEvent(VideoTrackListChangeEvent(track: flutterTrack));
    });

    _theoPlayerVideoTracks.addEventListener(VideoTracksEventTypes.ADDTRACK.toLowerCase(), addTrackEventListener);
    _theoPlayerVideoTracks.addEventListener(VideoTracksEventTypes.REMOVETRACK.toLowerCase(), removeTrackEventListener);
    _theoPlayerVideoTracks.addEventListener(VideoTracksEventTypes.CHANGE.toLowerCase(), changeTrackEventListener);

  }

  void dispose() {
    super.dispose();
    _theoPlayerVideoTracks.removeEventListener(VideoTracksEventTypes.ADDTRACK.toLowerCase(), addTrackEventListener);
    _theoPlayerVideoTracks.removeEventListener(VideoTracksEventTypes.REMOVETRACK.toLowerCase(), removeTrackEventListener);
    _theoPlayerVideoTracks.removeEventListener(VideoTracksEventTypes.CHANGE.toLowerCase(), changeTrackEventListener);

    forEach((element) {
      dispatchEvent(RemoveVideoTrackEvent(track: element));
      (element as TextTrackImplWeb).dispose();
    });

    clear();
  }

  
}
