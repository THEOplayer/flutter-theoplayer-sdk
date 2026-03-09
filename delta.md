# Track & Quality API Delta: React Native vs Flutter THEOplayer SDK

## 1. Player-Level Track Access

| Feature | React Native | Flutter | Delta |
|---------|-------------|---------|-------|
| Audio tracks | `player.audioTracks: MediaTrack[]` | `player.audioTracks: AudioTracks` | Equivalent (different collection types) |
| Video tracks | `player.videoTracks: MediaTrack[]` | `player.videoTracks: VideoTracks` | Equivalent |
| Text tracks | `player.textTracks: TextTrack[]` | `player.textTracks: TextTracks` | Equivalent |
| Selected audio track | `player.selectedAudioTrack: number \| undefined` (uid) | N/A — use `track.isEnabled` | **RN has convenience property; Flutter uses per-track enable/disable** |
| Selected video track | `player.selectedVideoTrack: number \| undefined` (uid) | N/A — use `track.isEnabled` | **Same as above** |
| Selected text track | `player.selectedTextTrack: number \| undefined` (uid) | N/A — use `track.setMode()` | **Same as above** |
| Target video quality | `player.targetVideoQuality: number \| number[] \| undefined` (uid(s)) | `videoTrack.targetQuality` / `videoTrack.targetQualities` | **RN sets at player level by uid; Flutter sets on the track object directly** |
| Text track style | `player.textTrackStyle: TextTrackStyle` | **Not available** | **Missing in Flutter** |

## 2. Base Track Properties

| Property | React Native | Flutter | Delta |
|----------|-------------|---------|-------|
| `id` | `readonly id: string` | `String? id` | Flutter allows null |
| `uid` | `readonly uid: number` | `int uid` | Equivalent |
| `kind` | `readonly kind: string` | `String? kind` | Flutter allows null |
| `label` | `label: string` (mutable) | `String? label` (read-only) | **RN label is mutable; Flutter is read-only and nullable** |
| `language` | `readonly language: string` | `String? language` | Flutter allows null |
| `unlocalizedLabel` | `readonly unlocalizedLabel?: string` | `String? unlocalizedLabel` | Equivalent |

## 3. MediaTrack (Audio/Video) Properties

| Property | React Native | Flutter | Delta |
|----------|-------------|---------|-------|
| `enabled` | `readonly enabled: boolean` | `bool isEnabled` (get/set) | **Flutter allows setting enabled; RN is read-only (uses selectedAudioTrack/selectedVideoTrack)** |
| `qualities` | `readonly qualities: Quality[]` | `Qualities qualities` (typed collection) | Equivalent |
| `activeQuality` | `readonly activeQuality: Quality \| undefined` | `Quality? activeQuality` | Equivalent |
| `targetQuality` | N/A (set at player level) | `Quality? targetQuality` (get/set) | **Flutter has per-track target quality setter** |
| `targetQualities` | N/A (set at player level) | `List<Quality>? targetQualities` (get/set) | **Flutter has per-track target qualities setter** |

## 4. Quality Properties

| Property | React Native | Flutter | Delta |
|----------|-------------|---------|-------|
| `id` | `readonly id: string` | `String id` | Equivalent |
| `uid` | `readonly uid: number` | `int uid` | Equivalent |
| `name` | `readonly name: string` | `String? name` | Flutter allows null |
| `bandwidth` | `readonly bandwidth: number` | `int bandwidth` | Equivalent |
| `codecs` | `readonly codecs: string` | `String? codecs` | Flutter allows null |
| `averageBandwidth` | `readonly averageBandwidth?: number` | `int? averageBandwidth` | Equivalent |
| `available` | `readonly available: boolean` | `bool available` | Equivalent |
| `label` | `label: string` (mutable) | N/A | **Missing in Flutter** |

### VideoQuality

| Property | React Native | Flutter | Delta |
|----------|-------------|---------|-------|
| `width` | `readonly width: number` | `int width` | Equivalent |
| `height` | `readonly height: number` | `int height` | Equivalent |
| `frameRate` | `readonly frameRate: number` | `double frameRate` | Equivalent |
| `firstFrame` | `readonly firstFrame: number` | `double firstFrame` | Equivalent |

### AudioQuality

| Property | React Native | Flutter | Delta |
|----------|-------------|---------|-------|
| `audioSamplingRate` | `readonly audioSamplingRate: number \| [number, number]` | `int audioSamplingRate` | **RN supports tuple (range); Flutter only int** |

## 5. TextTrack

