import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:islamic_songs/controller/showsliderdialog.dart';

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.volume_up),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "الصوت",
                divisions: 10,
                min: 0.0,
                max: 1.0,
                value: player.volume,
                stream: player.volumeStream,
                onChanged: player.setVolume,
              );
            },
          ),
          StreamBuilder<SequenceState?>(
            stream: player.sequenceStateStream,
            builder: (context, snapshot) => IconButton(
              color: Colors.white,
              icon: const Icon(Icons.skip_previous),
              onPressed: player.hasPrevious ? player.seekToPrevious : null,
            ),
          ),
          StreamBuilder<PlayerState>(
            stream: player.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing;
              if (processingState == ProcessingState.loading ||
                  processingState == ProcessingState.buffering) {
                return Container(
                  margin: EdgeInsets.all(2.0.h),
                  width: 30.h,
                  height: 30.0.h,
                  child: const CircularProgressIndicator(color: Colors.white),
                );
              } else if (playing != true) {
                return IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.play_arrow),
                  iconSize: 30.r,
                  onPressed: player.play,
                );
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.pause),
                  iconSize: 30.r,
                  onPressed: player.pause,
                );
              } else {
                return IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.replay),
                  iconSize: 30.r,
                  onPressed: () => player.seek(Duration.zero,
                      index: player.effectiveIndices!.first),
                );
              }
            },
          ),
          StreamBuilder<SequenceState?>(
            stream: player.sequenceStateStream,
            builder: (context, snapshot) => IconButton(
              color: Colors.white,
              icon: const Icon(Icons.skip_next),
              onPressed: player.hasNext ? player.seekToNext : null,
            ),
          ),
          StreamBuilder<double>(
            stream: player.speedStream,
            builder: (context, snapshot) => IconButton(
              color: Colors.white,
              icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
              onPressed: () {
                showSliderDialog(
                  context: context,
                  title: "السرعة",
                  divisions: 10,
                  min: 0.30,
                  max: 2,
                  value: player.speed,
                  stream: player.speedStream,
                  onChanged: player.setSpeed,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
