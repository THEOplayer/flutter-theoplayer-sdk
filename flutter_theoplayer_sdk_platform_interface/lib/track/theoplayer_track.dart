import 'dart:collection';

import 'package:flutter_theoplayer_sdk_platform_interface/theoplayer_event_dispatcher_interface.dart';

abstract class Tracks<T extends Track> extends ListBase<T> implements EventDispatcher {
  //TODO: fix this by making private. Now its used in theoplayer_tracklist_wrapper.dart
  List<T> innerList = [];

  @override
  int get length => innerList.length;

  @override
  set length(int length) {
    innerList.length = length;
  }

  @override
  void operator []=(int index, T value) {
    innerList[index] = value;
  }

  @override
  T operator [](int index) => innerList[index];

  @override
  void add(T value) => innerList.add(value);

  @override
  void addAll(Iterable<T> all) => innerList.addAll(all);

  T? firstWhereOrNull(bool Function(T element) test, {T Function()? orElse}) {
    int length = this.length;
    for (int i = 0; i < length; i++) {
      T element = this[i];
      if (test(element)) return element;
      if (length != this.length) {
        throw ConcurrentModificationError(this);
      }
    }
    if (orElse != null) return orElse();
    return null;
  }

}

abstract class Track implements EventDispatcher {
  final String? _id;
  final int _uid;
  final String? _label;
  final String? _language;
  final String? _kind;

  Track(this._id, this._uid, this._label, this._language, this._kind);

  /// The identifier of the media track.
  /// 
  /// Remarks:
  /// * This identifier can be used to distinguish between related tracks, e.g. tracks in the same list.
  String? get id => _id;

  /// A unique identifier of the media track.
  /// Remarks: 
  /// * This identifier is unique across tracks of a THEOplayer instance and can be used to distinguish between tracks.
  /// * This identifier is a randomly generated number.
  int get uid => _uid;

  /// The label of the media track.
  String? get label => _label;

  /// The language of the media track.
  String? get language => _language;

  /// The kind of the media track, represented by a value from the following list:
  /// * 'main': The track is the default track for playback
  /// * 'alternative': The track is not the default track for playback
  String? get kind => _kind;
}

