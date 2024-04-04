import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:theoplayer/theoplayer.dart';
import 'package:theoplayer/widget/chromeless_widget.dart';
import 'package:theoplayer/widget/fullscreen_widget.dart';
import 'package:theoplayer_example/helpers/sources.dart';
import 'package:theoplayer_example/player_widgets/current_time_widget.dart';
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
        fullscreenBuilder: (BuildContext context, THEOplayer player) {
          return FullscreenStatefulWidget(theoplayer: player, fullscreenConfig: player.theoPlayerConfig.fullscreenConfig);
        },
        theoPlayerConfig: THEOplayerConfig(
          license: PLAYER_LICENSE,
        ),
        onCreate: () {
          print("main - THEOplayer - onCreate");
          player.setAllowBackgroundPlayback(true);
        });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('THEOplayer example app'),
        ),
        body: Builder(builder: (context) {
          return Center(
            child: Column(
              children: [
                SizedBox(
                  width: 400,
                  height: 300,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ChromelessPlayerView(player: player),
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
                          const SizedBox(
                            height: 16,
                          ),
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
                          FilledButton(
                              onPressed: () {
                                player.setPresentationMode(PresentationMode.FULLSCREEN);
                              },
                              child: const Text("Open Fullscreen")),
                          FilledButton(
                              onPressed: () {
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
        }),
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
    print("allowBackgroundPlayback: ${player.allowBackgroundPlayback()}");
  }
}
