import 'package:flutter/services.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/pigeon/apis.g.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/track/mediatrack/theoplayer_audiotrack.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/track/mediatrack/theoplayer_audiotrack_events.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/track/mediatrack/theoplayer_audiotrack_impl.dart';

class THEOplayerFlutterAudioTracksAPIImpl implements THEOplayerFlutterAudioTracksAPI {
  late final THEOplayerNativeAudioTracksAPI _nativeAudioTrackAPI;
  late final AudioTracksImpl _audioTracks;

  THEOplayerFlutterAudioTracksAPIImpl({BinaryMessenger? binaryMessenger}) {
    THEOplayerFlutterAudioTracksAPI.setup(this, binaryMessenger: binaryMessenger);
    _nativeAudioTrackAPI = THEOplayerNativeAudioTracksAPI(binaryMessenger: binaryMessenger);
    _audioTracks = AudioTracksImpl();
  }

  AudioTracks getAudioTracks() {
    return _audioTracks;
  }

  @override
  void onAddAudioTrack(String? id, int uid, String? label, String? language, String? kind, bool isEnabled) {
    AudioTrack audioTrack = AudioTrackImplMobile(
        id,
        uid,
        label,
        language,
        kind,
        AudioQualitiesImpl(), // qualities will be populated in onAudioTrackAddQuality
        isEnabled,
        _nativeAudioTrackAPI
    );

    _audioTracks.add(audioTrack);
    _audioTracks.dispatchEvent(AddAudioTrackEvent(track: audioTrack));
  }

  @override
  void onAudioTrackAddQuality(int audioTrackUid, String qualityId, int qualityUid, String? name, int bandwidth, String? codecs, int audioSamplingRate) {
    AudioTrack? audioTrack = _audioTracks.firstWhereOrNull((item) => item.uid == audioTrackUid);
    if (audioTrack == null) {
      return;
    }

    AudioQualityImpl audioQuality = AudioQualityImpl(qualityId, qualityUid, name, bandwidth, codecs, audioSamplingRate);
    audioTrack.qualities.add(audioQuality);
  }

  @override
  void onRemoveAudioTrack(int uid) {
    AudioTrack? audioTrack = _audioTracks.firstWhereOrNull((item) => item.uid == uid);
    if (audioTrack == null) {
      return;
    }

    _audioTracks.remove(audioTrack);
    _audioTracks.dispatchEvent(RemoveAudioTrackEvent(track: audioTrack));
  }

  @override
  void onAudioTrackListChange(int uid) {
    AudioTrack? audioTrack = _audioTracks.firstWhereOrNull((item) => item.uid == uid);
    if (audioTrack == null) {
      return;
    }

    _audioTracks.dispatchEvent(AudioTrackListChangeEvent(track: audioTrack));
  }

  @override
  void onTargetQualityChange(int audioTrackUid, List<int?> qualitiesUid, int? qualityUid) {
    AudioTrackImpl? audioTrack = _audioTracks.firstWhereOrNull((item) => item.uid == audioTrackUid) as AudioTrackImpl?;
    if (audioTrack == null) {
      return;
    }

    AudioQualitiesImpl targetQualities = AudioQualitiesImpl();
    targetQualities.addAll(
        audioTrack.qualities.where((element) => qualitiesUid.contains(element.uid))
    );
    AudioQuality? targetQuality = audioTrack.qualities.firstWhereOrNull((element) => element.uid == qualityUid);

    audioTrack.targetQualities = targetQualities;
    audioTrack.targetQuality = targetQuality;
    audioTrack.dispatchEvent(AudioTargetQualityChangedEvent(qualities: targetQualities, quality: targetQuality));
  }

  @override
  void onActiveQualityChange(int audioTrackUid, int qualityUid) {
    AudioTrackImpl? audioTrack = _audioTracks.firstWhereOrNull((item) => item.uid == audioTrackUid) as AudioTrackImpl?;
    AudioQuality? audioQuality = audioTrack?.qualities.firstWhereOrNull((item) => item.uid == qualityUid);
    if (audioTrack == null || audioQuality == null) {
      return;
    }

    audioTrack.activeQuality = audioQuality;
    audioTrack.dispatchEvent(AudioActiveQualityChangedEvent(quality: audioQuality));
  }

  @override
  void onQualityUpdate(int audioTrackUid, int qualityUid, String? name, int bandwidth, String? codecs, int audioSamplingRate) {
    AudioTrack? audioTrack = _audioTracks.firstWhereOrNull((item) => item.uid == audioTrackUid);
    AudioQualityImpl? audioQuality = audioTrack?.qualities.firstWhereOrNull((item) => item.uid == qualityUid) as AudioQualityImpl?;
    if (audioQuality == null) {
      return;
    }

    audioQuality.update(name, bandwidth, codecs, audioSamplingRate);
    audioQuality.dispatchEvent(AudioQualityUpdateEvent());
  }

  void dispose() {
    _audioTracks.dispose();
  }

}
