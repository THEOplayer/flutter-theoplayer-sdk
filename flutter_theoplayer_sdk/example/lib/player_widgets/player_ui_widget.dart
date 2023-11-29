import 'package:flutter/material.dart';
import 'package:theoplayer/theoplayer.dart';
import 'package:theoplayer_example/player_widgets/play_button_widget.dart';
import 'package:theoplayer_example/player_widgets/quality_change_widget.dart';
import 'package:theoplayer_example/player_widgets/seekbar_widget.dart';

class PlayerUI extends StatelessWidget {
  const PlayerUI({
    super.key,
    required this.player,
  });

  final THEOplayer player;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Container()),
        Align(
          alignment: Alignment.center,
          child: PlayButtonWidget(player: player)
        ),
        Expanded( 
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: SeekbarWidget(player: player, seekWhileDragging: false,)),
                QualityChangeWidget(player: player),
              ],
            )
          ),
        ),
      ],
    );
  }
}