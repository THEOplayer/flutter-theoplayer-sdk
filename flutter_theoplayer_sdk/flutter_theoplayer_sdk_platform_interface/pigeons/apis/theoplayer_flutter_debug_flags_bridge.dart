import 'package:pigeon/pigeon.dart';

/// A single debug flag with its metadata and current state.
class DebugFlagPigeon {
  final String key;
  final String description;
  final bool defaultValue;
  final bool isEnabled;

  DebugFlagPigeon({
    required this.key,
    required this.description,
    required this.defaultValue,
    required this.isEnabled,
  });
}

/// Host API: Dart → Native calls for debug flag management.
@HostApi()
abstract class THEOplayerNativeDebugFlagsAPI {
  /// Returns all available debug flags with their current state.
  List<DebugFlagPigeon> getAvailableFlags();

  /// Enable a flag by key.
  void enableFlag(String key);

  /// Disable a flag by key.
  void disableFlag(String key);

  /// Enable all flags.
  void enableAll();

  /// Disable all flags.
  void disableAll();

  /// Reset all flags to their compile-time defaults.
  void resetAll();

  /// Enable OS log + file logging at runtime (iOS only, no-op on Android).
  void enableFileLogging();
}
