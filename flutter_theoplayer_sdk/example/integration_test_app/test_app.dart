import 'dart:async';

import 'package:flutter/material.dart';
import 'package:theoplayer/theoplayer.dart';

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
      print("Using test license");
    } else {
      print("Using empty license");
    }

    player = THEOplayer(
        theoPlayerConfig: THEOplayerConfig(
          license: TEST_LICENSE,
          androidConfiguration: AndroidConfig.create(viewComposition: widget.androidViewComposition)        ),
        onCreate: () {
          print("TestApp - THEOplayer - onCreate");
          player.addEventListener(PlayerEventTypes.SOURCECHANGE, (event) {
            print("_DEBUG: SOURCECHANGE received");
          });
          player.addEventListener(PlayerEventTypes.PLAYING, (event) {
            print("_DEBUG: PLAYING received");
          });
          player.addEventListener(PlayerEventTypes.PROGRESS, (event) {
            print("_DEBUG: PROGRESS received");
          });
          player.addEventListener(PlayerEventTypes.ERROR, (event) {
            print("_DEBUG: ERROR: ${(event as ErrorEvent).error}");
          });
          player.addEventListener(PlayerEventTypes.TIMEUPDATE, (event) {
            print("_DEBUG: TIMEUPDATE received");
          });
          player.addEventListener(PlayerEventTypes.CANPLAY, (event) {
            print("_DEBUG: CANPLAY received");
          });
          player.addEventListener(PlayerEventTypes.DURATIONCHANGE, (event) {
            print("_DEBUG: DURATIONCHANGE received");
          });
          player.addEventListener(PlayerEventTypes.LOADSTART, (event) {
            print("_DEBUG: LOADSTART received");
          });
          player.addEventListener(PlayerEventTypes.PLAY, (event) {
            print("_DEBUG: PLAY received");
          });
          player.addEventListener(PlayerEventTypes.PAUSE, (event) {
            print("_DEBUG: PAUSE received");
          });
          player.addEventListener(PlayerEventTypes.WAITING, (event) {
            print("_DEBUG: PAUSE received");
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
                        ChromelessPlayerView(key: const Key("testChromelessPlayer"), player: player),
                      ],

                    ),
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}
