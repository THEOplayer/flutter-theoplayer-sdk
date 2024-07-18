import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:theoplayer/theoplayer.dart';
import 'package:theoplayer/widget/presentationmode_aware_widget.dart';

/// Copy of the [FullscreenStatefulWidget] and spiced-up with basic aspect ratio configuration.
/// Note: not listening to changes and assumes that the player is already playing a video when displaying this widget
/// TODO: extract common logic from AspectRatioCustomFullscreenWidget and AspectRatioChromelessPlayerView
/// TODO: make this a player feature
/// 
class AspectRatioCustomFullscreenWidget extends StatefulWidget {
  final THEOplayer theoplayer;

  final FullscreenConfig fullscreenConfig;

  const AspectRatioCustomFullscreenWidget({super.key, required this.theoplayer, required this.fullscreenConfig});

  @override
  State<AspectRatioCustomFullscreenWidget> createState() => _FullscreenStatefulWidgetState();
}

class _FullscreenStatefulWidgetState extends State<AspectRatioCustomFullscreenWidget> {
  bool willPop = false;

  double currentAspectRatio = 16/9;

  @override
  void initState() {

    super.initState();
    var initialVideoWidth = widget.theoplayer.getVideoWidth();
    var initialVideoHeight = widget.theoplayer.getVideoHeight();
    if (initialVideoWidth != 0 && initialVideoHeight != 0) {
      currentAspectRatio = initialVideoWidth / initialVideoHeight;
    }

    SystemChrome.setPreferredOrientations(widget.fullscreenConfig.preferredFullscreenOrientations).then((value) => {
      SystemChrome.setEnabledSystemUIMode(widget.fullscreenConfig.fullscreenSystemUiMode)
    });

  }

  @override
  Widget build(BuildContext context) {
    return CustomWillPopScope(onWillPop: () async {
      setState(() {
        willPop = true;
      });
      return true;
    }, child: Scaffold(
      body: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          //check orientation variable to identify the current mode
          //double w = MediaQuery.of(context).size.width;
          //double h = MediaQuery.of(context).size.height;
          //bool landscape = false;

          return Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: !willPop
                ? Container(
                color: Colors.black,
                child: Align(
                  alignment: Alignment.center,
                  child: AspectRatio(
                    aspectRatio: currentAspectRatio,
                    child: PresentationModeAwareWidget(
                      player: widget.theoplayer,
                      presentationModeToCheck: const [PresentationMode.FULLSCREEN],
                    ),
                  ),
                ))
                : Container(),
          );
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    ));
  }
}

// Custom WillPopScope, because the original WillPopScope breaks the back navigation on iOS
class CustomWillPopScope extends StatelessWidget {
  const CustomWillPopScope({required this.child, required this.onWillPop, Key? key}) : super(key: key);

  final Widget child;
  final WillPopCallback onWillPop;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      if (Platform.isIOS) {
        return GestureDetector(
            onPanUpdate: (details) async {
              if (details.delta.dx > 0) {
                if (await onWillPop()) {
                  Navigator.of(context).pop();
                }
              }
            },
            child: WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: child,
            ));
      }
    }
    return WillPopScope(onWillPop: onWillPop, child: child);
  }
}
