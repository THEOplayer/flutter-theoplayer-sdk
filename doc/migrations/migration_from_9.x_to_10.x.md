# Migration Guide: From THEOplayer Flutter SDK 9.x to 10.x

This guide covers the breaking changes introduced when renaming "publication"-related APIs to "distribution" for consistency and clarity.

## Overview

The THEOplayer Flutter SDK has renamed all "publication"-related APIs to use "distribution" terminology instead. This change affects state management, event types, and property names.

## Breaking Changes

### 1. State Enum Renamed

**Before:**
```dart
enum PublicationState { idle, loading, loaded, intentToFallback, offline }
```

**After:**
```dart
enum DistributionState { idle, loading, loaded, intentToFallback, offline }
```

### 2. State Property Renamed

**Before:**
```dart
PublicationState state = player.theoLive?.publicationState;
```

**After:**
```dart
DistributionState state = player.theoLive?.distributionState;
```

### 3. Event Types Updated

**Before:**
```dart
player.theoLive?.addEventListener(THEOliveApiEventTypes.PUBLICATIONLOADSTART, (e) {
    print("Publication load started");
});

player.theoLive?.addEventListener(THEOliveApiEventTypes.PUBLICATIONLOADED, (e) {
    print("Publication loaded");
});

player.theoLive?.addEventListener(THEOliveApiEventTypes.PUBLICATIONOFFLINE, (e) {
    print("Publication offline");
});
```

**After:**
```dart
player.theoLive?.addEventListener(THEOliveApiEventTypes.DISTRIBUTIONLOADSTART, (e) {
    print("Distribution load started");
});

player.theoLive?.addEventListener(THEOliveApiEventTypes.ENDPOINTLOADED, (e) {
    print("Endpoint loaded");
});

player.theoLive?.addEventListener(THEOliveApiEventTypes.DISTRIBUTIONOFFLINE, (e) {
    print("Distribution offline");
});
```

### 4. Event Class Renamed

**Before:**
```dart
// In custom event handling code
if (event is PublicationLoadedEvent) {
    print("Publication loaded.");
}

if (event is PublicationLoadStartEvent) {
    print("Publication load started.");
}

if (event is PublicationOfflineEvent) {
    print("Publication offline.");
}
```

**After:**
```dart
// In custom event handling code
if (event is EndpointLoadedEvent) {
    print("Endpoint loaded.");
}

if (event is DistributionLoadStartEvent) {
    print("Distribution load started.");
}

if (event is DistributionOfflineEvent) {
    print("Distribution load started.");
}
```

### 5. Android Source Configuration Simplified

**Before:**
```dart
import 'package:theoplayer/theoplayer.dart';

// PlaybackPipeline enum and configuration
enum PlaybackPipeline { media3, legacy }

AndroidTypedSourceConfiguration config = AndroidTypedSourceConfiguration(
    playbackPipeline: PlaybackPipeline.media3
);

TypedSource source = TypedSource(
    src: "https://example.com/stream.m3u8",
    androidSourceConfiguration: config
);
```

**After:**
```dart
import 'package:theoplayer/theoplayer.dart';

// PlaybackPipeline enum removed - Media3 is now the default
AndroidTypedSourceConfiguration config = AndroidTypedSourceConfiguration();

TypedSource source = TypedSource(
    src: "https://example.com/stream.m3u8",
    androidSourceConfiguration: config
);
```

## Migration Steps

### Step 1: Update Import Statements
No changes needed - all imports remain the same.

### Step 2: Update State References

Replace all instances of:
- `PublicationState` → `DistributionState`
- `publicationState` → `distributionState`

**Example:**
```dart
// Before
void handleStateChange() {
  PublicationState currentState = player.theoLive?.publicationState;
  if (currentState == PublicationState.loaded) {
    // Handle loaded state
  }
}

// After
void handleStateChange() {
  DistributionState currentState = player.theoLive?.distributionState;
  if (currentState == DistributionState.loaded) {
    // Handle loaded state
  }
}
```

### Step 3: Update Event Listeners

Replace event type constants:
- `THEOliveApiEventTypes.PUBLICATIONLOADSTART` → `THEOliveApiEventTypes.DISTRIBUTIONLOADSTART`
- `THEOliveApiEventTypes.PUBLICATIONLOADED` → `THEOliveApiEventTypes.ENDPOINTLOADED`
- `THEOliveApiEventTypes.PUBLICATIONOFFLINE` → `THEOliveApiEventTypes.DISTRIBUTIONOFFLINE`

