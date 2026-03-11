# Debug Flags (Experimental)

## Overview

**Note**: This is an experimental API. It may change in future releases.

THEOplayer exposes internal debug flags that control verbose logging for various subsystems of the player.
These flags can be toggled at runtime through the `player.debugFlags` API, making it easy to enable detailed logging for specific areas without recompiling.

A built-in UI panel is also provided so you can toggle flags interactively during development.

## Programmatic API

The debug flags API is available through `player.debugFlags`:

### Listing Available Flags

```dart
final flags = await player.debugFlags.getAvailableFlags();
for (final flag in flags) {
  print("${flag.key}: enabled=${flag.isEnabled} (default=${flag.defaultValue})");
  print("  ${flag.description}");
}
```

Each `DebugFlag` contains:

| Property       | Type   | Description                                  |
|----------------|--------|----------------------------------------------|
| `key`          | String | Unique identifier for the flag.              |
| `description`  | String | Human-readable description of what it logs.  |
| `defaultValue` | bool   | Compile-time default (usually `false`).      |
| `isEnabled`    | bool   | Current runtime state.                       |

### Toggling Individual Flags

```dart
// Enable a specific flag
await player.debugFlags.enableFlag("some_flag_key");

// Disable it
await player.debugFlags.disableFlag("some_flag_key");
```

### Bulk Operations

```dart
// Enable all flags
await player.debugFlags.enableAll();

// Disable all flags
await player.debugFlags.disableAll();

// Reset all flags to their compile-time defaults
await player.debugFlags.resetAll();
```

### File Logging (iOS only)

On iOS, you can enable file logging which writes debug output to a log file in addition to the console. This is a no-op on Android.

```dart
await player.debugFlags.enableFileLogging();
```

## Built-in Debug Panel

The SDK includes a ready-to-use `DebugFlagsPanel` widget that provides a full UI for managing debug flags, including search, individual toggles, and bulk actions.

### Showing the Panel

The simplest way is to use the convenience method on the player:

```dart
// Push the debug panel as a full-screen route
player.showDebugPanel(context);
```

Alternatively, you can use the panel widget or its static helper directly:

```dart
// Using the static helper
DebugFlagsPanelNavigation.show(context, player.debugFlags);

// Or embed it in your own layout
DebugFlagsPanel(api: player.debugFlags);
```

### Panel Features

- **Search** — filter flags by key or description
- **Toggle switches** — enable/disable individual flags
- **Status bar** — shows how many flags are currently enabled
- **Overflow menu** — Enable All, Disable All, Reset to Defaults, Enable File Logging (iOS)
- **Visual indicators** — overridden flags (different from default) are highlighted in bold

## Platform Differences

| Feature                 | Android                          | iOS                                       |
|-------------------------|----------------------------------|--------------------------------------------|
| Available flags         | Logger tags from the native SDK  | `DebugConfig.availableFlags` from THEOlive |
| Enable / Disable        | `Logger.enableTags` / `disableTags` | `DebugConfig.enable` / `disable`       |
| Reset                   | Disables all tags                | Resets to compile-time defaults            |
| File logging            | No-op                            | Writes to OS log + file via `DebugConfig`  |
