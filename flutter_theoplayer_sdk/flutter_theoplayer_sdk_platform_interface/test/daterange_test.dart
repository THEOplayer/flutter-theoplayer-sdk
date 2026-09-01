import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:theoplayer_platform_interface/pigeon/apis.g.dart';
import 'package:theoplayer_platform_interface/theopalyer_config.dart';
import 'package:theoplayer_platform_interface/api/source.dart';
import 'package:theoplayer_platform_interface/track/texttrack/theoplayer_texttrack_impl.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('hlsDateRange configuration', () {
    test('TypedSource carries hlsDateRange', () {
      expect(TypedSource(src: 'https://example.com/video.m3u8', hlsDateRange: true).hlsDateRange, isTrue);
      expect(TypedSource(src: 'https://example.com/video.m3u8').hlsDateRange, isNull);
    });

    test('TypedSourcePigeon codec roundtrip preserves hlsDateRange', () {
      final source = TypedSource(src: 'https://example.com/video.m3u8', hlsDateRange: true);
      final encoded = THEOplayerNativeAPI.pigeonChannelCodec.encodeMessage(<Object?>[source]);
      final decoded = THEOplayerNativeAPI.pigeonChannelCodec.decodeMessage(encoded) as List<Object?>;
      expect((decoded[0] as TypedSourcePigeon).hlsDateRange, isTrue);
    });

    test('THEOplayerConfig exposes hlsDateRange and serializes it', () {
      final config = THEOplayerConfig(hlsDateRange: true);
      expect(config.hlsDateRange, isTrue);
      expect(config.toJson()['hlsDateRange'], isTrue);

      final defaultConfig = THEOplayerConfig();
      expect(defaultConfig.hlsDateRange, isNull);
      expect(defaultConfig.toJson().containsKey('hlsDateRange'), isTrue);
      expect(defaultConfig.toJson()['hlsDateRange'], isNull);
    });
  });

  group('DateRangeCue', () {
    test('DateRangeCueImpl exposes SCTE-35 payloads and daterange attributes', () {
      final scte35Cmd = Uint8List.fromList([1, 2, 3]);
      final scte35Out = Uint8List.fromList([4, 5]);
      final scte35In = Uint8List.fromList([6]);
      final startDate = DateTime.fromMillisecondsSinceEpoch(1000);
      final endDate = DateTime.fromMillisecondsSinceEpoch(6000);

      final cue = DateRangeCueImpl('id-1', 42, 0.0, 5.0, startDate, endDate, 5.0, 5.0, 'ad-break', false, {'X-CUSTOM': 'value'}, scte35Cmd, scte35Out, scte35In);

      expect(cue.scte35Cmd, scte35Cmd);
      expect(cue.scte35Out, scte35Out);
      expect(cue.scte35In, scte35In);
      expect(cue.startDate, startDate);
      expect(cue.endDate, endDate);
      expect(cue.customAttributes, {'X-CUSTOM': 'value'});
    });

    test('open-ended daterange keeps endTime infinity and null SCTE-35 payloads', () {
      final cue = DateRangeCueImpl('id-2', 43, 0.0, double.infinity, DateTime.fromMillisecondsSinceEpoch(1000), null, null, null, null, true, null, null, null, null);

      expect(cue.endTime, double.infinity);
      expect(cue.endDate, isNull);
      expect(cue.scte35Cmd, isNull);
      expect(cue.scte35Out, isNull);
      expect(cue.scte35In, isNull);
    });
  });
}
