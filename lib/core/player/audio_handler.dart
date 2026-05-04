import 'package:audio_service/audio_service.dart';
import 'radio_player.dart';

class MyAudioHandler extends BaseAudioHandler {
  final RadioPlayerNotifier player;

  MyAudioHandler(this.player) {
    // Estado inicial
    playbackState.add(
      PlaybackState(
        controls: [MediaControl.play],
        playing: false,
        processingState: AudioProcessingState.idle,
      ),
    );
  }

  @override
  Future<void> playMediaItem(MediaItem mediaItem) async {
    this.mediaItem.add(mediaItem);

    await player.play(mediaItem.id, mediaItem.title);

    playbackState.add(
      PlaybackState(
        controls: [MediaControl.stop, MediaControl.pause],
        playing: true,
        processingState: AudioProcessingState.ready,
      ),
    );
  }

  @override
  Future<void> play() async {
    await player.player.play();
  }

  @override
  Future<void> pause() async {
    await player.pause();
  }

  @override
  Future<void> stop() async {
    await player.stop();

    playbackState.add(
      PlaybackState(
        controls: [MediaControl.play],
        playing: false,
        processingState: AudioProcessingState.idle,
      ),
    );
  }
}