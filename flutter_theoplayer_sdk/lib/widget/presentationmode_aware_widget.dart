import 'package:flutter/material.dart';
import 'package:theoplayer/theoplayer.dart';

/// Internal PresentationMode aware widget to make sure the view is removed from the hierarchy before transitions are happening.
/// Android and Web are ok, but iOS doesn't remove the view in time when switching between presentation modes.
class PresentationModeAwareWidget extends StatefulWidget {
  const PresentationModeAwareWidget({
    super.key,
    required this.player,
    required this.presentationModeToCheck,
  });

  final THEOplayer player;
  final List<PresentationMode> presentationModeToCheck;

  @override
  State<StatefulWidget> createState() {
    return _PresentationModeAwareWidgetState();
  }
}

class _PresentationModeAwareWidgetState extends State<PresentationModeAwareWidget> {
  late PresentationMode presentationMode;

  void _presentationModeChangeEventListener(event) {
    setState(() {
      presentationMode = (event as PresentationModeChangeEvent).presentationMode;
    });
  }

  @override
  void initState() {
    super.initState();
    presentationMode = widget.player.getPresentationMode();
    widget.player.addEventListener(PlayerEventTypes.PRESENTATIONMODECHANGE, _presentationModeChangeEventListener);
  }

  @override
  void dispose() {
    widget.player.removeEventListener(PlayerEventTypes.PRESENTATIONMODECHANGE, _presentationModeChangeEventListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.black, child: widget.presentationModeToCheck.contains(presentationMode) ? widget.player.getView() : Container());
  }
}