| Property | React Native | Flutter | Delta |
|----------|-------------|---------|-------|
| `kind` | `TextTrackKind` enum | `String? kind` | **RN uses typed enum; Flutter uses raw string** |
| `mode` | `mode: TextTrackMode` (get/set) | `getMode()` / `setMode()` | Equivalent (different accessor style) |
| `type` | `readonly type: TextTrackType` | `TextTrackType type` | Equivalent |
| `cues` | `cues: TextTrackCue[] \| null` | `Cues cues` | Equivalent |
| `activeCues` | N/A | `Cues activeCues` | **Missing in RN** (Flutter tracks active cues separately) |
| `src` / `source` | `readonly src: string` | `String? source` | Equivalent (different naming) |
| `forced` / `isForced` | `readonly forced: boolean` | `bool isForced` | Equivalent (different naming) |
| `inBandMetadataTrackDispatchType` | N/A | `String? inBandMetadataTrackDispatchType` | **Missing in RN** |
| `readyState` | N/A | `TextTrackReadyState readyState` | **Missing in RN** |

### TextTrackMode Enum

| Value | React Native | Flutter | Delta |
|-------|-------------|---------|-------|
| disabled | `'disabled'` | `TextTrackMode.disabled` | Equivalent |
| showing | `'showing'` | `TextTrackMode.showing` | Equivalent |
| hidden | `'hidden'` | `TextTrackMode.hidden` | Equivalent |

### TextTrackType Enum

| Value | React Native | Flutter | Delta |
|-------|-------------|---------|-------|
| cea608 | Yes | Yes | — |
| id3 | Yes | Yes | — |
| srt | Yes | Yes | — |
| ttml | Yes | Yes | — |
| webvtt | Yes | Yes | — |
| daterange | Yes | Yes | — |
| eventstream | Yes | Yes | — |
| emsg | Yes | Yes | — |
| none | No | Yes | **Flutter has `none`** |
| timecode | No | Yes | **Flutter has `timecode`** |

### TextTrackKind Enum

| Value | React Native | Flutter | Delta |
|-------|-------------|---------|-------|
| captions | Yes (enum) | As string | **RN has typed enum; Flutter uses raw string** |
| chapters | Yes (enum) | As string | Same |
| descriptions | Yes (enum) | As string | Same |
| metadata | Yes (enum) | As string | Same |
| subtitles | Yes (enum) | As string | Same |
| thumbnails | Yes (enum) | As string | Same |

## 6. TextTrackCue

| Property | React Native | Flutter | Delta |
|----------|-------------|---------|-------|
| `id` | `id: string` | `String id` | Equivalent |
| `uid` | `readonly uid: number` | `int uid` | Equivalent |
| `startTime` | `startTime: number` | `double startTime` | Equivalent |
| `endTime` | `endTime: number` | `double endTime` | Equivalent |
| `content` | `content: any` | `dynamic content` | Equivalent |

### DateRangeCue

| Property | React Native | Flutter | Delta |
|----------|-------------|---------|-------|
| `class` / `cueClass` | `class: string \| undefined` | `String? cueClass` | Equivalent (different naming due to reserved word) |
| `startDate` | `startDate: Date` | `DateTime startDate` | Equivalent |
| `endDate` | `endDate: Date \| undefined` | `DateTime? endDate` | Equivalent |
| `duration` | `duration: number \| undefined` | `double? duration` | Equivalent |
| `plannedDuration` | `plannedDuration: number \| undefined` | `double? plannedDuration` | Equivalent |
| `endOnNext` | `endOnNext: boolean` | `bool endOnNext` | Equivalent |
| `scte35Cmd` | `scte35Cmd: ArrayBuffer \| undefined` | N/A | **Missing in Flutter** |
| `scte35Out` | `scte35Out: ArrayBuffer \| undefined` | N/A | **Missing in Flutter** |
| `scte35In` | `scte35In: ArrayBuffer \| undefined` | N/A | **Missing in Flutter** |
| `customAttributes` | `Record<string, string \| number \| ArrayBuffer>` | `Map<String, dynamic>?` | Equivalent |

## 7. TextTrackStyle

**Entirely missing in Flutter.** React Native provides:

```typescript
interface TextTrackStyle {
  fontFamily: string | undefined;
  fontColor: string | undefined;
  fontSize: string | undefined;
  fontPath: string | undefined;
  backgroundColor: string | undefined;
  windowColor: string | undefined;
  edgeStyle: EdgeStyle | undefined;  // none, dropshadow, raised, depressed, uniform
  edgeColor: string | undefined;
  marginTop: number | undefined;
  marginBottom: number | undefined;
  marginLeft: number | undefined;
  marginRight: number | undefined;
}
```

## 8. Events

### Track List Events

| Event | React Native | Flutter | Delta |
|-------|-------------|---------|-------|
| Add track | `TrackListEventType.ADD_TRACK` via `MEDIA_TRACK_LIST` / `TEXT_TRACK_LIST` | Separate `AddVideoTrackEvent`, `AddAudioTrackEvent`, `AddTextTrackEvent` | **RN uses unified event with subType; Flutter uses separate event classes per track type** |
| Remove track | `TrackListEventType.REMOVE_TRACK` | Separate `RemoveVideoTrackEvent`, `RemoveAudioTrackEvent`, `RemoveTextTrackEvent` | Same pattern difference |
| Change track | `TrackListEventType.CHANGE_TRACK` | Separate `*TrackListChangeEvent` classes | Same pattern difference |

