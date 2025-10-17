# THEOlive support

High-quality real-time video streaming at scale for providers of sports betting, iGaming and interactive entertainment

For more info, visit [THEOlive website](https://www.theoplayer.com/product/theolive).

## Limitations

* Only Flutter Web is supported.
* Android and iOS will follow later. (You can check out our dedicated [THEOlive Flutter SDK](https://github.com/THEOplayer/flutter-theolive-sdk))

## THEOlive playback
THEOlive playback is becoming crucial part of THEOplayer's playback engine instead of being available as a separate SDK.

The WEB support is already added, Android and iOS support as part of the THEOplayer SDK will come later. (Right now you can use the [dedicated THEOlive Flutter SDK](https://github.com/THEOplayer/flutter-theolive-sdk) for Android and iOS support) 

### Setting a THEOlive source

```js
player.source = SourceDescription(sources: [
    TheoLiveSource(src: "2vqqekesftg9zuvxu9tdme6kl"),
]);
```

Instead of using a remote HTTPS url, you can just specify your `channelID` from the [THEOlive Console](https://console.theo.live/) and you can start the playback.

**NOTE:** your THEOplayer license has to contain the `HESP` feature to make it work. (HESP is the underlying technology of THEOlive).

Once the playback starts, you can listen to playback-specify events on THEOplayer.

#### Additional configuration options on `THEOPlayerConfig` 
By setting a `THEOliveConfiguration` object on `THEOplayerConfig` you are able to specify extra configuration for THEOlive (e.g. a custom sessionId to follow the requests on the backend)
```js
    player = THEOplayer(
        theoPlayerConfig: THEOplayerConfig(
          license: PLAYER_LICENSE,
          theolive: TheoLiveConfiguration(externalSessionId: "mySessionID"),
        ),
        onCreate: () {
          print("player is created, ready to use");
    
        });
```
### Listening for THEOlive-specific events

```js
    player.theoLive?.addEventListener(THEOliveApiEventTypes.DISTRIBUTIONLOADSTART, (e) {
        print("DISTRIBUTIONLOADSTART");
    });
    player.theoLive?.addEventListener(THEOliveApiEventTypes.DISTRIBUTIONOFFLINE, (e) {
        print("DISTRIBUTIONOFFLINE");
    });
    player.theoLive?.addEventListener(THEOliveApiEventTypes.ENDPOINTLOADED, (e) {
        print("ENDPOINTLOADED");
    });
    player.theoLive?.addEventListener(THEOliveApiEventTypes.INTENTTOFALLBACK, (e) {
        print("INTENTTOFALLBACK");
    });
    player.theoLive?.addEventListener(THEOliveApiEventTypes.ENTERBADNETWORKMODE, (e) {
        print("ENTERBADNETWORKMODE");
    });
    player.theoLive?.addEventListener(THEOliveApiEventTypes.EXITBADNETWORKMODE, (e) {
        print("EXITBADNETWORKMODE");
    });
```

## Migration from THEOlive Flutter SDK to THEOplayer Flutter SDK

### setStateListener
From 
```js
theoLive.setStateListener(...)
```

to
```js
player.theoLive.setStateListener(...)
```

### loadChannel
From
```js
theoLive.loadChannel("2vqqekesftg9zuvxu9tdme6kl")
```

to
```js
player.source = SourceDescription(sources: [
    TheoLiveSource(src: "2vqqekesftg9zuvxu9tdme6kl"),
]);
```

### addEventListener
From
```js
theoLive.addEventListener(this)
```

to THEOlive-related events
```js
    player.theoLive?.addEventListener(THEOliveApiEventTypes.DISTRIBUTIONLOADSTART, (e) {
        print("DISTRIBUTIONLOADSTART event");
    });
    player.theoLive?.addEventListener(THEOliveApiEventTypes.DISTRIBUTIONOFFLINE, (e) {
        print("DISTRIBUTIONOFFLINE event");
    });
    player.theoLive?.addEventListener(THEOliveApiEventTypes.ENDPOINTLOADED, (e) {
        print("ENDPOINTLOADED event");
    });
    player.theoLive?.addEventListener(THEOliveApiEventTypes.INTENTTOFALLBACK, (e) {
        print("INTENTTOFALLBACK event");
    });
    player.theoLive?.addEventListener(THEOliveApiEventTypes.ENTERBADNETWORKMODE, (e) {
        print("ENTERBADNETWORKMODE event");
    });
    player.theoLive?.addEventListener(THEOliveApiEventTypes.EXITBADNETWORKMODE, (e) {
        print("EXITBADNETWORKMODE event");
    });
```

and to playback-related events
```js
    player.addEventListener(PlayerEventTypes.PLAY, (e) {
        print("PLAY event");
    });
    player.addEventListener(PlayerEventTypes.PLAYING, (e) {
        print("PLAYING event");
    });
    player.addEventListener(PlayerEventTypes.PAUSE, (e) {
        print("PAUSE event");
    }););
```

### Playback-related actions
From
```js
theoLive.play()
```

to
```js
player.play()
```

### Channel events
The channel related events:
```js
ChannelLoadStart,
ChannelLoaded,
ChannelOffline
```

are renamed to `Publication` events
```js
PublicationLoadStart,
PublicationLoaded,
PublicationOffline
```

### Anything missing?
Please reach out to us!