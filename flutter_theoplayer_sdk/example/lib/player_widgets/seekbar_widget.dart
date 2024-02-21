import 'package:flutter/material.dart';
import 'package:theoplayer/theoplayer.dart';
import 'package:theoplayer_example/helpers/utils.dart';

class SeekbarWidget extends StatefulWidget {
  //this triggers underlying seek on the player ---> can show the new frame where you drag
  final bool seekWhileDragging;

  const SeekbarWidget({
    super.key,
    required this.player,
    this.seekWhileDragging = false
  });

  final THEOplayer player;

  @override
  State<StatefulWidget> createState() {
    return _SeekbarWidgetWidgetState();
  }
}

class _SeekbarWidgetWidgetState extends State<SeekbarWidget> {
  double position = 0.0;
  double duration = 0.0;

  bool dragging = false;

  void timeUpdateListener(Event event) {
    if (dragging) {
      return;
    }

    setState(() {
      position = widget.player.getCurrentTime();
    });
  }

  void durartionChangeListener(Event event) {
    setState(() {
      duration = widget.player.getDuration();
    });
  }

  @override
  void initState() {
    super.initState();
    position = widget.player.getCurrentTime();
    duration = widget.player.getDuration();

    widget.player.addEventListener(PlayerEventTypes.TIMEUPDATE, timeUpdateListener);
    widget.player.addEventListener(PlayerEventTypes.DURATIONCHANGE, durartionChangeListener);
  }

  @override
  void dispose() {
    widget.player.removeEventListener(PlayerEventTypes.TIMEUPDATE, timeUpdateListener);
    widget.player.removeEventListener(PlayerEventTypes.DURATIONCHANGE, durartionChangeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: position,
      min: 0,
      max: duration,
      activeColor: theoYellow,
      label: "${position.round()}",
      onChanged: (newPosition) {
        if (widget.seekWhileDragging) {
          widget.player.setCurrentTime(newPosition);
        }
        setState(() {
          position = newPosition;
        });
      },
      onChangeStart: (currentPosition) {
        dragging = true;
      },
      onChangeEnd: (newPosition) {
        dragging = false;
        widget.player.setCurrentTime(newPosition);
      },
    );
  }
}
