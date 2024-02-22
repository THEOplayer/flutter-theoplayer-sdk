import 'package:theoplayer_platform_interface/theoplayer_event_dispatcher_interface.dart';
import 'package:theoplayer_platform_interface/theoplayer_event_manager.dart';
import 'package:theoplayer_platform_interface/theoplayer_events.dart';
import 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_audiotrack.dart';
import 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_audiotrack_events.dart';
import 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_videotrack.dart';
import 'package:theoplayer_platform_interface/track/mediatrack/theoplayer_videotrack_events.dart';
import 'package:theoplayer_platform_interface/track/texttrack/theoplayer_texttrack.dart';
import 'package:theoplayer_platform_interface/track/texttrack/theoplayer_texttrack_events.dart';

//TODO: move this into theoplayer.dart

/// Internal helper class to catch TextTrack events in time.
class TextTracksHolder extends TextTracks {
  final EventManager _eventManager = EventManager();
  TextTracks? _wrappedTrackList;

  void forwardingkEventListener(event) {
    _eventManager.dispatchEvent(event);
  }

  TextTracksHolder();

  /// Method to setup the TextTrack event listeners on a TextTrack list ([TextTracks])
  void setup(TextTracks trackListToWrap) {
    _wrappedTrackList = trackListToWrap;
    innerList = trackListToWrap;

    _wrappedTrackList?.addEventListener(TextTracksEventTypes.ADDTRACK, forwardingkEventListener);
    _wrappedTrackList?.addEventListener(TextTracksEventTypes.REMOVETRACK, forwardingkEventListener);
    _wrappedTrackList?.addEventListener(TextTracksEventTypes.CHANGE, forwardingkEventListener);
  }

  /// Method to add eventlisteners for [TextTracksEventTypes].
  @override
  void addEventListener(String eventType, EventListener<Event> listener) {
    _eventManager.addEventListener(eventType, listener);
  }

  /// Method to remove already added eventlisteners for [TextTracksEventTypes].
  @override
  void removeEventListener(String eventType, EventListener<Event> listener) {
    _eventManager.removeEventListener(eventType, listener);
  }

  /// Method to clean the listeners
  void dispose() {
    _wrappedTrackList?.removeEventListener(TextTracksEventTypes.ADDTRACK, forwardingkEventListener);
    _wrappedTrackList?.removeEventListener(TextTracksEventTypes.REMOVETRACK, forwardingkEventListener);
    _wrappedTrackList?.removeEventListener(TextTracksEventTypes.CHANGE, forwardingkEventListener);
    _eventManager.clear();
  }
}

/// Internal helper class to catch AudioTrack events in time.
class AudioTracksHolder extends AudioTracks {
  final EventManager _eventManager = EventManager();
  AudioTracks? _wrappedTrackList;

  void forwardingkEventListener(event) {
    _eventManager.dispatchEvent(event);
  }

  AudioTracksHolder();

  /// Method to setup the AudioTrack event listeners on a TextTrack list ([AudioTracks]).
  void setup(AudioTracks trackListToWrap) {
    _wrappedTrackList = trackListToWrap;
    innerList = trackListToWrap;

    _wrappedTrackList?.addEventListener(AudioTracksEventTypes.ADDTRACK, forwardingkEventListener);
    _wrappedTrackList?.addEventListener(AudioTracksEventTypes.REMOVETRACK, forwardingkEventListener);
    _wrappedTrackList?.addEventListener(AudioTracksEventTypes.CHANGE, forwardingkEventListener);
  }

  /// Method to add eventlisteners for [AudioTracksEventTypes].
  @override
  void addEventListener(String eventType, EventListener<Event> listener) {
    _eventManager.addEventListener(eventType, listener);
  }

  /// Method to remove already added eventlisteners for [AudioTracksEventTypes].
  @override
  void removeEventListener(String eventType, EventListener<Event> listener) {
    _eventManager.removeEventListener(eventType, listener);
  }

  /// Method to clean the listeners.
  void dispose() {
    _wrappedTrackList?.removeEventListener(AudioTracksEventTypes.ADDTRACK, forwardingkEventListener);
    _wrappedTrackList?.removeEventListener(AudioTracksEventTypes.REMOVETRACK, forwardingkEventListener);
    _wrappedTrackList?.removeEventListener(AudioTracksEventTypes.CHANGE, forwardingkEventListener);
    _eventManager.clear();
  }
}

/// Internal helper class to catch VideoTrack events in time.
class VideoTracksHolder extends VideoTracks {
  final EventManager _eventManager = EventManager();
  VideoTracks? _wrappedTrackList;

  void forwardingkEventListener(event) {
    _eventManager.dispatchEvent(event);
  }

  VideoTracksHolder();

  /// Method to setup the VideoTrack event listeners on a TextTrack list ([VideoTracks]).
  void setup(VideoTracks trackListToWrap) {
    _wrappedTrackList = trackListToWrap;
    innerList = trackListToWrap;

    _wrappedTrackList?.addEventListener(VideoTracksEventTypes.ADDTRACK, forwardingkEventListener);
    _wrappedTrackList?.addEventListener(VideoTracksEventTypes.REMOVETRACK, forwardingkEventListener);
    _wrappedTrackList?.addEventListener(VideoTracksEventTypes.CHANGE, forwardingkEventListener);
  }

  /// Method to add eventlisteners for [VideoTracksEventTypes].
  @override
  void addEventListener(String eventType, EventListener<Event> listener) {
    _eventManager.addEventListener(eventType, listener);
  }

  /// Method to remove already added eventlisteners for [VideoTracksEventTypes].
  @override
  void removeEventListener(String eventType, EventListener<Event> listener) {
    _eventManager.removeEventListener(eventType, listener);
  }

  /// Method to clean the listeners.
  void dispose() {
    _wrappedTrackList?.removeEventListener(VideoTracksEventTypes.ADDTRACK, forwardingkEventListener);
    _wrappedTrackList?.removeEventListener(VideoTracksEventTypes.REMOVETRACK, forwardingkEventListener);
    _wrappedTrackList?.removeEventListener(VideoTracksEventTypes.CHANGE, forwardingkEventListener);
    _eventManager.clear();
  }
}
