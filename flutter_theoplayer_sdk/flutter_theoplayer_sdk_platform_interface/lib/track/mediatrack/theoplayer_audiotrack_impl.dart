import 'package:flutter/widgets.dart';
import 'package:theoplayer_platform_interface/pigeon/apis.g.dart';
import 'package:theoplayer_platform_interface/theoplayer_event_dispatcher_interface.dart';
import 'package:theoplayer_platform_interface/theoplayer_event_manager.dart';
import 'package:theoplayer_platform_interface/theoplayer_events.dart';
import 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_audiotrack.dart';

class AudioTracksImpl extends AudioTracks {
  final EventManager _eventManager = EventManager();

  @override
  void addEventListener(String eventType, EventListener<Event> listener) {
    _eventManager.addEventListener(eventType, listener);
  }

  @override
  void removeEventListener(String eventType, EventListener<Event> listener) {
    _eventManager.removeEventListener(eventType, listener);
  }

  void dispatchEvent(Event event) {
    _eventManager.dispatchEvent(event);
  }

  void dispose() {
    _eventManager.clear();
  }
}

abstract class AudioTrackImpl extends AudioTrack {
  final EventManager _eventManager = EventManager();
  AudioQualities? _targetQualities;
  AudioQuality? _targetQuality;
  AudioQuality? _activeQuality;
  bool _isEnabled;

  AudioTrackImpl(super.id, super.uid, super.label, super.language, super.kind, super.qualities, this._isEnabled);

  @override
  void addEventListener(String eventType, EventListener<Event> listener) {
    _eventManager.addEventListener(eventType, listener);
  }

  @override
  void removeEventListener(String eventType, EventListener<Event> listener) {
    _eventManager.removeEventListener(eventType, listener);
  }

  void dispatchEvent(Event event) {
    _eventManager.dispatchEvent(event);
  }

  @override
  @mustCallSuper
  set targetQualities(List<AudioQuality>? targetQualities) {
    AudioQualities? audioQualities = null;
    if (targetQualities != null) {
      audioQualities = AudioQualitiesImpl();
      audioQualities.addAll(targetQualities);
    }
    this._targetQualities = audioQualities;
  }

  @override
  AudioQualities? get targetQualities => _targetQualities;

  @override
  @mustCallSuper
  set targetQuality(AudioQuality? targetQuality) {
    _targetQuality = targetQuality;
  }

  @override
  AudioQuality? get targetQuality => _targetQuality;

  set activeQuality(AudioQuality? activeQuality) {
    _activeQuality = activeQuality;
  }

  @override
  AudioQuality? get activeQuality => _activeQuality;

  @override
  @mustCallSuper
  set isEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  @override
  bool get isEnabled => _isEnabled;

  void dispose() {
    _eventManager.clear();
  }
}

class AudioTrackImplMobile extends AudioTrackImpl {
  final THEOplayerNativeAudioTracksAPI _nativeAudioTrackAPI;

  AudioTrackImplMobile(super.id, super.uid, super.label, super.language, super.kind, super.qualities, super.isEnabled, this._nativeAudioTrackAPI);

  @override
  set targetQualities(List<AudioQuality>? targetQualities) {
    super.targetQualities = targetQualities;
    List<int>? uids = targetQualities?.map((element) => element.uid).toList();
    _nativeAudioTrackAPI.setTargetQualities(uid, uids);
  }

  @override
  set targetQuality(AudioQuality? targetQuality) {
    super.targetQuality = targetQuality;
    _nativeAudioTrackAPI.setTargetQuality(uid, targetQuality?.uid);
  }

  @override
  set isEnabled(bool enabled) {
    super.isEnabled = enabled;
    _nativeAudioTrackAPI.setEnabled(uid, enabled);
  }
}

class AudioQualitiesImpl extends AudioQualities {
  final EventManager _eventManager = EventManager();

  @override
  void addEventListener(String eventType, EventListener<Event> listener) {
    _eventManager.addEventListener(eventType, listener);
  }

  @override
  void removeEventListener(String eventType, EventListener<Event> listener) {
    _eventManager.removeEventListener(eventType, listener);
  }

  void dispatchEvent(Event event) {
    _eventManager.dispatchEvent(event);
  }

  void dispose() {
    _eventManager.clear();
  }
}

class AudioQualityImpl extends AudioQuality {
  final EventManager _eventManager = EventManager();
  late String? _name;
  late int _bandwidth;
  late String? _codecs;
  late int _audioSamplingRate;

  AudioQualityImpl(super.id, super.uid, this._name, this._bandwidth, this._codecs, this._audioSamplingRate);

  @override
  String? get name => _name;

  @override
  int get bandwidth => _bandwidth;

  @override
  String? get codecs => _codecs;

  @override
  int get audioSamplingRate => _audioSamplingRate;

  void update(String? name, int bandwidth, String? codecs, int audioSamplingRate) {
    this._name = name;
    this._bandwidth = bandwidth;
    this._codecs = codecs;
    this._audioSamplingRate = audioSamplingRate;
  }

  @override
  void addEventListener(String eventType, EventListener<Event> listener) {
    _eventManager.addEventListener(eventType, listener);
  }

  @override
  void removeEventListener(String eventType, EventListener<Event> listener) {
    _eventManager.removeEventListener(eventType, listener);
  }

  void dispatchEvent(Event event) {
    _eventManager.dispatchEvent(event);
  }

  void dispose() {
    _eventManager.clear();
  }
}
