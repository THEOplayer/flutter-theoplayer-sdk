import 'dart:async';

import 'package:flutter/material.dart';
import 'package:theoplayer/theoplayer.dart';

import 'package:theoplayer_example/debug_log.dart';

// Test license to load sources from localhost and theoplayer.com domains
// ignore: constant_identifier_names
const TEST_LICENSE = String.fromEnvironment("TEST_LICENSE", defaultValue: "");

class TestApp extends StatefulWidget {
  final _playerReady = Completer();
  final AndroidViewComposition androidViewComposition;

  TestApp({super.key, this.androidViewComposition = AndroidViewComposition.HYBRID_COMPOSITION});

  @override
  State<TestApp> createState() => _TestAppState();

  Future<void> waitForPlayerReady() {
    return _playerReady.future;
  }
}

class _TestAppState extends State<TestApp> {
  late THEOplayer player;

  @override
  void initState() {
    super.initState();

    if (TEST_LICENSE != "") {
      debugLog("Using test license");
    } else {
      debugLog("Using empty license");
    }

    player = THEOplayer(
        theoPlayerConfig: THEOplayerConfig(
            license: TEST_LICENSE, androidConfiguration: AndroidConfig.create(viewComposition: widget.androidViewComposition), webConfiguration: WebConfig(libraryLocation: "/theoplayer")),
        onCreate: () {
          debugLog("TestApp - THEOplayer - onCreate");
          player.addEventListener(PlayerEventTypes.SOURCECHANGE, (event) {
            debugLog("_DEBUG: SOURCECHANGE received");
          });
          player.addEventListener(PlayerEventTypes.PLAYING, (event) {
            debugLog("_DEBUG: PLAYING received");
          });
          player.addEventListener(PlayerEventTypes.PROGRESS, (event) {
            debugLog("_DEBUG: PROGRESS received");
          });
          player.addEventListener(PlayerEventTypes.ERROR, (event) {
            debugLog("_DEBUG: ERROR: ${(event as ErrorEvent).error}");
          });
          player.addEventListener(PlayerEventTypes.TIMEUPDATE, (event) {
            debugLog("_DEBUG: TIMEUPDATE received");
          });
          player.addEventListener(PlayerEventTypes.CANPLAY, (event) {
            debugLog("_DEBUG: CANPLAY received");
          });
          player.addEventListener(PlayerEventTypes.DURATIONCHANGE, (event) {
            debugLog("_DEBUG: DURATIONCHANGE received");
          });
          player.addEventListener(PlayerEventTypes.LOADSTART, (event) {
            debugLog("_DEBUG: LOADSTART received");
          });
          player.addEventListener(PlayerEventTypes.PLAY, (event) {
            debugLog("_DEBUG: PLAY received");
          });
          player.addEventListener(PlayerEventTypes.PAUSE, (event) {
            debugLog("_DEBUG: PAUSE received");
          });
          player.addEventListener(PlayerEventTypes.WAITING, (event) {
            debugLog("_DEBUG: PAUSE received");
          });
          player.addEventListener(PlayerEventTypes.CURRENTSOURCECHANGE, (event) {
            debugLog("_DEBUG: CURRENTSOURCECHANGE received ${(event as CurrentSourceChangeEvent).currentSource?.src}");
          });

          widget._playerReady.complete();
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
          title: const Text('THEOplayer Test App'),
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
                      ChromelessPlayerView(key: const Key("testChromelessPlayer"), player: player),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
