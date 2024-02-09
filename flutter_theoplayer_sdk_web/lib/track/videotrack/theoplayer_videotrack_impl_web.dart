import 'dart:js';

import 'package:flutter_theoplayer_sdk_platform_interface/track/mediatrack/theoplayer_videotrack.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/track/mediatrack/theoplayer_videotrack_events.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/track/mediatrack/theoplayer_videotrack_impl.dart';
import 'package:flutter_theoplayer_sdk_web/theoplayer_api_event_web.dart';
import 'package:flutter_theoplayer_sdk_web/theoplayer_api_web.dart';

class VideoTrackImplWeb extends VideoTrackImpl {
  final THEOplayerVideoTrack _nativeVideoTrack;

  late final aciveQualityChangedEventListener;
  late final targetQualityChangedListener;


  VideoTrackImplWeb(super.id, super.uid, super.label, super.language, super.kind, super.qualities, super.isEnabled, this._nativeVideoTrack) {

    targetQualityChangedListener = allowInterop((VideoTargetQualityChangedEventJS event){
      var eventTargetQualities = event.qualities;
      var eventTargetQuality = event.quality;

      var targetQualitiesUid = [];
      for (var i = 0; i < eventTargetQualities.length; i++) {
        THEOplayerVideoQuality q = eventTargetQualities[i];
        targetQualitiesUid.add(q.uid);
      }

      VideoQualities flutterTargetQualities = VideoQualitiesImpl();
      flutterTargetQualities.addAll(
          this.qualities.where((element) => targetQualitiesUid.contains(element.uid))
      );

      VideoQuality? flutterTargetQuality = eventTargetQuality != null ? this.qualities.firstWhereOrNull((element) => element.uid == eventTargetQuality.uid) : null;

      super.targetQualities = flutterTargetQualities;
      super.targetQuality = flutterTargetQuality;
      dispatchEvent(VideoTargetQualityChangedEvent(qualities: flutterTargetQualities, quality: flutterTargetQuality));
    });

    aciveQualityChangedEventListener = allowInterop((VideoActiveQualityChangedEventJS event){
      var eventTargetQuality = event.quality;
      VideoQuality? flutterActiveQuality = this.qualities.firstWhereOrNull((element) => element.uid == eventTargetQuality.uid);
      if (flutterActiveQuality == null) {
        //TODO: debug log, quality is lost or don't allow null.
        return;
      }

      super.activeQuality = flutterActiveQuality;
      dispatchEvent(VideoActiveQualityChangedEvent(quality: flutterActiveQuality));
    });

    this._nativeVideoTrack.addEventListener(VideoTrackEventTypes.TARGETQUALITYCHANGED.toLowerCase(), targetQualityChangedListener);
    this._nativeVideoTrack.addEventListener(VideoTrackEventTypes.ACTIVEQUALITYCHANGED.toLowerCase(), aciveQualityChangedEventListener);
  }

  @override
  set targetQualities(List<VideoQuality>? targetQualities) {
    super.targetQualities = targetQualities;

    List<THEOplayerVideoQuality>? theoplayerQualities = null;

    if (targetQualities != null) {
      theoplayerQualities = [];

      var flutterUidMap = targetQualities.map((element) => element.uid);

      for (var i = 0; i < _nativeVideoTrack.qualities.length; i++) {
        THEOplayerVideoQuality q = _nativeVideoTrack.qualities[i];
        if (flutterUidMap.contains(q.uid)) {
          theoplayerQualities.add(q);
        }
      }
    }

    _nativeVideoTrack.targetQuality = theoplayerQualities;
  }

  @override
  set targetQuality(VideoQuality? targetQuality) {
    super.targetQuality = targetQuality;
  
    List<THEOplayerVideoQuality>? theoplayerQualities = null;

    if (targetQuality != null) {
      theoplayerQualities = [];

      for (var i = 0; i < _nativeVideoTrack.qualities.length; i++) {
        THEOplayerVideoQuality q = _nativeVideoTrack.qualities[i];
        if (targetQuality.uid == q.uid) {
          theoplayerQualities.add(q);
          break;
        }
      }
    }
    
    _nativeVideoTrack.targetQuality = theoplayerQualities;
  }

  @override
  set isEnabled(bool value) {
    super.isEnabled = value;
    _nativeVideoTrack.enabled = value;
  }

  void dispose() {
    this._nativeVideoTrack.removeEventListener(VideoTrackEventTypes.TARGETQUALITYCHANGED.toLowerCase(), targetQualityChangedListener);
    this._nativeVideoTrack.removeEventListener(VideoTrackEventTypes.ACTIVEQUALITYCHANGED.toLowerCase(), aciveQualityChangedEventListener);
    super.dispose();
  }
}
