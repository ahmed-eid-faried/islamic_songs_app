import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:islamic_songs/data/datasource/static/static.dart';
import 'package:islamic_songs/data/model/audiometadata.dart';
import 'package:islamic_songs/controller/showsliderdialog.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import 'package:get/get.dart' as getx;
import 'package:islamic_songs/data/model/position_data.dart';

class MyController extends getx.GetxController {
  late AudioPlayer player;
  final kplaylist = ConcatenatingAudioSource(children: [
    if (kIsWeb ||
        ![TargetPlatform.windows, TargetPlatform.linux]
            .contains(defaultTargetPlatform))
      ...playlist,
  ]);
  // int _addedCount = 0;
  final kscaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  Future<void> kinit() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      if (kDebugMode) {
        print('A stream error occurred: $e');
      }
    });
    try {
      // Preloading audio is not currently supported on Linux.
      await player.setAudioSource(kplaylist,
          preload: kIsWeb || defaultTargetPlatform != TargetPlatform.linux);
    } catch (e) {
      if (kDebugMode) {
        print("Error loading audio source: $e");
      }
    }
    // Show a snackbar whenever reaching the end of an item in the playlist.
    player.positionDiscontinuityStream.listen((discontinuity) {
      if (discontinuity.reason == PositionDiscontinuityReason.autoAdvance) {
        // _showItemFinished(discontinuity.previousEvent.currentIndex);
      }
    });
    player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        // _showItemFinished(player.currentIndex);
      }
    });
  }

  void showItemFinished(int? index) {
    if (index == null) return;
    final sequence = player.sequence;
    if (sequence == null) return;
    final source = sequence[index];
    final metadata = source.tag as AudioMetadata;
    kscaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text('Finished playing ${metadata.title}'),
      duration: const Duration(seconds: 1),
    ));
  }

  @override
  void onInit() {
    ambiguate(WidgetsBinding.instance)!.addObserver;
    player = AudioPlayer();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    kinit();
    // didChangeAppLifecycleState;
    super.onInit();
  }

  @override
  void dispose() {
    ambiguate(WidgetsBinding.instance)!
        .removeObserver(this as WidgetsBindingObserver);
    player.dispose();
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      player.stop();
    }
  }

  Stream<PositionData> get positionDataStream =>
      rxdart.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));
}
