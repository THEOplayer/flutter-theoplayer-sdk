## The THEOplayer component

### Architecture

<img src="https://github.com/THEOplayer/flutter-theoplayer-sdk/blob/main/doc/theoplayer_flutter_sdk_arch.png">

THEOplayer Flutter SDK utilizes the well-known THEOplayer native SDKs under the hood 
and exposes the APIs on a single API layer in Flutter to speed up prototyping and development.

### Available APIs
- Basic player APIs (play, pause, seek, etc...) on the `THEOplayer` instance
- `SourceDescription`-related classes
- Player events (`CANPLAY, PLAYING, TIMEUPDATE`, etc..)
- Track APIs (acive tracks, cues, enable, disable) on the `THEOplayer.[audio|video|text]track` objects
- `Track`-related classes
- Track events (`ADD_TRACK, REMOVE_TRACK, ADD_CUE, ENTER_CUE`, etc..)

### API Reference
_To be completed._

Please use your IDE's features to discover the available APIs.

Read [`theoplayer.dart`](../flutter_theoplayer_sdk/lib/theoplayer.dart) for all the details.