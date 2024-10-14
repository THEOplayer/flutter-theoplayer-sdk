import 'package:flutter/material.dart';
import 'package:theoplayer/theoplayer.dart';

/// Widget that adapts to the aspect ratio of the video
/// Use it when AndroidViewComposition is Texture-based ([AndroidViewComposition.SURFACE_TEXTURE]/[AndroidViewComposition.SURFACE_PRODUCER])
/// With Hybrid-composition this is done on the native side.
class AspectRatioChromelessPlayerView extends StatefulWidget {
  const AspectRatioChromelessPlayerView({
    super.key,
    required this.player,
    this.initialAspectRatio,
    this.continuouslyFollowAspectRatioChanges = false,
  });

  final THEOplayer player;
  final double? initialAspectRatio;
  final bool continuouslyFollowAspectRatioChanges;

  @override
  State<StatefulWidget> createState() {
    return _AspectRatioChromelessPlayerViewState();
  }
}

class _AspectRatioChromelessPlayerViewState extends State<AspectRatioChromelessPlayerView> {

  double? currentAspectRatio;

  @override
  void initState() {
    super.initState();
    var initialVideoWidth = widget.player.getVideoWidth();
    var initialVideoHeight = widget.player.getVideoHeight();
    if (initialVideoWidth != 0 && initialVideoHeight != 0) {
      currentAspectRatio = initialVideoWidth / initialVideoHeight;
    }
    currentAspectRatio ??= widget.initialAspectRatio;

    _attachResizeEventListener();
    widget.player.addEventListener(PlayerEventTypes.SOURCECHANGE, _sourceChangeEventListener);

  }

  @override
  void dispose() {
    _detatchResizeEventListener();
    widget.player.removeEventListener(PlayerEventTypes.SOURCECHANGE, _sourceChangeEventListener);
    super.dispose();
  }

  void _resizeEventListener(event) {
    var resizeEvent = (event as ResizeEvent);

    // we are not interested in monitoring the following size changes after the first one
    if (!widget.continuouslyFollowAspectRatioChanges) {
      _detatchResizeEventListener();
    }

    setState(() {
      currentAspectRatio = resizeEvent.width / resizeEvent.height;
    });

  }

  void _sourceChangeEventListener(event) {
    // if we not continuously monitoring the state, reattach it after the source change to capture the new aspect ratio
    if (!widget.continuouslyFollowAspectRatioChanges) {
      _attachResizeEventListener();
    }
  }

  void _attachResizeEventListener() {
    widget.player.addEventListener(PlayerEventTypes.RESIZE, _resizeEventListener);
  }

  void _detatchResizeEventListener() {
    widget.player.removeEventListener(PlayerEventTypes.RESIZE, _resizeEventListener);
  }

  @override
  Widget build(BuildContext context) {
    if (currentAspectRatio != null) {
      return Container(color: Colors.black, child: Align(alignment: Alignment.center, child: AspectRatio(aspectRatio: currentAspectRatio!, child: ChromelessPlayerView(player: widget.player))));
    } else {
      return ChromelessPlayerView(player: widget.player);
    }

  }
}