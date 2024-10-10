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

  TextTrackImpl(super.id, super.uid, super.label, super.language, super.kind, super.inBandMetadataTrackDispatchType, super.readyState, super.type, super.cues, super.activeCues, super.source, super.isForced, this._mode);

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

  TextTrackImplMobile(super.id, super.uid, super.label, super.language, super.kind, super.inBandMetadataTrackDispatchType, super.readyState, super.type, super.cues, super.activeCues, super.source, super.isForced, super.mode, this._nativeTextTrackAPI);

  @override
  void setMode(TextTrackMode mode) {
    super.setMode(mode);
    _nativeTextTrackAPI.setMode(uid, mode);
  }
}

class CueImpl extends Cue {
  final EventManager _eventManager = EventManager();
  double _endTime;
  String _content;

  CueImpl(super.id, super.uid, super.startTime, this._endTime, this._content);

  @override
  String get content => _content;

  @override
  double get endTime => _endTime;

  void update(double endTime, String content) {
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
