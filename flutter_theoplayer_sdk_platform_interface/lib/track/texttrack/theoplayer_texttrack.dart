import 'dart:collection';

import 'package:theoplayer_platform_interface/pigeon/apis.g.dart';
import 'package:theoplayer_platform_interface/theoplayer_event_dispatcher_interface.dart';
import 'package:theoplayer_platform_interface/theoplayer_events.dart';
import 'package:theoplayer_platform_interface/track/theoplayer_track.dart';

abstract class TextTracks extends Tracks<TextTrack> {
  /// Add the given listener for the given [TextTracksEventTypes] type(s).
  @override
  void addEventListener(String eventType, EventListener<Event> listener);

  /// Remove the given listener for the given [TextTracksEventTypes] type(s).
  @override
  void removeEventListener(String eventType, EventListener<Event> listener);
}

/// Represents a text track of a media resource.
abstract class TextTrack extends Track {
  final String? _inBandMetadataTrackDispatchType;
  final TextTrackReadyState _readyState;
  final TextTrackType _type;
  final Cues _cues;
  final Cues _activeCues;
  final String? _source;
  final bool _isForced;

  TextTrack(super._id, super._uid, super._label, super._language, super._kind, this._inBandMetadataTrackDispatchType, this._readyState, this._type, this._cues, this._activeCues, this._source, this._isForced);

  /// The in-band metadata track dispatch type of the text track.
  String? get inBandMetadataTrackDispatchType => _inBandMetadataTrackDispatchType;

  /// The ready state of the text track.
  TextTrackReadyState get readyState => _readyState;

  /// The content type of the text track.
  TextTrackType get type => _type;

  /// The list of cues of the track.
  Cues get cues => _cues;

  /// The list of active cues of the track.
  /// 
  /// Remarks:
  /// * A cue is active if the current playback position falls within the time bounds of the cue.
  /// * This list dynamically updates based on the current playback position.
  Cues get activeCues => _activeCues;

  /// The source of the text track.
  String? get source => _source;

  /// Indicates whether the track contains Forced Narrative cues. This may only be true for subtitle tracks where
  /// * For DASH: the corresponding AdaptationSet contains a child Role with its value attribute equal to 'forced_subtitle'
  /// * For HLS: the corresponding #EXT-X-MEDIA tag contains the attributes TYPE=SUBTITLES and FORCED=YES (not supported yet)
  bool get isForced => _isForced;

  /// Sets mode of the text track, represented by a value from the following list:
  /// * [TextTrackMode.disabled] : The track is disabled.
  /// * [TextTrackMode.hidden] : The track is hidden.
  /// * [TextTrackMode.showing] : The track is showing.
  /// 
  /// Remarks:
  /// * A disabled track is not displayed and exposes no active cues, nor fires cue events.
  /// * A hidden track is not displayed but exposes active cues and fires cue events.
  /// * A showing track is displayed, exposes active cues and fires cue events.
  void setMode(TextTrackMode mode);

  /// The mode of the text track, represented by a value from the following list:
  /// * [TextTrackMode.disabled] : The track is disabled.
  /// * [TextTrackMode.hidden] : The track is hidden.
  /// * [TextTrackMode.showing] : The track is showing.
  TextTrackMode getMode();
}

class Cues extends ListBase<Cue> {
  List<Cue> innerList = [];

  @override
  int get length => innerList.length;

  @override
  set length(int length) {
    innerList.length = length;
  }

  @override
  void operator []=(int index, Cue value) {
    innerList[index] = value;
  }

  @override
  Cue operator [](int index) => innerList[index];

  @override
  void add(Cue value) => innerList.add(value);

  @override
  void addAll(Iterable<Cue> all) => innerList.addAll(all);

  Cue? firstWhereOrNull(bool Function(Cue element) test, {Cue Function()? orElse}) {
    int length = this.length;
    for (int i = 0; i < length; i++) {
      Cue element = this[i];
      if (test(element)) return element;
      if (length != this.length) {
        throw ConcurrentModificationError(this);
      }
    }
    if (orElse != null) return orElse();
    return null;
  }
}

abstract class Cue implements EventDispatcher {
  final String _id;
  final int _uid;
  final double _startTime;

  Cue(this._id, this._uid, this._startTime);

  /// The identifier of the cue.
  String get id => _id;

  /// A unique identifier of the text track cue.
  int get uid => _uid;

  /// The playback position at which the cue becomes active, in seconds.
  double get startTime => _startTime;

  /// The playback position at which the cue becomes inactive, in seconds.
  double get endTime;

  /// The content of the cue.
  String get content;
}
