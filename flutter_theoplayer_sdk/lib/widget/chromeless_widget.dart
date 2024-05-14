import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:theoplayer/theoplayer.dart';
import 'package:theoplayer/widget/presentationmode_aware_widget.dart';

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
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PresentationModeAwareWidget(player: widget.player, presentationModeToCheck: const [PresentationMode.INLINE]);
  }
}
