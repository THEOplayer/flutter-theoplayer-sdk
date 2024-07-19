import 'package:flutter/material.dart';
import 'package:theoplayer/theoplayer.dart';
import 'package:theoplayer_example/helpers/utils.dart';

class PlayButtonWidget extends StatefulWidget {
  const PlayButtonWidget({
    super.key,
    required this.player,
  });

  final THEOplayer player;

  @override
  State<StatefulWidget> createState() {
    return _PlayButtonWidgetState();
  }
}

class _PlayButtonWidgetState extends State<PlayButtonWidget> {
  bool playing = false;

  @override
  void initState() {
    super.initState();
    playing = !widget.player.isPaused();
    widget.player.addEventListener(PlayerEventTypes.PLAY, playEventListener);
    widget.player.addEventListener(PlayerEventTypes.PLAYING, playingEventListener);
    widget.player.addEventListener(PlayerEventTypes.PAUSE, pauseEventListener);
  }

  void playEventListener(Event event) {
    setState(() {
      playing = true;
    });
  }

  void playingEventListener(Event event) {
    setState(() {
      playing = true;
    });
  }

  void pauseEventListener(Event event) {
    setState(() {
      playing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return playing
        ? IconButton(
            enableFeedback: true,
            iconSize: 48,
            icon: const Icon(
              Icons.pause,
              color: theoYellow,
            ),
            onPressed: () => widget.player.pause(),
          )
        : IconButton(
            enableFeedback: true,
            iconSize: 48,
            icon: const Icon(Icons.play_arrow, color: theoYellow),
            onPressed: () => widget.player.play(),
          );
  }

  @override
  void dispose() {
    widget.player.removeEventListener(PlayerEventTypes.PLAY, playEventListener);
    widget.player.removeEventListener(PlayerEventTypes.PLAYING, playingEventListener);
    widget.player.removeEventListener(PlayerEventTypes.PAUSE, pauseEventListener);
    super.dispose();
  }
}
