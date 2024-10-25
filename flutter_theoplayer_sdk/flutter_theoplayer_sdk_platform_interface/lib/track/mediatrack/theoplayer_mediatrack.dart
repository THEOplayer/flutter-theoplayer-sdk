import 'dart:collection';

import 'package:theoplayer_platform_interface/theoplayer_event_dispatcher_interface.dart';
import 'package:theoplayer_platform_interface/track/theoplayer_track.dart';

abstract class MediaTracks<T extends MediaTrack> extends Tracks<T> {}

abstract class MediaTrack<Q extends Quality, L extends Qualities> extends Track {
  final L _qualities;

  MediaTrack(super._id, super._uid, super._label, super._language, super._kind, this._qualities);

  /// The qualities of the media track.
  L get qualities => _qualities;

  set targetQualities(List<Q>? targetQualities);

  /// One or more desired qualities of the media track.
  ///
  /// Remarks:
  /// * If desired qualities are present, the Adaptive Bitrate mechanism of the player will limit itself to these qualities.
  /// * If one desired quality is present, the Adaptive Bitrate mechanism of the player will be disabled and the desired quality will be played back.
  ///
  /// Limitations:
  /// * Not available on iOS
  List<Q>? get targetQualities;

  set targetQuality(Q? targetQuality);

  /// The desired qualities of the media track.
  ///
  /// Remarks:
  /// * If desired qualities are present, the Adaptive Bitrate mechanism of the player will limit itself to these qualities.
  /// * If one desired quality is present, the Adaptive Bitrate mechanism of the player will be disabled and the desired quality will be played back.
  ///
  /// Limitations:
  /// * Not available on iOS
  Q? get targetQuality;

  /// The active quality of the media track, i.e. the quality that is currently being played.
  Q? get activeQuality;

  /// Set whether the track is enabled.
  ///
  /// Remarks:
  /// * Only one track of the same type (e.g. video) can be enabled at the same time.
  /// * Enabling a track will disable all other tracks of the same type.
  /// * Disabling a track will not enable a different track of the same type.
  set isEnabled(bool enabled);

  bool get isEnabled;
}

abstract class Qualities<Q extends Quality> extends ListBase<Q> implements EventDispatcher {
  List<Q> innerList = [];

  @override
  int get length => innerList.length;

  @override
  set length(int length) {
    innerList.length = length;
  }

  @override
  void operator []=(int index, Q value) {
    innerList[index] = value;
  }

  @override
  Q operator [](int index) => innerList[index];

  @override
  void add(Q value) => innerList.add(value);

  @override
  void addAll(Iterable<Q> all) => innerList.addAll(all);

  Q? firstWhereOrNull(bool Function(Q element) test, {Q Function()? orElse}) {
    int length = this.length;
    for (int i = 0; i < length; i++) {
      Q element = this[i];
      if (test(element)) return element;
      if (length != this.length) {
        throw ConcurrentModificationError(this);
      }
    }
    if (orElse != null) return orElse();
    return null;
  }
}

abstract class Quality implements EventDispatcher {
  final String _id;
  final int _uid;

  Quality(this._id, this._uid);

  String get id => _id;

  int get uid => _uid;

  String? get name;

  int get bandwidth;

  String? get codecs;
}
