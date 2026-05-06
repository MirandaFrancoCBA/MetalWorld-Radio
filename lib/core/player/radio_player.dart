import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_service/audio_service.dart';
import '../../main.dart';

class RadioPlayerState {
  final bool playing;
  final String? currentTitle;

  RadioPlayerState({
    required this.playing,
    this.currentTitle,
  });

  RadioPlayerState copyWith({
    bool? playing,
    String? currentTitle,
  }) {
    return RadioPlayerState(
      playing: playing ?? this.playing,
      currentTitle: currentTitle ?? this.currentTitle,
    );
  }
}

class RadioPlayerNotifier extends StateNotifier<RadioPlayerState> {
  RadioPlayerNotifier() : super(RadioPlayerState(playing: false)) {
    // 🔥 Escuchamos el estado REAL del audio handler
    audioHandler.playbackState.listen((playback) {
      state = state.copyWith(playing: playback.playing);
    });
  }

  Future<void> play(String url, String title) async {
    final item = MediaItem(
      id: url,
      title: title,
      album: "Metal Radio",
    );

    await audioHandler.playMediaItem(item);

    state = state.copyWith(currentTitle: title);
  }

  Future<void> pause() => audioHandler.pause();

  Future<void> stop() async {
    await audioHandler.stop();
    state = state.copyWith(currentTitle: null);
  }
}

final radioPlayerProvider =
    StateNotifierProvider<RadioPlayerNotifier, RadioPlayerState>((ref) {
  return RadioPlayerNotifier();
});