# Adaptive Bitrate (ABR)

## Overview

The playback quality during play-out of a THEOlive stream is determined by the ABR algorithm.
On starting play-out, the ABR **strategy** determines which quality to prefer, while during play-out the network's bandwidth is monitored to select an optimal quality.

More information on ABR can be found on the
[THEOplayer website](https://www.theoplayer.com/blog/abr-bandwidth-usage)
and [demo page](https://www.theoplayer.com/theoplayer-demo-optimized-video-abr).

## ABR Configuration

The ABR configuration is accessible through `player.abr`. It allows you to control the ABR strategy, target buffer, and preferred peak bitrate.

### Setting the ABR Strategy

The strategy determines which quality the player initially selects when starting playback:

| Strategy      | Description                                                                 |
|---------------|-----------------------------------------------------------------------------|
| `performance` | Prefer the **lowest** quality for faster startup and lower bandwidth usage. |
| `quality`     | Prefer the **highest** quality for the best visual experience.              |
| `bandwidth`   | Estimate available bandwidth and select the best matching quality.          |

The default strategy is **bandwidth**.

```dart
// Set the ABR strategy to "quality" (prefer highest quality)
player.abr.setStrategy(
  AbrStrategyConfiguration(type: AbrStrategyType.quality),
);

// Set the ABR strategy to "performance" (prefer lowest quality)
player.abr.setStrategy(
  AbrStrategyConfiguration(type: AbrStrategyType.performance),
);

// Read the current strategy
final config = await player.abr.strategy;
print("Current ABR strategy: ${config.type}");
```

### Setting an Initial Bitrate Cap

You can pass optional `metadata` with a `bitrate` value (in bits per second) to cap the initial quality selection:

```dart
player.abr.setStrategy(
  AbrStrategyConfiguration(
    type: AbrStrategyType.bandwidth,
    metadata: AbrStrategyMetadata(bitrate: 1200000), // 1.2 Mbps
  ),
);
```

This is useful when you have an estimate of the user's available bandwidth and want to avoid buffering on startup.

### Target Buffer

The target buffer controls how many seconds of video the player should buffer ahead of the current playback position. This only applies to HLS (non-THEOlive) streams.

```dart
// Get the current target buffer (default: 20 seconds)
final buffer = await player.abr.targetBuffer;

// Set the target buffer to 10 seconds
player.abr.setTargetBuffer(10.0);
```

### Preferred Peak Bitrate (iOS only)

On iOS you can set the desired limit for network bandwidth consumption. This only applies to HLS (non-THEOlive) streams and is a no-op on other platforms.

```dart
// Cap bandwidth to 2 Mbps
player.abr.setPreferredPeakBitRate(2000000);

// Remove the cap (default: 0 = no limit)
player.abr.setPreferredPeakBitRate(0);
```

## Setting Target Video Quality

By default, the ABR algorithm will choose from all the video qualities available in the stream.
You can pin the player to a specific quality or a subset of qualities using the `targetQuality` / `targetQualities` properties on a video track:

```dart
final videoTrack = player.videoTracks.first;

// Pin to a single quality (disables ABR)
videoTrack.targetQuality = videoTrack.qualities.first;

// Pin to a subset of qualities (ABR selects among these)
videoTrack.targetQualities = [
  videoTrack.qualities[0],
  videoTrack.qualities[1],
];

// Reset to automatic (let ABR choose freely)
videoTrack.targetQuality = null;
```

## Subscribing to Quality Change Events

You can listen for quality changes on video and audio tracks:

```dart
// Listen for new video tracks
player.videoTracks.addEventListener(VideoTracksEventTypes.ADDTRACK, (event) {
  final track = (event as AddVideoTrackEvent).track;
  print("Video track added: ${track.uid}");

  // Print all available qualities
  for (final quality in track.qualities) {
    print("  quality: ${quality.width}x${quality.height}, "
        "bandwidth: ${quality.bandwidth}");
  }

  // Listen for active quality changes on this track
  track.addEventListener(
    VideoTrackEventTypes.ACTIVEQUALITYCHANGED,
    (event) {
      final q = (event as VideoActiveQualityChangedEvent).quality;
      print("Active quality changed: ${q.width}x${q.height}, "
          "bandwidth: ${q.bandwidth}");
    },
  );
});
```

## Supported Platforms

| Property              | Android | iOS | Web |
|-----------------------|---------|-----|-----|
| `strategy`            | ✅       | ✅   | ✅   |
| `targetBuffer`        | ✅       | ✅   | ✅   |
| `preferredPeakBitRate`| ❌       | ✅   | ❌   |
| `targetQuality`       | ✅       | ✅   | ✅   |
| Quality change events | ✅       | ✅   | ✅   |

**Notes**:
On **iOS**, the ABR strategy configuration only affects **THEOlive** (HESP) streams. For other stream types, the player uses the platform-native ABR algorithm that cannot be configured through this API.

On **Android** and **Web**, the ABR strategy is applied to all adaptive streams.

