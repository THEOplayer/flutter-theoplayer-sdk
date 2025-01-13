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
                AspectRatioCustomFullscreenWidget(theoplayer: player, fullscreenConfig: player.theoPlayerConfig.fullscreenConfiguration),
                PlayerUI(player: player),
              ],
            ),
          );
        },
        theoPlayerConfig: THEOplayerConfig(
          license: PLAYER_LICENSE,
          androidConfiguration: AndroidConfig.create(viewComposition: AndroidViewComposition.HYBRID_COMPOSITION)
          // Extra THEOlive configuration:
          //theolive: TheoLiveConfiguration(externalSessionId: "mySessionID"),
        ),
        onCreate: () {
          print("main - THEOplayer - onCreate");
          player.autoplay = true;
          player.allowBackgroundPlayback = true;
          player.allowAutomaticPictureInPicture = true;
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

          player.addEventListener(PlayerEventTypes.PRESENTATIONMODECHANGE, (pmEvent) {
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
                                if (kIsWeb) {
                                  player.setPresentationMode(PresentationMode.PIP);
                                } else {
                                  player.allowAutomaticPictureInPicture = !player.allowAutomaticPictureInPicture;
                                }
                              },
                              child: const Text("Open PiP (web) / Flip automatic PiP mode (native)")),
                          FilledButton(
                              onPressed: () {
                                player.setPresentationMode(PresentationMode.INLINE);
                              },
                              child: const Text("INLINE")),
                          FilledButton(
                              onPressed: () {
                                player.getVideoTracks().first.targetQuality = player.getVideoTracks().first.qualities.first;
                              },
                              child: const Text("set video target quality")),
                          Column(
                            children: [
                              const Text("Sources"),
                              FilledButton(
                                onPressed: () {
                                  _licenseConfigCheckDialog(context);
                                  player.source = SourceDescription(sources: [
                                    TypedSource(src: "https://cdn.theoplayer.com/video/big_buck_bunny/big_buck_bunny.m3u8"),
                                  ]);
                                },
                                child: const Text("Basic source"),
                              ),
                              FilledButton(
                                onPressed: () {
                                  _licenseConfigCheckDialog(context);

                                  /**
                                   * register for theolive events, if interested
                                   *
                                   *
                                  player.theoLive?.addEventListener(THEOliveApiEventTypes.PUBLICATIONLOADSTART, (e) {
                                    print("PUBLICATIONLOADSTART");
                                  });
                                  player.theoLive?.addEventListener(THEOliveApiEventTypes.PUBLICATIONOFFLINE, (e) {
                                    print("PUBLICATIONOFFLINE");
                                  });
                                  player.theoLive?.addEventListener(THEOliveApiEventTypes.PUBLICATIONLOADED, (e) {
                                    print("PUBLICATIONLOADED");
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
                              FilledButton(
                                onPressed: () {
                                  _licenseConfigCheckDialog(context);
                                  player.source = SourceDescription(sources: [
                                    TypedSource(
                                        src: "https://storage.googleapis.com/wvmedia/cenc/h264/tears/tears_sd.mpd",
                                        drm: DRMConfiguration(
                                          widevine: WidevineDRMConfiguration(
                                              licenseAcquisitionURL: "https://proxy.uat.widevine.com/proxy?provider=widevine_test"),
                                        )),
                                  ]);
                                },
                                child: const Text("Widevine source"),
                              ),
                              FilledButton(
                                onPressed: () {
                                  _licenseConfigCheckDialog(context);
                                  player.source = SourceDescription(sources: [
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
                                  ]);
                                },
                                child: const Text("Fairplay EZDRM source - iOS"),
                              ),
                              FilledButton(
                                onPressed: () {
                                  _licenseConfigCheckDialog(context);
                                  player.source = SourceDescription(sources: [
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
                                  ]);
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
    print("source: ${player.source}");
    print("isAutoplay: ${player.isAutoplay}");
    print("isPaused: ${player.isPaused}");
    print("currentTime: ${player.currentTime}");
    print("currentProgramDateTIme: ${player.currentProgramDateTime}");
    print("duration: ${player.duration}");
    print("playbackRate: ${player.playbackRate}");
    print("volume: ${player.volume}");
    print("isMuted: ${player.isMuted}");
    print("preload: ${player.preload}");
    print("readyState: ${player.readyState}");
    print("isSeeking: ${player.isSeeking}");
    print("isEnded: ${player.isEnded}");
    print("videoHeight: ${player.videoHeight}");
    print("videoWidth: ${player.videoWidth}");
    print("buffered: ${player.buffered}");
    print("seekable: ${player.seekable}");
    print("played: ${(player.played)}");
    print("error: ${player.error}");
    print("audio target quality: ${player.audioTracks.first.targetQuality?.uid}");
    print("audio active quality: ${player.audioTracks.first.activeQuality?.uid}");
    print("video target quality: ${player.videoTracks.first.targetQuality?.uid}");
    print("video active quality: ${player.videoTracks.first.activeQuality?.uid}");
    print("allowBackgroundPlayback: ${player.allowBackgroundPlayback}");

    if (kIsWeb) {
      print("theolive publicaitionState: ${player.theoLive?.publicationState}");
      print("theolive badnetwork: ${player.theoLive?.badNetworkMode}");
    }
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
