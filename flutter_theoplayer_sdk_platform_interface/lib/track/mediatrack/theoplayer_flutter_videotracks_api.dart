import 'package:flutter/services.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/pigeon/apis.g.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/track/mediatrack/theoplayer_videotrack.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/track/mediatrack/theoplayer_videotrack_events.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/track/mediatrack/theoplayer_videotrack_impl.dart';

class THEOplayerFlutterVideoTracksAPIImpl implements THEOplayerFlutterVideoTracksAPI {
  late final THEOplayerNativeVideoTracksAPI _nativeVideoTrackAPI;
  late final VideoTracksImpl _videoTracks;

  THEOplayerFlutterVideoTracksAPIImpl({BinaryMessenger? binaryMessenger}) {
    THEOplayerFlutterVideoTracksAPI.setup(this, binaryMessenger: binaryMessenger);
    _nativeVideoTrackAPI = THEOplayerNativeVideoTracksAPI(binaryMessenger: binaryMessenger);
    _videoTracks = VideoTracksImpl();
  }

  VideoTracks getVideoTracks() {
    return _videoTracks;
  }

  @override
  void onAddVideoTrack(String? id, int uid, String? label, String? language, String? kind, bool isEnabled) {
    VideoTrack videoTrack = VideoTrackImplMobile(
        id,
        uid,
        label,
        language,
        kind,
        VideoQualitiesImpl(), // qualities will be populated in onVideoTrackAddQuality
        isEnabled,
        _nativeVideoTrackAPI
    );

    _videoTracks.add(videoTrack);
    _videoTracks.dispatchEvent(AddVideoTrackEvent(track: videoTrack));
  }

  @override
  void onVideoTrackAddQuality(int videoTrackUid, String qualityId, int qualityUid, String? name, int bandwidth, String? codecs, int width, int height, double frameRate, double firstFrame) {
    VideoTrack? videoTrack = _videoTracks.firstWhereOrNull((item) => item.uid == videoTrackUid);
    if (videoTrack == null) {
      return;
    }
    
    VideoQualityImpl videoQuality = VideoQualityImpl(qualityId, qualityUid, name, bandwidth, codecs, width, height, frameRate, firstFrame);
    videoTrack.qualities.add(videoQuality);
  }

  @override
  void onRemoveVideoTrack(int uid) {
    VideoTrack? videoTrack = _videoTracks.firstWhereOrNull((item) => item.uid == uid);
    if (videoTrack == null) {
      return;
    }

    _videoTracks.remove(videoTrack);
    _videoTracks.dispatchEvent(RemoveVideoTrackEvent(track: videoTrack));
  }

  @override
  void onVideoTrackListChange(int uid) {
    VideoTrack? videoTrack = _videoTracks.firstWhereOrNull((item) => item.uid == uid);
    if (videoTrack == null) {
      return;
    }

    _videoTracks.dispatchEvent(VideoTrackListChangeEvent(track: videoTrack));
  }

  @override
  void onTargetQualityChange(int videoTrackUid, List<int?> qualitiesUid, int? qualityUid) {
    VideoTrackImpl? videoTrack = _videoTracks.firstWhereOrNull((item) => item.uid == videoTrackUid) as VideoTrackImpl?;
    if (videoTrack == null) {
      return;
    }

    VideoQualitiesImpl targetQualities = VideoQualitiesImpl();
    targetQualities.addAll(
        videoTrack.qualities.where((element) => qualitiesUid.contains(element.uid))
    );
    VideoQuality? targetQuality = videoTrack.qualities.firstWhereOrNull((element) => element.uid == qualityUid);

    videoTrack.targetQualities = targetQualities;
    videoTrack.targetQuality = targetQuality;
    videoTrack.dispatchEvent(VideoTargetQualityChangedEvent(qualities: targetQualities, quality: targetQuality));
  }

  @override
  void onActiveQualityChange(int videoTrackUid, int qualityUid) {
    VideoTrackImpl? videoTrack = _videoTracks.firstWhereOrNull((item) => item.uid == videoTrackUid) as VideoTrackImpl?;
    VideoQuality? videoQuality = videoTrack?.qualities.firstWhereOrNull((item) => item.uid == qualityUid);
    if (videoTrack == null || videoQuality == null) {
      return;
    }

    videoTrack.activeQuality = videoQuality;
    videoTrack.dispatchEvent(VideoActiveQualityChangedEvent(quality: videoQuality));
  }

  @override
  void onQualityUpdate(int videoTrackUid, int qualityUid, String? name, int bandwidth, String? codecs, int width, int height, double frameRate, double firstFrame) {
    VideoTrack? videoTrack = _videoTracks.firstWhereOrNull((item) => item.uid == videoTrackUid);
    VideoQualityImpl? videoQuality = videoTrack?.qualities.firstWhereOrNull((item) => item.uid == qualityUid) as VideoQualityImpl?;
    if (videoQuality == null) {
      return;
    }

    videoQuality.update(name, bandwidth, codecs, width, height, frameRate, firstFrame);
    videoQuality.dispatchEvent(VideoQualityUpdateEvent());
  }

  void dispose() {
    _videoTracks.dispose();
  }

}
