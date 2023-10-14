import 'package:flutter/material.dart';
import 'package:islamic_songs/controller/controller.dart';
import 'package:islamic_songs/data/model/position_data.dart';
import 'package:islamic_songs/data/model/seekbar.dart';

class SeekBarWdget extends StatelessWidget {
  const SeekBarWdget({
    super.key,
    required this.controller,
  });

  final MyController controller;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PositionData>(
      stream: controller.positionDataStream,
      builder: (context, snapshot) {
        final positionData = snapshot.data;
        return SeekBar(
          duration: positionData?.duration ?? Duration.zero,
          position: positionData?.position ?? Duration.zero,
          bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
          onChangeEnd: (newPosition) {
            controller.player.seek(newPosition);
          },
        );
      },
    );
  }
}
