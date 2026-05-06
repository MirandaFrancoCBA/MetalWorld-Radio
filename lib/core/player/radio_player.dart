import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';

class RadioPlayerState {
  final bool playing;
  final String? currentTitle;
  final String? currentUrl;

  RadioPlayerState({required this.playing, this.currentTitle, this.currentUrl});

  RadioPlayerState copyWith({bool? playing, String? currentTitle, String? currentUrl}) {
    return RadioPlayerState(
      playing: playing ?? this.playing,
      currentTitle: currentTitle ?? this.currentTitle,
      currentUrl: currentUrl ?? this.currentUrl,
    );
  }
}

class RadioPlayerNotifier extends StateNotifier<RadioPlayerState> {
  final Player _player = Player();

  RadioPlayerNotifier() : super(RadioPlayerState(playing: false)) {
    _player.stream.playing.listen((playing) {
      state = state.copyWith(playing: playing);
    });
  }

  Future<void> play(String url, String title) async {
    await _player.open(Media(url), play: true);
    state = state.copyWith(currentTitle: title, currentUrl: url);
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> stop() async {
    await _player.stop();
    state = state.copyWith(currentTitle: null);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}

final radioPlayerProvider =
    StateNotifierProvider<RadioPlayerNotifier, RadioPlayerState>((ref) {
  return RadioPlayerNotifier();
});