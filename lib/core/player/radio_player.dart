import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';

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
  final Player player = Player();

  RadioPlayerNotifier() : super(RadioPlayerState(playing: false)) {
    player.stream.playing.listen((playing) {
      state = state.copyWith(playing: playing);
    });
  }

  Future<void> play(String url, String title) async {
    await player.open(Media(url), play: true);
    state = state.copyWith(currentTitle: title);
  }

  Future<void> pause() => player.pause();

  Future<void> stop() async {
    await player.stop();
    state = state.copyWith(currentTitle: null);
  }
}

final radioPlayerProvider =
    StateNotifierProvider<RadioPlayerNotifier, RadioPlayerState>((ref) {
  final notifier = RadioPlayerNotifier();
  ref.onDispose(() => notifier.player.dispose());
  return notifier;
});