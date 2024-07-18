import 'package:flutter/material.dart';
import 'package:theoplayer/theoplayer.dart';
import 'package:theoplayer_example/helpers/sources.dart';
import 'package:theoplayer_example/player_widgets/current_time_widget.dart';
import 'package:theoplayer_example/player_widgets/player_ui_widget.dart';
import 'package:theoplayer_example/player_widgets/texture_widgets/aspect_ratio_chromeless_widget.dart';
import 'package:theoplayer_example/player_widgets/texture_widgets/aspect_ratio_custom_fullscreen_widget.dart';

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

  final _messengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();

    player = THEOplayer(
        fullscreenBuilder: (BuildContext context, THEOplayer player) {
          // default, chromeless behaviour, same as not specifying a fullscreenBuilder.
          // return FullscreenStatefulWidget(theoplayer: player, fullscreenConfig: player.theoPlayerConfig.fullscreenConfig),

          // example on how to pass a custom UI with the player
          return Scaffold(
            body: Stack(
              alignment: Alignment.center,
              children: [
                // for hybrid composition:
                //FullscreenStatefulWidget(theoplayer: player, fullscreenConfig: player.theoPlayerConfig.fullscreenConfig),

                // for Texture-based composition:
                AspectRatioCustomFullscreenWidget(theoplayer: player, fullscreenConfig: player.theoPlayerConfig.fullscreenConfig),
                PlayerUI(player: player),
              ],
            ),
          );
        },
        theoPlayerConfig: THEOplayerConfig(
          license: PLAYER_LICENSE,
        ),
        onCreate: () {
          print("main - THEOplayer - onCreate");
          player.setAutoplay(true);
          player.setAllowBackgroundPlayback(true);
          // print errors
          player.addEventListener(PlayerEventTypes.ERROR, (errorEvent) {
            var error = errorEvent as ErrorEvent;
            _messengerKey.currentState?.showSnackBar(
              SnackBar(
                duration: const Duration(milliseconds: 6000),
                backgroundColor: Colors.red,
                content: Text(error.error),
                action: SnackBarAction(
                  label: 'OK',
                  onPressed: () {
                    // Code to execute.
                  },
                ),
              ),
            );
          });
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
      scaffoldMessengerKey: _messengerKey,
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
                      //for hybrid compositon.
                      // ChromelessPlayerView(player: player),

                      //for Texture-based composition:
                      AspectRatioChromelessPlayerView(player: player, continuouslyFollowAspectRatioChanges: true,),
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
                          FilledButton(
                              onPressed: (){
                                player.stopChromecast();
                              },
                              child: const Text("stop casting")),
                          Column(
                            children: [
                              const Text("Sources"),
                              FilledButton(
                                onPressed: () {
                                  _licenseConfigCheckDialog(context);
                                  player.setSource(HLS);
                                },
                                child: const Text("Basic source"),
                              ),
                              FilledButton(
                                onPressed: () {
                                  _licenseConfigCheckDialog(context);
                                  player.setSource(DASH_WIDEVINE);
                                },
                                child: const Text("Widevine source"),
                              ),
                              FilledButton(
                                onPressed: () {
                                  _licenseConfigCheckDialog(context);
                                  player.setSource(HLS_FAIRPLAY);
                                },
                                child: const Text("Fairplay EZDRM source - iOS"),
                              ),
                              FilledButton(
                                onPressed: () {
                                  _licenseConfigCheckDialog(context);
                                  player.setSource(DASH_WIDEVINE_CUSTOM);
                                },
                                child: const Text("Widevine KeyOS source - Android"),
                              ),
                              FilledButton(
                                onPressed: () => {
                                  player.setSource(GOOGLE_IMA_HLS)
                                },
                                child: const Text("IMA HLS source"),
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

  Future<void> _licenseConfigCheckDialog(BuildContext context) async {
    if (PLAYER_LICENSE != "") {
      //ok
      return;
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('License configuration needed!'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Your forgot to configure your license!'),
                SizedBox(height: 8,),
                Text('Without a license, THEOplayer can only play sources from `theoplayer.com`'),
                SizedBox(height: 8,),
                Text('Get your license from `https://portal.theoplayer.com!`'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
