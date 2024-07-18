import 'package:flutter/material.dart';
import 'package:theoplayer/theoplayer.dart';
import 'package:theoplayer/widget/fullscreen_widget.dart';
import 'package:theoplayer_example/player_widgets/current_time_widget.dart';
import 'package:theoplayer_example/player_widgets/player_ui_widget.dart';
import 'package:theoplayer_example/player_widgets/texture_widgets/aspect_ratio_chromeless_widget.dart';

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
                          Column(
                            children: [
                              const Text("Sources"),
                              FilledButton(
                                onPressed: () => {
                                  player.setSource(SourceDescription(sources: [
                                    TypedSource(src: "https://cdn.theoplayer.com/video/big_buck_bunny/big_buck_bunny.m3u8"),
                                  ]))
                                },
                                child: const Text("Basic source"),
                              ),
                              FilledButton(
                                onPressed: () => {
                                  player.setSource(SourceDescription(sources: [
                                    TypedSource(
                                        src: "https://storage.googleapis.com/wvmedia/cenc/h264/tears/tears_sd.mpd",
                                        drm: DRMConfiguration(
                                          widevine: WidevineDRMConfiguration(
                                              licenseAcquisitionURL: "https://proxy.uat.widevine.com/proxy?provider=widevine_test"),
                                        )),
                                  ]))
                                },
                                child: const Text("Widevine source"),
                              ),
                              FilledButton(
                                onPressed: () => {
                                  player.setSource(SourceDescription(sources: [
                                    TypedSource(
                                        src: "https://fps.ezdrm.com/demo/video/ezdrm.m3u8",
                                        drm: DRMConfiguration(
                                          customIntegrationId: "EzdrmDRMIntegration",
                                          fairplay: FairPlayDRMConfiguration(
                                            licenseAcquisitionURL: "https://fps.ezdrm.com/api/licenses/09cc0377-6dd4-40cb-b09d-b582236e70fe",
                                            certificateURL: "https://fps.ezdrm.com/demo/video/eleisure.cer",
                                            headers: null,
                                          ),
                                        )),
                                  ]))
                                },
                                child: const Text("Fairplay EZDRM source - iOS"),
                              ),
                              FilledButton(
                                onPressed: () => {
                                  player.setSource(SourceDescription(sources: [
                                    TypedSource(
                                        src:
                                            "https://d2jl6e4h8300i8.cloudfront.net/netflix_meridian/4k-18.5!9/keyos-logo/g180-avc_a2.0-vbr-aac-128k/r30/dash-wv-pr/stream.mpd",
                                        drm: DRMConfiguration(
                                          customIntegrationId: "KeyOSDRMIntegration",
                                          integrationParameters: {
                                            "x-keyos-authorization":
                                                "PEtleU9TQXV0aGVudGljYXRpb25YTUw+PERhdGE+PEdlbmVyYXRpb25UaW1lPjIwMTYtMTEtMTkgMDk6MzQ6MDEuOTkyPC9HZW5lcmF0aW9uVGltZT48RXhwaXJhdGlvblRpbWU+MjAyNi0xMS0xOSAwOTozNDowMS45OTI8L0V4cGlyYXRpb25UaW1lPjxVbmlxdWVJZD4wZmZmMTk3YWQzMzQ0ZTMyOWU0MTA0OTIwMmQ5M2VlYzwvVW5pcXVlSWQ+PFJTQVB1YktleUlkPjdlMTE0MDBjN2RjY2QyOWQwMTc0YzY3NDM5N2Q5OWRkPC9SU0FQdWJLZXlJZD48V2lkZXZpbmVQb2xpY3kgZmxfQ2FuUGxheT0idHJ1ZSIgZmxfQ2FuUGVyc2lzdD0iZmFsc2UiIC8+PFdpZGV2aW5lQ29udGVudEtleVNwZWMgVHJhY2tUeXBlPSJIRCI+PFNlY3VyaXR5TGV2ZWw+MTwvU2VjdXJpdHlMZXZlbD48L1dpZGV2aW5lQ29udGVudEtleVNwZWM+PEZhaXJQbGF5UG9saWN5IC8+PExpY2Vuc2UgdHlwZT0ic2ltcGxlIiAvPjwvRGF0YT48U2lnbmF0dXJlPk1sNnhkcU5xc1VNalNuMDdicU8wME15bHhVZUZpeERXSHB5WjhLWElBYlAwOE9nN3dnRUFvMTlYK1c3MDJOdytRdmEzNFR0eDQydTlDUlJPU1NnREQzZTM4aXE1RHREcW9HelcwS2w2a0JLTWxHejhZZGRZOWhNWmpPTGJkNFVkRnJUbmxxU21raC9CWnNjSFljSmdaUm5DcUZIbGI1Y0p0cDU1QjN4QmtxMUREZUEydnJUNEVVcVJiM3YyV1NueUhGeVZqWDhCR3o0ZWFwZmVFeDlxSitKbWI3dUt3VjNqVXN2Y0Fab1ozSHh4QzU3WTlySzRqdk9Wc1I0QUd6UDlCc3pYSXhKd1ZSZEk3RXRoMjhZNXVEQUVZVi9hZXRxdWZiSXIrNVZOaE9yQ2JIVjhrR2praDhHRE43dC9nYWh6OWhVeUdOaXRqY2NCekJvZHRnaXdSUT09PC9TaWduYXR1cmU+PC9LZXlPU0F1dGhlbnRpY2F0aW9uWE1MPg==",
                                          },
                                          widevine: WidevineDRMConfiguration(
                                            licenseAcquisitionURL: "https://wv-keyos.licensekeyserver.com",
                                          ),
                                        )),
                                  ]))
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
