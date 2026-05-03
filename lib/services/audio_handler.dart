// ignore_for_file: avoid_renaming_method_parameters

import 'package:audio_service/audio_service.dart';
import 'package:media_kit/media_kit.dart';
import 'package:flutter/foundation.dart';

class MyAudioHandler extends BaseAudioHandler with SeekHandler {
  final Player _player = Player();

  MyAudioHandler() {
    // Escuchar estado del player
    _player.stream.playing.listen((playing) {
      playbackState.add(_buildState(playing));
    });
  }

  @override
  Future<void> playMediaItem(MediaItem item) async {
    mediaItem.add(item);

    try {
      await _player.open(
        Media(item.id), // 🔥 acá va la URL
        play: true,
      );
    } catch (e) {
      debugPrint("URL: ${item.id}");
      debugPrint("Error de streaming: $e");
    }
  }

  @override
  Future<void> play() async {
    await _player.play();
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> stop() async {
    await _player.stop();
  }

  PlaybackState _buildState(bool playing) {
    return PlaybackState(
      controls: [
        MediaControl.stop,
        if (playing) MediaControl.pause else MediaControl.play,
      ],
      playing: playing,
      processingState: AudioProcessingState.ready,
    );
  }
}