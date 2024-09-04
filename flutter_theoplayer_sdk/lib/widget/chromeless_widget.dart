import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
    List<PresentationMode> presentationModeToCheck = [PresentationMode.INLINE];
    if (kIsWeb || Platform.isIOS) {
      // on web we don't present an extra PresentationModeAwareWidget for PIP, so the current one has to be aware of PIP mode,
      // otherwise the THEOplayerView will be disposed
      presentationModeToCheck.add(PresentationMode.PIP);
    }
    return PresentationModeAwareWidget(player: widget.player, presentationModeToCheck: presentationModeToCheck);
  }
}
