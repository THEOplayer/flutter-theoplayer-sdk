import 'package:flutter/material.dart';
import 'package:theoplayer_platform_interface/pigeon/apis.g.dart';
import 'package:theoplayer_platform_interface/theoplayer_event_dispatcher_interface.dart';
import 'package:theoplayer_platform_interface/theoplayer_event_manager.dart';
import 'package:theoplayer_platform_interface/theoplayer_events.dart';
import 'package:theoplayer_platform_interface/track/texttrack/theoplayer_texttrack.dart';

class TextTracksImpl extends TextTracks {
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

abstract class TextTrackImpl extends TextTrack {
  final EventManager _eventManager = EventManager();
  TextTrackMode _mode = TextTrackMode.hidden;

  TextTrackImpl(super.id, super.uid, super.label, super.language, super.kind, super.inBandMetadataTrackDispatchType, super.readyState, super.type, super.cues, super.activeCues, super.source,
      super.isForced, this._mode);

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
  TextTrackMode getMode() {
    return _mode;
  }

  @override
  @mustCallSuper
  void setMode(TextTrackMode mode) {
    _mode = mode;
  }

  void dispose() {
    _eventManager.clear();
  }
}

class TextTrackImplMobile extends TextTrackImpl {
  final THEOplayerNativeTextTracksAPI _nativeTextTrackAPI;

  TextTrackImplMobile(super.id, super.uid, super.label, super.language, super.kind, super.inBandMetadataTrackDispatchType, super.readyState, super.type, super.cues, super.activeCues, super.source,
      super.isForced, super.mode, this._nativeTextTrackAPI);

  @override
  void setMode(TextTrackMode mode) {
    super.setMode(mode);
    _nativeTextTrackAPI.setMode(uid, mode);
  }
}

class CueImpl extends Cue {
  final EventManager _eventManager = EventManager();
  double _endTime;
  dynamic _content;

  CueImpl(super.id, super.uid, super.startTime, this._endTime, this._content);

  @override
  dynamic get content => _content;

  @override
  double get endTime => _endTime;

  void update(double endTime, dynamic content) {
    _endTime = endTime;
    _content = content;
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

class DateRangeCueImpl extends DateRangeCue {
  final EventManager _eventManager = EventManager();
  double _endTime;
  final DateTime _startDate;
  final DateTime? _endDate;
  final double? _duration;
  final double? _plannedDuration;
  final String? _cueClass;
  final bool _endOnNext;
  final Map<String, dynamic>? _customAttributes;

  DateRangeCueImpl(super.id, super.uid, super.startTime, this._endTime, this._startDate, this._endDate, this._duration, this._plannedDuration, this._cueClass, this._endOnNext, this._customAttributes);

  @override
  double get endTime => _endTime;

  @override
  dynamic get content => _customAttributes;

  @override
  DateTime get startDate => _startDate;

  @override
  DateTime? get endDate => _endDate;

  @override
  double? get duration => _duration;

  @override
  double? get plannedDuration => _plannedDuration;

  @override
  String? get cueClass => _cueClass;

  @override
  bool get endOnNext => _endOnNext;

  @override
  Map<String, dynamic>? get customAttributes => _customAttributes;

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
