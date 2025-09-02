import 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_audiotrack.dart';
import 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_audiotrack_impl.dart';
import 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_audiotrack_events.dart';
import 'package:theoplayer_web/theoplayer_api_event_web.dart';
import 'package:theoplayer_web/theoplayer_api_web.dart';
import 'package:theoplayer_web/theoplayer_js_helpers_web.dart';
import 'package:theoplayer_web/track/audiotrack/theoplayer_audiotrack_impl_web.dart';
import 'package:theoplayer_web/track/texttrack/theoplayer_texttrack_impl_web.dart';
import 'package:theoplayer_web/transformers_web.dart';
import 'dart:js_interop';

class AudioTrackListImplWeb extends AudioTracksImpl {
  final THEOplayerArrayList<THEOplayerAudioTrack> _theoPlayerAudioTracks;

  late final addTrackEventListener;
  late final removeTrackEventListener;
  late final changeTrackEventListener;

  AudioTrackListImplWeb(this._theoPlayerAudioTracks) {
    addTrackEventListener = (AddAudioTrackEventJS event) {
      var track = event.track;

      AudioQualities qualities = toFlutterAudioQualities(JSHelpers.jsArrayToList<THEOplayerAudioQuality>(track.qualities));

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
    }.toJS;

    removeTrackEventListener = (RemoveAudioTrackEventJS event) {
      var track = event.track;

      var flutterTrack = firstWhereOrNull((item) => item.uid == track.uid);
      if (flutterTrack == null) {
        return;
      }

      remove(flutterTrack);
      dispatchEvent(RemoveAudioTrackEvent(track: flutterTrack));
    }.toJS;

    //only triggered for enable/disable
    changeTrackEventListener = (AudioTrackListChangeEventJS event) {
      var track = event.track;

      var flutterTrack = firstWhereOrNull((item) => item.uid == track.uid);
      if (flutterTrack == null) {
        return;
      }

      dispatchEvent(AudioTrackListChangeEvent(track: flutterTrack));
    }.toJS;

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
