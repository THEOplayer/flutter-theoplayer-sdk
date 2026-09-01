import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';

import 'package:theoplayer_platform_interface/track/texttrack/theoplayer_texttrack_events.dart';
import 'package:theoplayer_platform_interface/track/texttrack/theoplayer_texttrack_impl.dart';
import 'package:theoplayer_web/theoplayer_api_event_web.dart';
import 'package:theoplayer_web/theoplayer_api_web.dart';

@JS('Object.keys')
external JSArray<JSString> _objectKeys(JSObject obj);

class DateRangeCueImplWeb extends DateRangeCueImpl {
  final THEOplayerDateRangeCue _nativeDateRangeCue;

  late final enterEventListener;
  late final exitEventListener;

  DateRangeCueImplWeb(super.id, super.uid, super.startTime, super.endTime, super.startDate, super.endDate, super.duration, super.plannedDuration, super.cueClass, super.endOnNext,
      super.customAttributes, super.scte35Cmd, super.scte35Out, super.scte35In, this._nativeDateRangeCue) {
    enterEventListener = (CueEnterEventJS event) {
      dispatchEvent(CueEnterEvent(cue: this));
    }.toJS;

    exitEventListener = (CueExitEventJS event) {
      dispatchEvent(CueExitEvent(cue: this));
    }.toJS;

    _nativeDateRangeCue.addEventListener(TextTrackCueEventTypes.ENTER.toLowerCase(), enterEventListener);
    _nativeDateRangeCue.addEventListener(TextTrackCueEventTypes.EXIT.toLowerCase(), exitEventListener);
  }

  void dispose() {
    super.dispose();
    _nativeDateRangeCue.removeEventListener(TextTrackCueEventTypes.ENTER.toLowerCase(), enterEventListener);
    _nativeDateRangeCue.removeEventListener(TextTrackCueEventTypes.EXIT.toLowerCase(), exitEventListener);
  }

  static DateRangeCueImplWeb fromNativeCue(THEOplayerDateRangeCue cue) {
    return DateRangeCueImplWeb(
      cue.id,
      cue.uid,
      cue.startTime,
      cue.endTime,
      DateTime.fromMillisecondsSinceEpoch(cue.startDate.getTime()),
      cue.endDate != null ? DateTime.fromMillisecondsSinceEpoch(cue.endDate!.getTime()) : null,
      cue.duration,
      cue.plannedDuration,
      cue.cueClass,
      cue.endOnNext,
      _toCustomAttributesMap(cue.customAttributes),
      _toUint8List(cue.scte35Cmd),
      _toUint8List(cue.scte35Out),
      _toUint8List(cue.scte35In),
      cue,
    );
  }

  static Uint8List? _toUint8List(JSArrayBuffer? buffer) {
    return buffer?.toDart.asUint8List();
  }

  /// Converts the JS custom attributes record to a Dart map.
  /// String and number values are kept as-is, ArrayBuffer values are base64-encoded strings.
  static Map<String, dynamic>? _toCustomAttributesMap(JSObject customAttributes) {
    final map = <String, dynamic>{};
    final keys = _objectKeys(customAttributes).toDart;
    for (final key in keys) {
      final value = customAttributes.getProperty(key);
      if (value.isA<JSString>()) {
        map[key.toDart] = (value as JSString).toDart;
      } else if (value.isA<JSNumber>()) {
        map[key.toDart] = (value as JSNumber).toDartDouble;
      } else if (value.isA<JSArrayBuffer>()) {
        map[key.toDart] = base64Encode((value as JSArrayBuffer).toDart.asUint8List());
      } else if (value != null) {
        map[key.toDart] = value.toString();
      }
    }
    return map;
  }
}
