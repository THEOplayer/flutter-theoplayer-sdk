import 'dart:js';

import 'package:flutter_theoplayer_sdk_platform_interface/track/mediatrack/theoplayer_audiotrack.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/track/mediatrack/theoplayer_audiotrack_events.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/track/mediatrack/theoplayer_audiotrack_impl.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/track/mediatrack/theoplayer_mediatrack.dart';
import 'package:flutter_theoplayer_sdk_web/theoplayer_api_web.dart';
import 'package:flutter_theoplayer_sdk_web/transformers_web.dart';

class AudioTrackImplWeb extends AudioTrackImpl {
  final THEOplayerAudioTrack _nativeAudioTrack;

  late final aciveQualityChangedEventListener;
  late final targetQualityChangedListener;


  AudioTrackImplWeb(super.id, super.uid, super.label, super.language, super.kind, super.qualities, super.isEnabled, this._nativeAudioTrack) {

    targetQualityChangedListener = allowInterop((event){
      var eventTargetQualities = event.qualities;
      var eventTargetQuality = event.quality as THEOplayerAudioQuality?;

      var targetQualitiesUid = [];
      for (var i = 0; i < eventTargetQualities.length; i++) {
        THEOplayerAudioQuality q = eventTargetQualities[i];
        targetQualitiesUid.add(q.uid);
      }

      AudioQualities flutterTargetQualities = AudioQualitiesImpl();
      flutterTargetQualities.addAll(
          this.qualities.where((element) => targetQualitiesUid.contains(element.uid))
      );

      AudioQuality? flutterTargetQuality = eventTargetQuality != null ? this.qualities.firstWhereOrNull((element) => element.uid == eventTargetQuality.uid) : null;

      super.targetQualities = flutterTargetQualities;
      super.targetQuality = flutterTargetQuality;
      dispatchEvent(AudioTargetQualityChangedEvent(qualities: flutterTargetQualities, quality: flutterTargetQuality));
    });

    aciveQualityChangedEventListener = allowInterop((event){
      var eventTargetQuality = event.quality as THEOplayerAudioQuality;
      AudioQuality? flutterActiveQuality = this.qualities.firstWhereOrNull((element) => element.uid == eventTargetQuality.uid);
      if (flutterActiveQuality == null) {
        //TODO: debug log, quality is lost or don't allow null.
        return;
      }

      super.activeQuality = flutterActiveQuality;
      dispatchEvent(AudioActiveQualityChangedEvent(quality: flutterActiveQuality));
    });

    this._nativeAudioTrack.addEventListener(AudioTrackEventTypes.TARGETQUALITYCHANGED.toLowerCase(), targetQualityChangedListener);
    this._nativeAudioTrack.addEventListener(AudioTrackEventTypes.ACTIVEQUALITYCHANGED.toLowerCase(), aciveQualityChangedEventListener);
  }

  @override
  set targetQualities(List<AudioQuality>? targetQualities) {
    super.targetQualities = targetQualities;

    List<THEOplayerAudioQuality>? theoplayerQualities = null;

    if (targetQualities != null) {
      theoplayerQualities = [];

      var flutterUidMap = targetQualities.map((element) => element.uid);

      for (var i = 0; i < _nativeAudioTrack.qualities.length; i++) {
        THEOplayerAudioQuality q = _nativeAudioTrack.qualities[i];
        if (flutterUidMap.contains(q.uid)) {
          theoplayerQualities.add(q);
        }
      }
    }


    _nativeAudioTrack.targetQuality = theoplayerQualities;
  }

  @override
  set targetQuality(AudioQuality? targetQuality) {
    super.targetQuality = targetQuality;
  
    List<THEOplayerAudioQuality>? theoplayerQualities = null;

    if (targetQuality != null) {
      theoplayerQualities = [];

      for (var i = 0; i < _nativeAudioTrack.qualities.length; i++) {
        THEOplayerAudioQuality q = _nativeAudioTrack.qualities[i];
        if (targetQuality.uid == q.uid) {
          theoplayerQualities.add(q);
          break;
        }
      }
    }
    
    _nativeAudioTrack.targetQuality = theoplayerQualities;
  }

  @override
  set isEnabled(bool value) {
    super.isEnabled = value;
    _nativeAudioTrack.enabled = value;
  }

  void dispose() {
    this._nativeAudioTrack.removeEventListener(AudioTrackEventTypes.TARGETQUALITYCHANGED.toLowerCase(), targetQualityChangedListener);
    this._nativeAudioTrack.removeEventListener(AudioTrackEventTypes.ACTIVEQUALITYCHANGED.toLowerCase(), aciveQualityChangedEventListener);
    super.dispose();
  }
}
