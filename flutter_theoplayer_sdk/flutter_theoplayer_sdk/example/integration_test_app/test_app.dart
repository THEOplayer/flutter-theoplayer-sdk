import 'dart:async';

import 'package:flutter/material.dart';
import 'package:theoplayer/theoplayer.dart';

import 'test_log.dart';

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
      testLog("Using test license");
    } else {
      testLog("Using empty license");
    }

    player = THEOplayer(
        theoPlayerConfig: THEOplayerConfig(
            license: TEST_LICENSE, androidConfiguration: AndroidConfig.create(viewComposition: widget.androidViewComposition), webConfiguration: WebConfig(libraryLocation: "/theoplayer")),
        onCreate: () {
          testLog("TestApp - THEOplayer - onCreate");
          player.addEventListener(PlayerEventTypes.SOURCECHANGE, (event) {
            testLog("_DEBUG: SOURCECHANGE received");
          });
          player.addEventListener(PlayerEventTypes.PLAYING, (event) {
            testLog("_DEBUG: PLAYING received");
          });
          player.addEventListener(PlayerEventTypes.PROGRESS, (event) {
            testLog("_DEBUG: PROGRESS received");
          });
          player.addEventListener(PlayerEventTypes.ERROR, (event) {
            testLog("_DEBUG: ERROR: ${(event as ErrorEvent).error}");
          });
          player.addEventListener(PlayerEventTypes.TIMEUPDATE, (event) {
            testLog("_DEBUG: TIMEUPDATE received");
          });
          player.addEventListener(PlayerEventTypes.CANPLAY, (event) {
            testLog("_DEBUG: CANPLAY received");
          });
          player.addEventListener(PlayerEventTypes.DURATIONCHANGE, (event) {
            testLog("_DEBUG: DURATIONCHANGE received");
          });
          player.addEventListener(PlayerEventTypes.LOADSTART, (event) {
            testLog("_DEBUG: LOADSTART received");
          });
          player.addEventListener(PlayerEventTypes.PLAY, (event) {
            testLog("_DEBUG: PLAY received");
          });
          player.addEventListener(PlayerEventTypes.PAUSE, (event) {
            testLog("_DEBUG: PAUSE received");
          });
          player.addEventListener(PlayerEventTypes.WAITING, (event) {
            testLog("_DEBUG: PAUSE received");
          });
          player.addEventListener(PlayerEventTypes.CURRENTSOURCECHANGE, (event) {
            testLog("_DEBUG: CURRENTSOURCECHANGE received ${(event as CurrentSourceChangeEvent).currentSource?.src}");
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
