import 'package:flutter/material.dart';
import 'package:theoplayer/theoplayer.dart';

class CurrentTimeWidget extends StatefulWidget {
  const CurrentTimeWidget({
    super.key,
    required this.player,
  });

  final THEOplayer player;
  
  @override
  State<StatefulWidget> createState() {
    return _CurrentTimeWidgetState();
  }

}

class _CurrentTimeWidgetState extends State<CurrentTimeWidget> {

  @override
  void initState() {
    super.initState();
    widget.player.setStateListener(() {
        setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text('Current time: ${widget.player.getCurrentTime()}');
  }
}
