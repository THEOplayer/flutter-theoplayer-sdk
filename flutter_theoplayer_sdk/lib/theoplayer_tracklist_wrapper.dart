import 'package:flutter_theoplayer_sdk_platform_interface/theoplayer_event_dispatcher_interface.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/theoplayer_event_manager.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/theoplayer_events.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/track/mediatrack/theoplayer_audiotrack.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/track/mediatrack/theoplayer_audiotrack_events.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/track/mediatrack/theoplayer_videotrack.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/track/mediatrack/theoplayer_videotrack_events.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/track/texttrack/theoplayer_texttrack.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/track/texttrack/theoplayer_texttrack_events.dart';

class TextTracksHolder extends TextTracks {
  final EventManager _eventManager = EventManager();
  TextTracks? _wrappedTrackList;

  void forwardingkEventListener(event) {
    _eventManager.dispatchEvent(event);
  }

  TextTracksHolder();

  void setup(TextTracks trackListToWrap) {
    _wrappedTrackList = trackListToWrap;
    innerList = trackListToWrap;

    _wrappedTrackList?.addEventListener(TextTracksEventTypes.ADDTRACK, forwardingkEventListener);
    _wrappedTrackList?.addEventListener(TextTracksEventTypes.REMOVETRACK, forwardingkEventListener);
    _wrappedTrackList?.addEventListener(TextTracksEventTypes.CHANGE, forwardingkEventListener);
  }

  @override
  void addEventListener(String eventType, EventListener<Event> listener) {
    _eventManager.addEventListener(eventType, listener);
  }

  @override
  void removeEventListener(String eventType, EventListener<Event> listener) {
    _eventManager.removeEventListener(eventType, listener);
  }

  void dispose() {
    _wrappedTrackList?.removeEventListener(TextTracksEventTypes.ADDTRACK, forwardingkEventListener);
    _wrappedTrackList?.removeEventListener(TextTracksEventTypes.REMOVETRACK, forwardingkEventListener);
    _wrappedTrackList?.removeEventListener(TextTracksEventTypes.CHANGE, forwardingkEventListener);
    _eventManager.clear();
  }
}

class AudioTracksHolder extends AudioTracks {
  final EventManager _eventManager = EventManager();
  AudioTracks? _wrappedTrackList;

  void forwardingkEventListener(event) {
    _eventManager.dispatchEvent(event);
  }

  AudioTracksHolder();

  void setup(AudioTracks trackListToWrap) {
    _wrappedTrackList = trackListToWrap;
    innerList = trackListToWrap;

    _wrappedTrackList?.addEventListener(AudioTracksEventTypes.ADDTRACK, forwardingkEventListener);
    _wrappedTrackList?.addEventListener(AudioTracksEventTypes.REMOVETRACK, forwardingkEventListener);
    _wrappedTrackList?.addEventListener(AudioTracksEventTypes.CHANGE, forwardingkEventListener);
  }

  @override
  void addEventListener(String eventType, EventListener<Event> listener) {
    _eventManager.addEventListener(eventType, listener);
  }

  @override
  void removeEventListener(String eventType, EventListener<Event> listener) {
    _eventManager.removeEventListener(eventType, listener);
  }

  void dispose() {
    _wrappedTrackList?.removeEventListener(AudioTracksEventTypes.ADDTRACK, forwardingkEventListener);
    _wrappedTrackList?.removeEventListener(AudioTracksEventTypes.REMOVETRACK, forwardingkEventListener);
    _wrappedTrackList?.removeEventListener(AudioTracksEventTypes.CHANGE, forwardingkEventListener);
    _eventManager.clear();
  }
}

class VideoTracksHolder extends VideoTracks {
  final EventManager _eventManager = EventManager();
  VideoTracks? _wrappedTrackList;

  void forwardingkEventListener(event) {
    _eventManager.dispatchEvent(event);
  }

  VideoTracksHolder();

  void setup(VideoTracks trackListToWrap) {
    _wrappedTrackList = trackListToWrap;
    innerList = trackListToWrap;

    _wrappedTrackList?.addEventListener(VideoTracksEventTypes.ADDTRACK, forwardingkEventListener);
    _wrappedTrackList?.addEventListener(VideoTracksEventTypes.REMOVETRACK, forwardingkEventListener);
    _wrappedTrackList?.addEventListener(VideoTracksEventTypes.CHANGE, forwardingkEventListener);
  }

  @override
  void addEventListener(String eventType, EventListener<Event> listener) {
    _eventManager.addEventListener(eventType, listener);
  }

  @override
  void removeEventListener(String eventType, EventListener<Event> listener) {
    _eventManager.removeEventListener(eventType, listener);
  }

  void dispose() {
    _wrappedTrackList?.removeEventListener(VideoTracksEventTypes.ADDTRACK, forwardingkEventListener);
    _wrappedTrackList?.removeEventListener(VideoTracksEventTypes.REMOVETRACK, forwardingkEventListener);
    _wrappedTrackList?.removeEventListener(VideoTracksEventTypes.CHANGE, forwardingkEventListener);
    _eventManager.clear();
  }
}
