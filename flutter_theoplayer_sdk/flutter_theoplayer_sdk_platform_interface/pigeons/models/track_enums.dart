enum TextTrackMode {
  disabled,
  hidden,
  showing;
}

enum TextTrackType {
  none,
  srt,
  ttml,
  webvtt,
  emsg,
  eventstream,
  id3,
  cea608,
  daterange,
  timecode;
}

enum TextTrackReadyState {
  none,
  loading,
  loaded,
  error;
}
