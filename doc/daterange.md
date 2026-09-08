# HLS date ranges (EXT-X-DATERANGE)

The native THEOplayer SDKs can parse `EXT-X-DATERANGE` tags from HLS playlists and expose them as `DateRangeCue`s on a dedicated text track. This is available in the Flutter SDK on Android, iOS and Web.

## Enabling date range parsing

Date range parsing is opt-in. Enable it either for the whole player or per source:

```js
// player-level: applies to every source
player = THEOplayer(
    theoPlayerConfig: THEOplayerConfig(
      license: PLAYER_LICENSE,
      hlsDateRange: true,
    ),
    onCreate: () {},
);

// source-level: overrides the player-level setting for this source
player.source = SourceDescription(sources: [
    TypedSource(
        src: "https://example.com/stream-with-dateranges.m3u8",
        hlsDateRange: true),
]);
```

When `TypedSource.hlsDateRange` is `null` (the default), the player-level `THEOplayerConfig.hlsDateRange` setting applies.

## Consuming DateRangeCues

Date range cues arrive on a `TextTrack` with `type == TextTrackType.daterange`. Listen for the track and its cues through the regular TextTracks API:

```js
player.textTracks.addEventListener(TextTracksEventTypes.ADDTRACK, (event) {
    final track = (event as AddTextTrackEvent).track;
    if (track.type != TextTrackType.daterange) {
      return;
    }
    track.addEventListener(TextTrackEventTypes.ADDCUE, (cueEvent) {
      final cue = (cueEvent as TextTrackAddCueEvent).cue;
      if (cue is DateRangeCue) {
        print("Daterange: id=${cue.id}, startDate=${cue.startDate}, endDate=${cue.endDate}");
      }
    });
});
```

`DateRangeCue` exposes the parsed tag attributes:

| Field | Description |
|---|---|
| `id` | The `ID` attribute of the date range. |
| `cueClass` | The `CLASS` attribute, if present. |
| `startDate` / `endDate` | The `START-DATE` / `END-DATE` attributes as `DateTime`. |
| `duration` / `plannedDuration` | The `DURATION` / `PLANNED-DURATION` attributes in seconds. |
| `endOnNext` | Whether the `END-ON-NEXT` attribute is present. |
| `customAttributes` | The `X-` prefixed client attributes. Binary values are base64-encoded strings. |
| `scte35Cmd` / `scte35Out` / `scte35In` | The raw SCTE-35 payloads as `Uint8List`, if present. |

For open-ended date ranges (no end date or duration yet), `cue.endTime` is `double.infinity`.

## Limitations

* Updates to an already-added date range cue (e.g. an `END-DATE` arriving on a later playlist refresh) are not yet forwarded to Flutter.
* Date range parsing only applies to HLS sources; THEOlive sources do not use it.

## Example

The example app contains a "Daterange source" button that plays a stream with date ranges and logs the incoming cues.
