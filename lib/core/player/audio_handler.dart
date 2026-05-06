import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class RadioAudioHandler extends BaseAudioHandler {
  final AudioPlayer _player = AudioPlayer();

  RadioAudioHandler() {
    _player.playingStream.listen((playing) {
      playbackState.add(playbackState.value.copyWith(
        playing: playing,
        controls: [
          MediaControl.stop,
          if (playing) MediaControl.pause else MediaControl.play,
        ],
        processingState: AudioProcessingState.ready,
      ));
    });
  }

  Future<void> playUrl(String url, String title) async {
    mediaItem.add(MediaItem(id: url, title: title, album: 'Metal Radio'));
    await _player.setUrl(url);
    await _player.play();
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    playbackState.add(playbackState.value.copyWith(
      playing: false,
      processingState: AudioProcessingState.idle,
    ));
  }

  void dispose() => _player.dispose();
}