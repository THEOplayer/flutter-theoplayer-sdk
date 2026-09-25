import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:theoplayer/theoplayer.dart';

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

  double currentAspectRatio = 16 / 9;

  @override
  void initState() {
    super.initState();
    var initialVideoWidth = widget.theoplayer.videoWidth;
    var initialVideoHeight = widget.theoplayer.videoHeight;
    if (initialVideoWidth != 0 && initialVideoHeight != 0) {
      currentAspectRatio = initialVideoWidth / initialVideoHeight;
    }

    SystemChrome.setPreferredOrientations(widget.fullscreenConfig.preferredFullscreenOrientations)
        .then((value) => {SystemChrome.setEnabledSystemUIMode(widget.fullscreenConfig.fullscreenSystemUiMode)});
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
class CustomWillPopScope extends StatefulWidget {
  const CustomWillPopScope({required this.child, required this.onWillPop, Key? key}) : super(key: key);

  final Widget child;
  final Future<bool> Function() onWillPop;

  @override
  State<CustomWillPopScope> createState() => _CustomWillPopScopeState();
}

class _CustomWillPopScopeState extends State<CustomWillPopScope> {
  bool _canPop = false;

  Future<void> _handlePop() async {
    if (!await widget.onWillPop() || !mounted) {
      return;
    }
    setState(() {
      _canPop = true;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final popScope = PopScope(
      canPop: _canPop,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          await _handlePop();
        }
      },
      child: widget.child,
    );
    if (!kIsWeb && Platform.isIOS) {
      return GestureDetector(
        onPanUpdate: (details) async {
          if (details.delta.dx > 0) {
            await _handlePop();
          }
        },
        child: popScope,
      );
    }
    return popScope;
  }
}
