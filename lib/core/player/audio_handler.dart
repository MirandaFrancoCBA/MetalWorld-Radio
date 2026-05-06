import 'package:audio_service/audio_service.dart';
import 'package:media_kit/media_kit.dart';

class MyAudioHandler extends BaseAudioHandler {
  final Player player = Player();

  MyAudioHandler() {
    // Estado inicial
    playbackState.add(
      PlaybackState(
        controls: [MediaControl.play],
        playing: false,
        processingState: AudioProcessingState.idle,
      ),
    );

    // Escuchar cambios reales del player
    player.stream.playing.listen((playing) {
      playbackState.add(
        PlaybackState(
          controls: [
            MediaControl.stop,
            if (playing) MediaControl.pause else MediaControl.play,
          ],
          playing: playing,
          processingState: AudioProcessingState.ready,
        ),
      );
    });
  }

  @override
  Future<void> playMediaItem(MediaItem item) async {
    mediaItem.add(item);

    await player.open(
      Media(item.id),
      play: true,
    );
  }

  @override
  Future<void> play() => player.play();

  @override
  Future<void> pause() => player.pause();

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