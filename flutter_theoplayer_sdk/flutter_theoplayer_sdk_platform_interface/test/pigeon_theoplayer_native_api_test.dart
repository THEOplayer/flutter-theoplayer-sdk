import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theoplayer_platform_interface/pigeon/apis.g.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('THEOplayerNativeAPI Tests', () {
    late THEOplayerNativeAPI api;
    final List<String> registeredChannels = [];

    setUp(() {
      api = THEOplayerNativeAPI();
    });

    tearDown(() {
      // Clean up all registered channels
      for (final channel in registeredChannels) {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMessageHandler(channel, null);
      }
      registeredChannels.clear();
    });

    void registerMockHandler(String channelName, Future<ByteData?> Function(ByteData?) handler) {
      registeredChannels.add(channelName);
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler(channelName, handler);
    }

    test('setSource - sends source to native platform', () async {
      // Mock handler for setSource method call
      registerMockHandler(
        'dev.flutter.pigeon.theoplayer_platform_interface.THEOplayerNativeAPI.setSource',
        (ByteData? message) async {
          if (message != null) {
            final decoded = THEOplayerNativeAPI.codec.decodeMessage(message);
            if (decoded is List && decoded.length == 1) {
              final source = decoded[0] as SourceDescription?;
              expect(source, isNotNull);
              expect(source!.sources.length, 1);
              expect(source.sources[0]!.src, 'https://example.com/video.m3u8');
              // Return success (empty response)
              return THEOplayerNativeAPI.codec.encodeMessage(<Object?>[]);
            }
          }
          return null;
        },
      );

      final source = SourceDescription(sources: [
        PigeonTypedSource(
          src: 'https://example.com/video.m3u8',
          type: 'application/x-mpegurl',
        ),
      ]);

      await api.setSource(source);
    });

    test('getSource - retrieves source from native platform', () async {
      final expectedSource = SourceDescription(sources: [
        PigeonTypedSource(
          src: 'https://example.com/video.m3u8',
          type: 'application/x-mpegurl',
        ),
      ]);

      registerMockHandler(
        'dev.flutter.pigeon.theoplayer_platform_interface.THEOplayerNativeAPI.getSource',
        (ByteData? message) async {
          // Return the source
          return THEOplayerNativeAPI.codec.encodeMessage(<Object?>[expectedSource]);
        },
      );

      final result = await api.getSource();
      expect(result, isNotNull);
      expect(result!.sources.length, 1);
      expect(result.sources[0]!.src, 'https://example.com/video.m3u8');
    });

    test('setAutoplay - sets autoplay to true', () async {
      bool? receivedValue;

      registerMockHandler(
        'dev.flutter.pigeon.theoplayer_platform_interface.THEOplayerNativeAPI.setAutoplay',
        (ByteData? message) async {
          if (message != null) {
            final decoded = THEOplayerNativeAPI.codec.decodeMessage(message);
            if (decoded is List && decoded.length == 1) {
              receivedValue = decoded[0] as bool?;
              return THEOplayerNativeAPI.codec.encodeMessage(<Object?>[]);
            }
          }
          return null;
        },
      );

      await api.setAutoplay(true);
      expect(receivedValue, true);
    });

    test('isAutoplay - retrieves autoplay state', () async {
      registerMockHandler(
        'dev.flutter.pigeon.theoplayer_platform_interface.THEOplayerNativeAPI.isAutoplay',
        (ByteData? message) async {
          // Return autoplay = true
          return THEOplayerNativeAPI.codec.encodeMessage(<Object?>[true]);
        },
      );

      final result = await api.isAutoplay();
      expect(result, true);
    });

    test('play - calls play method', () async {
      bool playCalled = false;

      registerMockHandler(
        'dev.flutter.pigeon.theoplayer_platform_interface.THEOplayerNativeAPI.play',
        (ByteData? message) async {
          playCalled = true;
          return THEOplayerNativeAPI.codec.encodeMessage(<Object?>[]);
        },
      );

      await api.play();
      expect(playCalled, true);
    });

    test('pause - calls pause method', () async {
      bool pauseCalled = false;

      registerMockHandler(
        'dev.flutter.pigeon.theoplayer_platform_interface.THEOplayerNativeAPI.pause',
        (ByteData? message) async {
          pauseCalled = true;
          return THEOplayerNativeAPI.codec.encodeMessage(<Object?>[]);
        },
      );

      await api.pause();
      expect(pauseCalled, true);
    });

    test('isPaused - retrieves paused state', () async {
      registerMockHandler(
        'dev.flutter.pigeon.theoplayer_platform_interface.THEOplayerNativeAPI.isPaused',
        (ByteData? message) async {
          return THEOplayerNativeAPI.codec.encodeMessage(<Object?>[true]);
        },
      );

      final result = await api.isPaused();
      expect(result, true);
    });

    test('getCurrentTime - retrieves current time', () async {
      registerMockHandler(
        'dev.flutter.pigeon.theoplayer_platform_interface.THEOplayerNativeAPI.getCurrentTime',
        (ByteData? message) async {
          return THEOplayerNativeAPI.codec.encodeMessage(<Object?>[42.5]);
        },
      );

      final result = await api.getCurrentTime();
      expect(result, 42.5);
    });

    test('setCurrentTime - sets current time (seeking)', () async {
      double? receivedTime;

      registerMockHandler(
        'dev.flutter.pigeon.theoplayer_platform_interface.THEOplayerNativeAPI.setCurrentTime',
        (ByteData? message) async {
          if (message != null) {
            final decoded = THEOplayerNativeAPI.codec.decodeMessage(message);
            if (decoded is List && decoded.length == 1) {
              receivedTime = decoded[0] as double?;
              return THEOplayerNativeAPI.codec.encodeMessage(<Object?>[]);
            }
          }
          return null;
        },
      );

      await api.setCurrentTime(30.0);
      expect(receivedTime, 30.0);
    });
  });

  group('THEOplayerFlutterAPI Tests', () {
    test('onPlay callback - receives play event from native', () async {
      bool onPlayCalled = false;
      double? receivedTime;

      // Create a mock implementation
      final mockAPI = _MockTHEOplayerFlutterAPI(
        onPlayCallback: (time) {
          onPlayCalled = true;
          receivedTime = time;
        },
      );

      // Setup the Flutter API
      THEOplayerFlutterAPI.setup(mockAPI);

      // Simulate native calling the onPlay method
      final codec = THEOplayerFlutterAPI.codec;
      final message = codec.encodeMessage(<Object?>[15.5]);

      await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .handlePlatformMessage(
        'dev.flutter.pigeon.theoplayer_platform_interface.THEOplayerFlutterAPI.onPlay',
        message,
        (ByteData? reply) {
          expect(reply, isNotNull);
        },
      );

      expect(onPlayCalled, true);
      expect(receivedTime, 15.5);

      // Cleanup
      THEOplayerFlutterAPI.setup(null);
    });

    test('onPause callback - receives pause event from native', () async {
      bool onPauseCalled = false;
      double? receivedTime;

      final mockAPI = _MockTHEOplayerFlutterAPI(
        onPauseCallback: (time) {
          onPauseCalled = true;
          receivedTime = time;
        },
      );

      THEOplayerFlutterAPI.setup(mockAPI);

      final codec = THEOplayerFlutterAPI.codec;
      final message = codec.encodeMessage(<Object?>[25.0]);

      await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .handlePlatformMessage(
        'dev.flutter.pigeon.theoplayer_platform_interface.THEOplayerFlutterAPI.onPause',
        message,
        (ByteData? reply) {
          expect(reply, isNotNull);
        },
      );

      expect(onPauseCalled, true);
      expect(receivedTime, 25.0);

      THEOplayerFlutterAPI.setup(null);
    });

    test('onSourceChange callback - receives source change from native',
        () async {
      bool onSourceChangeCalled = false;
      SourceDescription? receivedSource;

      final mockAPI = _MockTHEOplayerFlutterAPI(
        onSourceChangeCallback: (source) {
          onSourceChangeCalled = true;
          receivedSource = source;
        },
      );

      THEOplayerFlutterAPI.setup(mockAPI);

      final testSource = SourceDescription(sources: [
        PigeonTypedSource(
          src: 'https://example.com/new-video.m3u8',
          type: 'application/x-mpegurl',
        ),
      ]);

      final codec = THEOplayerFlutterAPI.codec;
      final message = codec.encodeMessage(<Object?>[testSource]);

      await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .handlePlatformMessage(
        'dev.flutter.pigeon.theoplayer_platform_interface.THEOplayerFlutterAPI.onSourceChange',
        message,
        (ByteData? reply) {
          expect(reply, isNotNull);
        },
      );

      expect(onSourceChangeCalled, true);
      expect(receivedSource, isNotNull);
      expect(receivedSource!.sources[0]!.src,
          'https://example.com/new-video.m3u8');

      THEOplayerFlutterAPI.setup(null);
    });

    test('onError callback - receives error from native', () async {
      bool onErrorCalled = false;
      String? receivedError;

      final mockAPI = _MockTHEOplayerFlutterAPI(
        onErrorCallback: (error) {
          onErrorCalled = true;
          receivedError = error;
        },
      );

      THEOplayerFlutterAPI.setup(mockAPI);

      final codec = THEOplayerFlutterAPI.codec;
      final message = codec.encodeMessage(<Object?>['Network error occurred']);

      await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .handlePlatformMessage(
        'dev.flutter.pigeon.theoplayer_platform_interface.THEOplayerFlutterAPI.onError',
        message,
        (ByteData? reply) {
          expect(reply, isNotNull);
        },
      );

      expect(onErrorCalled, true);
      expect(receivedError, 'Network error occurred');

      THEOplayerFlutterAPI.setup(null);
    });
  });

  group('Error Handling Tests', () {
    late THEOplayerNativeAPI api;
    final List<String> registeredChannels = [];

    setUp(() {
      api = THEOplayerNativeAPI();
    });

    tearDown() {
      // Clean up all registered channels
      for (final channel in registeredChannels) {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMessageHandler(channel, null);
      }
      registeredChannels.clear();
    }

    void registerMockHandler(String channelName, Future<ByteData?> Function(ByteData?) handler) {
      registeredChannels.add(channelName);
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler(channelName, handler);
    }

    test('setSource - handles null source', () async {
      registerMockHandler(
        'dev.flutter.pigeon.theoplayer_platform_interface.THEOplayerNativeAPI.setSource',
        (ByteData? message) async {
          return THEOplayerNativeAPI.codec.encodeMessage(<Object?>[]);
        },
      );

      // Should not throw
      await api.setSource(null);
    });

    test('API call - propagates platform exception', () async {
      registerMockHandler(
        'dev.flutter.pigeon.theoplayer_platform_interface.THEOplayerNativeAPI.play',
        (ByteData? message) async {
          // Return error response
          return THEOplayerNativeAPI.codec.encodeMessage(<Object?>['ERROR_CODE', 'Error message', null]);
        },
      );

      expect(
        () async => await api.play(),
        throwsA(isA<PlatformException>()),
      );
    });

    test('API call - handles channel error', () async {
      registerMockHandler(
        'dev.flutter.pigeon.theoplayer_platform_interface.THEOplayerNativeAPI.play',
        (ByteData? message) async {
          // Return null to simulate channel error
          return null;
        },
      );

      expect(
        () async => await api.play(),
        throwsA(isA<PlatformException>().having(
          (e) => e.code,
          'code',
          'channel-error',
        )),
      );
    });
  });
}

