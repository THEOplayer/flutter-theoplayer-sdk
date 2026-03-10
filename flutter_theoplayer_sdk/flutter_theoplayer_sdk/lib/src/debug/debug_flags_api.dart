import 'package:theoplayer_platform_interface/pigeon/apis.g.dart';

/// Represents a single debug flag with its metadata and current state.
class DebugFlag {
  final String key;
  final String description;
  final bool defaultValue;
  bool isEnabled;

  DebugFlag({
    required this.key,
    required this.description,
    required this.defaultValue,
    required this.isEnabled,
  });
}

/// Dart-side wrapper around the Pigeon-generated [THEOplayerNativeDebugFlagsAPI].
///
/// Provides a clean API to list, toggle, and reset debug flags at runtime.
/// Works on both iOS (via `DebugConfig`) and Android (via `Logger`).
class DebugFlagsAPI {
  THEOplayerNativeDebugFlagsAPI? _nativeAPI;

  /// Bind to the Pigeon API. Called internally during player setup.
  void setup(THEOplayerNativeDebugFlagsAPI? nativeAPI) {
    _nativeAPI = nativeAPI;
  }

  /// Fetch all available flags with their current state.
  Future<List<DebugFlag>> getAvailableFlags() async {
    final pigeonFlags = _nativeAPI?.getAvailableFlags();
    if (pigeonFlags == null) return [];
    final result = await pigeonFlags;
    return result.map((f) => DebugFlag(
      key: f.key,
      description: f.description,
      defaultValue: f.defaultValue,
      isEnabled: f.isEnabled,
    )).toList();
  }

  /// Enable a flag by key.
  Future<void> enableFlag(String key) async {
    await _nativeAPI?.enableFlag(key);
  }

  /// Disable a flag by key.
  Future<void> disableFlag(String key) async {
    await _nativeAPI?.disableFlag(key);
  }

  /// Enable all flags.
  Future<void> enableAll() async {
    await _nativeAPI?.enableAll();
  }

  /// Disable all flags.
  Future<void> disableAll() async {
    await _nativeAPI?.disableAll();
  }

  /// Reset all flags to their compile-time defaults.
  Future<void> resetAll() async {
    await _nativeAPI?.resetAll();
  }

  /// Enable OS log + file logging at runtime (iOS only, no-op on Android).
  Future<void> enableFileLogging() async {
    await _nativeAPI?.enableFileLogging();
  }

  void dispose() {
    _nativeAPI = null;
  }
}
