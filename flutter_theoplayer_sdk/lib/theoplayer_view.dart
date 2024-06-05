import 'package:flutter/material.dart';
import 'package:theoplayer_platform_interface/theoplayer_platform_interface.dart';
import 'package:theoplayer_platform_interface/theopalyer_config.dart';
import 'package:theoplayer_platform_interface/helpers/logger.dart';

//TODO: move this into theoplayer.dart (?)

/// Internal Flutter representation of the underlying native THEOplayer views.
/// Use [THEOplayer] to initialize it.
class THEOplayerView extends StatefulWidget {
  final THEOplayerConfig theoPlayerConfig;
  final THEOplayerViewCreatedCallback onCreated;

  const THEOplayerView({Key? key, required this.theoPlayerConfig, required this.onCreated}) : super(key: key);

  @override
  State<THEOplayerView> createState() => _THEOplayerViewState();
}

class _THEOplayerViewState extends State<THEOplayerView> {

  bool loaded = false;
  int textureId = -1;

  @override
  initState() {
    super.initState();
    TheoplayerPlatform.instance.initalize(widget.theoPlayerConfig, (playerId){
      setState(() {
        debugLog("[THEOplayerView] Native initialized callback: $playerId");
        textureId = playerId;
        loaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    debugLog("[THEOplayerView] loaded: $loaded");
    return loaded ? TheoplayerPlatform.instance.buildView(context, widget.theoPlayerConfig, widget.onCreated, textureId) : Container();
  }
}
