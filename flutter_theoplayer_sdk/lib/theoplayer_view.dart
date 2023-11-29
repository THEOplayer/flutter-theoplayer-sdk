import 'package:flutter/material.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/theoplayer_platform_interface.dart';
import 'package:flutter_theoplayer_sdk_platform_interface/theopalyer_config.dart';

class THEOplayerView extends StatefulWidget {
  final THEOplayerConfig theoPlayerConfig;
  final THEOplayerViewCreatedCallback onCreated;

  const THEOplayerView({Key? key, required this.theoPlayerConfig, required this.onCreated}) : super(key: key);

  @override
  State<THEOplayerView> createState() => _THEOplayerViewState();
}

class _THEOplayerViewState extends State<THEOplayerView> {
  @override
  Widget build(BuildContext context) {
    return TheoplayerPlatform.instance.buildView(context, widget.theoPlayerConfig, widget.onCreated);
  }
}
