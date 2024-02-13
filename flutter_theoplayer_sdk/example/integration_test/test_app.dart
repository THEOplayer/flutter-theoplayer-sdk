import 'package:flutter/material.dart';
import 'package:theoplayer/theoplayer.dart';

// Test license to load sources from localhost and theoplayer.com domains
const TEST_LICENSE = String.fromEnvironment("TEST_LICENSE", defaultValue: "");

class TestApp extends StatefulWidget {
  const TestApp({super.key});

  @override
  State<TestApp> createState() => _TestAppState();
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
          androidConfiguration: AndroidConfig(useHybridComposition: true)        ),
        onCreate: () {
          print("TestApp - THEOplayer - onCreate");
          player.addEventListener(PlayerEventTypes.SOURCECHANGE, (event) { 
            print("SOURCECHANGE received");
          });
          player.addEventListener(PlayerEventTypes.PLAYING, (event) { 
            print("PLAYING received");
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
                        ChromelessPlayer(key: const Key("testChromelessPlayer"), player: player),
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
