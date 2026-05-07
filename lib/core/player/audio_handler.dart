import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class RadioAudioHandler extends BaseAudioHandler {
  final AudioPlayer _player = AudioPlayer();

  RadioAudioHandler() {
    _player.playingStream.listen((playing) {
      _updatePlaybackState(playing);
    });

    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.ready) {
        _updatePlaybackState(_player.playing);
      }
    });
  }

  void _updatePlaybackState(bool playing) {
    playbackState.add(
      PlaybackState(
        controls: [
          MediaControl.stop,
          if (playing) MediaControl.pause else MediaControl.play,
        ],
        androidCompactActionIndices: const [0, 1],
        processingState: AudioProcessingState.ready,
        playing: playing,
      ),
    );
  }

  Future<void> playUrl(String url, String title) async {
    mediaItem.add(
      MediaItem(
        id: url,
        title: title,
        album: 'Metal Radio',
        displayTitle: title,
        displaySubtitle: 'Metal Radio',
      ),
    );
    await _player.setUrl(url);
    await _player.play();
    // Forzar actualización del estado
    _updatePlaybackState(true);
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    playbackState.add(
      PlaybackState(
        controls: [MediaControl.play],
        processingState: AudioProcessingState.idle,
        playing: false,
      ),
    );
  }

  void dispose() => _player.dispose();
}
