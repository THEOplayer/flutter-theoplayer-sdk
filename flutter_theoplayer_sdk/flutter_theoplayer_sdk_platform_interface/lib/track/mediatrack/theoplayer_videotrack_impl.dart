import 'package:flutter/widgets.dart';
import 'package:theoplayer_platform_interface/pigeon/apis.g.dart';
import 'package:theoplayer_platform_interface/theoplayer_event_dispatcher_interface.dart';
import 'package:theoplayer_platform_interface/theoplayer_event_manager.dart';
import 'package:theoplayer_platform_interface/theoplayer_events.dart';
import 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_videotrack.dart';

class VideoTracksImpl extends VideoTracks {
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

abstract class VideoTrackImpl extends VideoTrack {
  final EventManager _eventManager = EventManager();
  VideoQualities? _targetQualities;
  VideoQuality? _targetQuality;
  VideoQuality? _activeQuality;
  bool _isEnabled;

  VideoTrackImpl(super.id, super.uid, super.label, super.language, super.kind, super.qualities, this._isEnabled);

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
  set targetQualities(List<VideoQuality>? targetQualities) {
    VideoQualities? videoQualities = null;
    if (targetQualities != null) {
      videoQualities = VideoQualitiesImpl();
      videoQualities.addAll(targetQualities);
    }
    this._targetQualities = videoQualities;
  }

  @override
  VideoQualities? get targetQualities => _targetQualities;

  @override
  @mustCallSuper
  set targetQuality(VideoQuality? targetQuality) {
    _targetQuality = targetQuality;
  }

  @override
  VideoQuality? get targetQuality => _targetQuality;

  set activeQuality(VideoQuality? activeQuality) {
    _activeQuality = activeQuality;
  }

  @override
  VideoQuality? get activeQuality => _activeQuality;

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

class VideoTrackImplMobile extends VideoTrackImpl {
  final THEOplayerNativeVideoTracksAPI _nativeVideoTrackAPI;

  VideoTrackImplMobile(super.id, super.uid, super.label, super.language, super.kind, super.qualities, super.isEnabled, this._nativeVideoTrackAPI);

  @override
  set targetQualities(List<VideoQuality>? targetQualities) {
    super.targetQualities = targetQualities;
    List<int>? uids = targetQualities?.map((element) => element.uid).toList();
    _nativeVideoTrackAPI.setTargetQualities(uid, uids);
  }

  @override
  set targetQuality(VideoQuality? targetQuality) {
    super.targetQuality = targetQuality;
    _nativeVideoTrackAPI.setTargetQuality(uid, targetQuality?.uid);
  }

  @override
  set isEnabled(bool enabled) {
    super.isEnabled = enabled;
    _nativeVideoTrackAPI.setEnabled(uid, enabled);
  }
}

class VideoQualitiesImpl extends VideoQualities {
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

class VideoQualityImpl extends VideoQuality {
  final EventManager _eventManager = EventManager();
  late String? _name;
  late int _bandwidth;
  late String? _codecs;
  late int _width;
  late int _height;
  late double _frameRate;
  late double _firstFrame;
  late int? _averageBandwidth;
  late bool _available;

  VideoQualityImpl(super.id, super.uid, this._name, this._bandwidth, this._codecs, this._width, this._height, this._frameRate, this._firstFrame, this._averageBandwidth, this._available);

  @override
  String? get name => _name;

  @override
  int get bandwidth => _bandwidth;

  @override
  String? get codecs => _codecs;

  @override
  int get width => _width;

  @override
  int get height => _height;

  @override
  double get frameRate => _frameRate;

  @override
  double get firstFrame => _firstFrame;

  @override
  int? get averageBandwidth => _averageBandwidth;

  @override
  bool get available => _available;

  void update(String? name, int bandwidth, String? codecs, int width, int height, double frameRate, double firstFrame, int? averageBandwidth, bool available) {
    this._name = name;
    this._bandwidth = bandwidth;
    this._codecs = codecs;
    this._width = width;
    this._height = height;
    this._frameRate = frameRate;
    this._firstFrame = firstFrame;
    this._averageBandwidth = averageBandwidth;
    this._available = available;
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
