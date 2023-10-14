import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:islamic_songs/data/datasource/static/colors.dart';
import 'package:islamic_songs/data/model/audiometadata.dart';
import 'package:islamic_songs/controller/controller.dart';

class LoopRow extends StatelessWidget {
  const LoopRow({
    super.key,
    required this.controller,
  });

  final MyController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StreamBuilder<LoopMode>(
          stream: controller.player.loopModeStream,
          builder: (context, snapshot) {
            final loopMode = snapshot.data ?? LoopMode.off;
            List<Icon> icons = [
              const Icon(Icons.repeat, color: Colors.white),
              Icon(Icons.repeat, color: AppColor.thirdColor),
              Icon(Icons.repeat_one, color: AppColor.thirdColor),
            ];
            const cycleModes = [
              LoopMode.off,
              LoopMode.all,
              LoopMode.one,
            ];
            final index = cycleModes.indexOf(loopMode);
            return IconButton(
              icon: icons[index],
              onPressed: () {
                controller.player.setLoopMode(cycleModes[
                    (cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
              },
            );
          },
        ),
        //  name and image
        Expanded(
          child: StreamBuilder<SequenceState?>(
            stream: controller.player.sequenceStateStream,
            builder: (context, snapshot) {
              final state = snapshot.data;
              if (state?.sequence.isEmpty ?? true) {
                return const SizedBox();
              }
              final metadata = state!.currentSource!.tag as AudioMetadata;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(metadata.album,
                      style: const TextStyle(color: Colors.white)),
                  Text(metadata.title,
                      style: const TextStyle(color: Colors.white)),
                ],
              );
            },
          ),
        ),
        StreamBuilder<bool>(
          stream: controller.player.shuffleModeEnabledStream,
          builder: (context, snapshot) {
            final shuffleModeEnabled = snapshot.data ?? false;
            return IconButton(
              icon: shuffleModeEnabled
                  ? Icon(Icons.shuffle, color: AppColor.thirdColor)
                  : const Icon(Icons.shuffle, color: Colors.white),
              onPressed: () async {
                final enable = !shuffleModeEnabled;
                if (enable) {
                  await controller.player.shuffle();
                }
                await controller.player.setShuffleModeEnabled(enable);
              },
            );
          },
        ),
      ],
    );
  }
}
