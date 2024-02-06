import 'package:flutter/material.dart';
import 'package:theoplayer/theoplayer.dart';

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

    player = THEOplayer(
        theoPlayerConfig: THEOplayerConfig(
          license: "sZP7IYe6T6PeISfZ3QBr0Ozt3lg6FSa_IuC-TSeo0ZzL0QP1ISUKTD313Kh6FOPlUY3zWokgbgjNIOf9flIKCLh_3ufZFSxlISB-3uXgCZzr0SfZFS0t3l5t3Qfz0l5cCmfVfK4_bQgZCYxNWoryIQXzImf90Sbk0Sft3LCi0u5i0Oi6Io4pIYP1UQgqWgjeCYxgflEc3L5t0l0Z0ufk3SbrFOPeWok1dDrLYtA1Ioh6TgV6v6fVfKcqCoXVdQjLUOfVfGxEIDjiWQXrIYfpCoj-fgzVfKxqWDXNWG3ybojkbK3gflNWfKcqCoXVdQjLUOfVfGxEIDjiWQXrIYfpCoj-fgzVfG3edt06TgV6dwx-Wuh6FOP1WKxZWogef6i6CDrebKjNIwxof6i6IKgZIYxof6i6dDjLf6i6UQg9ID_6FOPzUKjLf6i6Uo46Wt06Ymi6bo4pIXjNWYAZIY3LdDjpflNzbG4gFOPKIDXzUYPgbZf9Dkkj",
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