// Mock implementation of THEOplayerFlutterAPI for testing callbacks
class _MockTHEOplayerFlutterAPI extends THEOplayerFlutterAPI {
  final void Function(double currentTime)? onPlayCallback;
  final void Function(double currentTime)? onPauseCallback;
  final void Function(SourceDescription? source)? onSourceChangeCallback;
  final void Function(String error)? onErrorCallback;

  _MockTHEOplayerFlutterAPI({
    this.onPlayCallback,
    this.onPauseCallback,
    this.onSourceChangeCallback,
    this.onErrorCallback,
  });

  @override
  void onPlay(double currentTime) {
    onPlayCallback?.call(currentTime);
  }

  @override
  void onPause(double currentTime) {
    onPauseCallback?.call(currentTime);
  }

  @override
  void onSourceChange(SourceDescription? source) {
    onSourceChangeCallback?.call(source);
  }

  @override
  void onError(String error) {
    onErrorCallback?.call(error);
  }

  // Stub implementations for other required methods
  @override
  void onPlaying(double currentTime) {}

  @override
  void onWaiting(double currentTime) {}

  @override
  void onDurationChange(double duration) {}

  @override
  void onProgress(double currentTime) {}

  @override
  void onTimeUpdate(double currentTime, int? currentProgramDateTime) {}

  @override
  void onRateChange(double currentTime, double playbackRate) {}

  @override
  void onSeeking(double currentTime) {}

  @override
  void onSeeked(double currentTime) {}

  @override
  void onVolumeChange(double currentTime, double volume) {}

  @override
  void onResize(double currentTime, int width, int height) {}

  @override
  void onEnded(double currentTime) {}

  @override
  void onDestroy() {}

  @override
  void onReadyStateChange(double currentTime, ReadyState readyState) {}

  @override
  void onLoadStart() {}

  @override
  void onLoadedMetadata(double currentTime) {}

  @override
  void onLoadedData(double currentTime) {}

  @override
  void onCanPlay(double currentTime) {}

  @override
  void onCanPlayThrough(double currentTime) {}
}