**Example:**
```dart
// Before
void setupEventListeners() {
  player.theoLive?.addEventListener(THEOliveApiEventTypes.PUBLICATIONLOADSTART, (e) {
    print("Starting to load publication");
  });

  player.theoLive?.addEventListener(THEOliveApiEventTypes.PUBLICATIONLOADED, (e) {
    print("Publication has loaded");
  });

  player.theoLive?.addEventListener(THEOliveApiEventTypes.PUBLICATIONOFFLINE, (e) {
    print("Publication went offline");
  });
}

// After
void setupEventListeners() {
  player.theoLive?.addEventListener(THEOliveApiEventTypes.DISTRIBUTIONLOADSTART, (e) {
    print("Starting to load distribution");
  });

  player.theoLive?.addEventListener(THEOliveApiEventTypes.ENDPOINTLOADED, (e) {
    print("Endpoint has loaded");
  });

  player.theoLive?.addEventListener(THEOliveApiEventTypes.DISTRIBUTIONOFFLINE, (e) {
    print("Distribution went offline");
  });
}
```

### Step 4: Update Event Class References

If you have custom event handling code that checks event types:

**Before:**
```dart
void handleEvent(Event event) {
    if (event is PublicationLoadedEvent) {
        print("Publication has loaded.");
    }
    ...
    
    if (event is PublicationLoadStartEvent) {
        print("Publication loading started.");
    }
    ...
    
    if (event is PublicationOfflineEvent) {
        print("Publication went offline.");
    }
}
```

**After:**
```dart
void handleEvent(Event event) {
    if (event is EndpointLoadedEvent) {
        print("Endpoint has loaded.");
    }
    ...
    
    if (event is DistributionLoadStartEvent) {
        print("Distribution loading started.");
    }
    ...
    
    if (event is DistributionOfflineEvent) {
        print("Distribution went offline.");
    }
}
```

### Step 5: Update Integration Tests

If you have integration tests that check publication state:

**Before:**
```dart
expect(player.theoLive?.publicationState == PublicationState.loaded, isTrue);
```

**After:**
```dart
expect(player.theoLive?.distributionState == DistributionState.loaded, isTrue);
```

### Step 6: Update Android Source Configuration

Remove PlaybackPipeline configurations from Android sources:

**Before:**
```dart
AndroidTypedSourceConfiguration config = AndroidTypedSourceConfiguration(
    playbackPipeline: PlaybackPipeline.media3
);
```

**After:**
```dart
AndroidTypedSourceConfiguration config = AndroidTypedSourceConfiguration();
```

### Step 7: Update Event Parameter Access

Change event parameter names in custom event handlers:

**Before:**
```dart
void onDistributionEvent(DistributionLoadStartEvent event) {
    String id = event.publicationId;  // Old parameter name
}
```

**After:**
```dart
void onDistributionEvent(DistributionLoadStartEvent event) {
    String id = event.distributionId;  // New parameter name
}
```

## Automated Migration

You can use find-and-replace in your IDE to automate most of the migration:

1. **Find:** `PublicationState` **Replace:** `DistributionState`
2. **Find:** `publicationState` **Replace:** `distributionState`
3. **Find:** `PUBLICATIONLOADSTART` **Replace:** `DISTRIBUTIONLOADSTART`
4. **Find:** `PUBLICATIONLOADED` **Replace:** `ENDPOINTLOADED`
5. **Find:** `PUBLICATIONOFFLINE` **Replace:** `DISTRIBUTIONOFFLINE`
6. **Find:** `PublicationLoadedEvent` **Replace:** `EndpointLoadedEvent`
7. **Find:** `PublicationLoadStartEvent` **Replace:** `DistributionLoadStartEvent`
8. **Find:** `PublicationOfflineEvent` **Replace:** `DistributionOfflineEvent`
9. **Find:** `event.publicationId` **Replace:** `event.distributionId`
10. **Find:** `PlaybackPipeline.media3` **Replace:** _(remove - no longer needed)_
11. **Find:** `PlaybackPipeline.legacy` **Replace:** _(remove - no longer supported)_
12. **Find:** `playbackPipeline: PlaybackPipeline.` **Replace:** _(remove entire parameter)_

## What Remains Unchanged

- All other THEOlive APIs
- Event listener registration/removal methods
- Source configuration (`TheoLiveSource`)
- Player initialization and setup

## Rationale

These changes were made to:
- **Align with THEOplayer 10.0.0**: Update to the latest native SDK with improved APIs
- **Consistent terminology**: Match THEOplayer's native SDK distribution/endpoint terminology
- **Simplified configuration**: Remove deprecated PlaybackPipeline options (Media3 is now the standard)
- **Clearer parameter names**: `distributionId` better represents the actual data than `publicationId`
- **Improved developer experience**: More intuitive and predictable API surface

## Need Help?

If you encounter issues during migration or have questions about the new API, please:
1. Check the updated documentation in `doc/theolive.md`
2. Review the example app for working code samples
3. Open an issue in the repository with specific migration questions