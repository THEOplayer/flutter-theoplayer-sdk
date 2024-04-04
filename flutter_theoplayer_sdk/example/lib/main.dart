import 'package:flutter/material.dart';
import 'package:theoplayer/theoplayer.dart';
import 'package:theoplayer_example/helpers/sources.dart';
import 'package:theoplayer_example/player_widgets/current_time_widget.dart';
import 'package:theoplayer_example/player_widgets/fullscreen_widget.dart';
import 'package:theoplayer_example/player_widgets/player_ui_widget.dart';

// use your THEOplayer Flutter license here from https://portal.theoplayer.com
// without a license the player only accepts URLs from 'localhost' or 'theoplayer.com' domains
const PLAYER_LICENSE = "";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  UniqueKey key1 = UniqueKey();
  UniqueKey key2 = UniqueKey();
  late THEOplayer player;

  @override
  void initState() {
    super.initState();

    player = THEOplayer(
        theoPlayerConfig: THEOplayerConfig(
          license: PLAYER_LICENSE,
        ),
        onCreate: () {
          print("main - THEOplayer - onCreate");
        });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  bool inFullscreen = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('THEOplayer example app'),
        ),
        body: Builder(
          builder: (context) {
            return Center(
              child: Column(
                children: [
                  SizedBox(
                    width: 400,
                    height: 300,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        !inFullscreen ? ChromelessPlayer(key: ChromelessPlayer.globalKey, player: player) : Container(),
                        PlayerUI(player: player),
                      ],

                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        Column(
                          children: [
                            CurrentTimeWidget(player: player),
                            const SizedBox(height: 16,),
                            const Text("API calls"),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FilledButton(
                                  onPressed: () => {player.play()},
                                  child: const Text("PLAY"),
                                ),
                                FilledButton(
                                  onPressed: () => {player.pause()},
                                  child: const Text("PAUSE"),
                                ),
                              ],
                            ),
                  
                                FilledButton(
                                  onPressed: () => {logApiCalls()},
                                  child: const Text("API LOGGER"),
                                ),
                                FilledButton(onPressed: () {
                                  setState(() {
                                    inFullscreen = true;
                                  });
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return FullscreenStatelessWidget(theoplayer: player,);
                                  }, settings: null)).then((value){
                                    print("Return from fullscreen ");
                                    setState(() {
                                      inFullscreen = false;
                                    });
                                  });
                  
                                }, child: const Text("Open Fullscreen")),
                                FilledButton(
                                  onPressed: (){
                                    player.getVideoTracks().first.targetQuality = player.getVideoTracks().first.qualities.first;
                                  }, 
                                  child: const Text("set video target quality")),
                                FilledButton(
                                  onPressed: (){
                                    player.setChromecastStartingSource(HLS);
                                  }, 
                                  child: const Text("set different casting source")),
                                FilledButton(
                                  onPressed: (){
                                    player.startChromecast();
                                  }, 
                                  child: const Text("start casting")),
                            Column(
                              children: [
                                const Text("Sources"),
                                FilledButton(
                                  onPressed: () => {
                                    player.setSource(HLS)
                                  },
                                  child: const Text("Basic source"),
                                ),
                                FilledButton(
                                  onPressed: () => {
                                    player.setSource(DASH_WIDEVINE)
                                  },
                                  child: const Text("Widevine source"),
                                ),
                                FilledButton(
                                  onPressed: () => {
                                    player.setSource(HLS_FAIRPLAY)
                                  },
                                  child: const Text("Fairplay EZDRM source - iOS"),
                                ),
                                FilledButton(
                                  onPressed: () => {
                                    player.setSource(DASH_WIDEVINE_CUSTOM)
                                  },
                                  child: const Text("Widevine KeyOS source - Android"),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
        ),
      ),
    );
  }

  Future<void> logApiCalls() async {
    print("source: ${player.getSource()}");
    print("isAutoplay: ${player.isAutoplay()}");
    print("isPaused: ${player.isPaused()}");
    print("currentTime: ${player.getCurrentTime()}");
    print("currentProgramDateTIme: ${player.getCurrentProgramDateTime()}");
    print("duration: ${player.getDuration()}");
    print("playbackRate: ${player.getPlaybackRate()}");
    print("volume: ${player.getVolume()}");
    print("isMuted: ${player.isMuted()}");
    print("preload: ${player.getPreload()}");
    print("readyState: ${player.getReadyState()}");
    print("isSeeking: ${player.isSeeking()}");
    print("isEnded: ${player.isEnded()}");
    print("videoHeight: ${player.getVideoHeight()}");
    print("videoWidth: ${player.getVideoWidth()}");
    print("buffered: ${player.getBuffered()}");
    print("seekable: ${player.getSeekable()}");
    print("played: ${(player.getPlayed())}");
    print("error: ${player.getError()}");
    print("audio target quality: ${player.getAudioTracks().first.targetQuality?.uid}");
    print("audio active quality: ${player.getAudioTracks().first.activeQuality?.uid}");
  }
}

class ChromelessPlayer extends StatelessWidget {
  static GlobalKey globalKey = GlobalKey();

  const ChromelessPlayer({
    super.key,
    required this.player,
  });

  final THEOplayer player;

  @override
  Widget build(BuildContext context) {
    return player.getView();
  }
}
