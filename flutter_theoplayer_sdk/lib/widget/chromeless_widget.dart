import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:theoplayer/theoplayer.dart';

class ChromelessPlayerView extends StatefulWidget {
  
  const ChromelessPlayerView({
    super.key,
    required this.player,
  });

  final THEOplayer player;

  @override
  State<StatefulWidget> createState() {
    return _ChromelessPlayerViewState();
  }
}

class _ChromelessPlayerViewState extends State<ChromelessPlayerView> {
  
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
    return presentationMode == PresentationMode.INLINE ? widget.player.getView() : Container(color: Colors.black,);
  }

}