### Media Track Events

| Event | React Native | Flutter | Delta |
|-------|-------------|---------|-------|
| Active quality changed | `MediaTrackEventType.ACTIVE_QUALITY_CHANGED` via `MEDIA_TRACK` event | `VideoActiveQualityChangedEvent` / `AudioActiveQualityChangedEvent` | **RN unified; Flutter separate per type** |
| Target quality changed | N/A in TS events (only native bridge) | `VideoTargetQualityChangedEvent` / `AudioTargetQualityChangedEvent` | **Missing in RN public API** |
| Quality update | N/A | `VideoQualityUpdateEvent` / `AudioQualityUpdateEvent` | **Missing in RN** |

### Text Track Events

| Event | React Native | Flutter | Delta |
|-------|-------------|---------|-------|
| Add cue | `TextTrackEventType.ADD_CUE` | `TextTrackAddCueEvent` | Equivalent |
| Remove cue | `TextTrackEventType.REMOVE_CUE` | `TextTrackRemoveCueEvent` | Equivalent |
| Enter cue | `TextTrackEventType.ENTER_CUE` | `TextTrackEnterCueEvent` | Equivalent |
| Exit cue | `TextTrackEventType.EXIT_CUE` | `TextTrackExitCueEvent` | Equivalent |
| Cue change | N/A | `TextTrackCueChangeEvent` | **Missing in RN** |
| Track change | N/A | `TextTrackChangeEvent` | **Missing in RN** |
| Cue enter (per-cue) | N/A | `CueEnterEvent` | **Missing in RN** |
| Cue exit (per-cue) | N/A | `CueExitEvent` | **Missing in RN** |
| Cue update (per-cue) | N/A | `CueUpdateEvent` | **Missing in RN** |

## 9. Caching / Preferred Track Selection

| Feature | React Native | Flutter | Delta |
|---------|-------------|---------|-------|
| Preferred track selection for caching | `CachingPreferredTrackSelection { audioTrackSelection: string[], textTrackSelection?: string[] }` | N/A | **Missing in Flutter** |

## 10. Utility Functions

| Function | React Native | Flutter | Delta |
|----------|-------------|---------|-------|
| `filterRenderableTracks()` | Yes | No | **Missing in Flutter** |
| `filterThumbnailTracks()` | Yes | No | **Missing in Flutter** |
| `isThumbnailTrack()` | Yes | No | **Missing in Flutter** |
| `isDateRangeCue()` | Yes | No | **Missing in Flutter** |
| `isVideoQuality()` | Yes | No | **Missing in Flutter** |
| `findMediaTrackByUid()` | Yes | No (collection has `firstWhereOrNull`) | Flutter uses generic collection method |
| `sortTracks()` | Yes | No | **Missing in Flutter** |

## Summary of Key Differences

### Missing in Flutter (present in RN)
1. **TextTrackStyle** — full text track styling API (font, color, margins, edge style)
2. **SCTE-35 fields** on DateRangeCue (`scte35Cmd`, `scte35Out`, `scte35In`)
3. **Player-level selected track properties** (`selectedAudioTrack`, `selectedVideoTrack`, `selectedTextTrack`)
4. **TextTrackKind enum** — Flutter uses raw strings instead of a typed enum
5. **Quality `label`** property (mutable)
6. **AudioQuality `audioSamplingRate` tuple support** — RN supports `[number, number]` range
7. **CachingPreferredTrackSelection** for offline caching
8. **Track utility functions** (filter, sort, type guards)

### Missing in RN (present in Flutter)
1. **`activeCues`** on TextTrack (separate from `cues`)
2. **`readyState`** on TextTrack (`none`, `loading`, `loaded`, `error`)
3. **`inBandMetadataTrackDispatchType`** on TextTrack
4. **Per-track target quality setters** (`targetQuality`, `targetQualities` on the track object)
5. **Target quality changed event** in public API
6. **Quality update events** (`VideoQualityUpdateEvent`, `AudioQualityUpdateEvent`)
7. **Per-cue events** (`CueEnterEvent`, `CueExitEvent`, `CueUpdateEvent`)
8. **`TextTrackCueChangeEvent`**, **`TextTrackChangeEvent`**
9. **`TextTrackType.none`** and **`TextTrackType.timecode`** enum values

### Architectural Differences
- **Track selection**: RN uses player-level uid-based selection; Flutter uses per-track `isEnabled`/`setMode()`.
- **Target quality**: RN sets at player level by uid; Flutter sets directly on the track object.
- **Event system**: RN uses unified events with `subType` and `trackType` discriminators; Flutter uses separate strongly-typed event classes per track type.
- **Nullability**: Flutter is more permissive with nullable track properties (`id`, `label`, `language`, `kind`).
