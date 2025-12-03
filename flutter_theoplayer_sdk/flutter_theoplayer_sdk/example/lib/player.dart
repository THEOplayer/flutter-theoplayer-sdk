import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:theoplayer/theoplayer.dart';
import 'package:theoplayer_example/player_widgets/current_time_widget.dart';
import 'package:theoplayer_example/player_widgets/player_ui_widget.dart';
import 'package:theoplayer_example/player_widgets/texture_widgets/aspect_ratio_chromeless_widget.dart';
import 'package:theoplayer_example/player_widgets/texture_widgets/aspect_ratio_custom_fullscreen_widget.dart';

// use your THEOplayer Flutter license here from https://portal.theoplayer.com
// without a license the player only accepts URLs from 'localhost' or 'theoplayer.com' domains
const PLAYER_LICENSE = "";

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late THEOplayer player;

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
                AspectRatioCustomFullscreenWidget(
                    theoplayer: player,
                    fullscreenConfig:
                        player.theoPlayerConfig.fullscreenConfiguration),
                PlayerUI(player: player),
              ],
            ),
          );
        },
        theoPlayerConfig: THEOplayerConfig(
            license: PLAYER_LICENSE,
            // Extra THEOlive configuration:
            //theolive: TheoLiveConfiguration(externalSessionId: "mySessionID"),
            webConfiguration: WebConfig(libraryLocation: "/theoplayer")),
        onCreate: () {
          print("main - THEOplayer - onCreate");
          player.autoplay = true;
          player.allowBackgroundPlayback = true;
          player.allowAutomaticPictureInPicture = true;
          // print errors
          player.addEventListener(PlayerEventTypes.ERROR, (errorEvent) {
            if (!mounted) return;
            var error = errorEvent as ErrorEvent;
            ScaffoldMessenger.of(context).showSnackBar(
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

          player.addEventListener(PlayerEventTypes.PRESENTATIONMODECHANGE,
              (pmEvent) {
            var pmd = pmEvent as PresentationModeChangeEvent;
            print("New presentation mode: ${pmd.presentationMode}");
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
                AspectRatioChromelessPlayerView(
                  player: player,
                  continuouslyFollowAspectRatioChanges: true,
                ),
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
                        onPressed: () {
                          player
                              .setPresentationMode(PresentationMode.FULLSCREEN);
                        },
                        child: const Text("Open Fullscreen")),
                    FilledButton(
                        onPressed: () {
                          if (kIsWeb) {
                            player.setPresentationMode(PresentationMode.PIP);
                          } else {
                            player.allowAutomaticPictureInPicture =
                                !player.allowAutomaticPictureInPicture;
                          }
                        },
                        child: const Text(
                            "Open PiP (web) / Flip automatic PiP mode (native)")),
                    FilledButton(
                        onPressed: () {
                          player.setPresentationMode(PresentationMode.INLINE);
                        },
                        child: const Text("INLINE")),
                    FilledButton(
                        onPressed: () {
                          player.getVideoTracks().first.targetQuality =
                              player.getVideoTracks().first.qualities.first;
                        },
                        child: const Text("set video target quality")),
                    Column(
                      children: [
                        const Text("Sources"),
                        FilledButton(
                          onPressed: () {
                            /**
                             * register for theolive events, if interested
                             *
                             *
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
                             */

                            /**
                             * preload channels for faster startup
                             *
                             player.theoLive?.preloadChannels(["38yyniscxeglzr8n0lbku57b0"]);
                             */
                            player.source = SourceDescription(sources: [
                              TheoLiveSource(src: "38yyniscxeglzr8n0lbku57b0"),
                            ]);
                          },
                          child: const Text("THEOlive source"),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
