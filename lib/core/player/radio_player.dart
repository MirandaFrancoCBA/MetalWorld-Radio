import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'audio_handler.dart';

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
  final RadioAudioHandler _handler;

  RadioPlayerNotifier(this._handler) : super(RadioPlayerState(playing: false)) {
    _handler.playbackState.listen((pb) {
      state = state.copyWith(playing: pb.playing);
    });
  }

  Future<void> play(String url, String title) async {
    await _handler.playUrl(url, title);
    state = state.copyWith(currentTitle: title, currentUrl: url);
  }

  Future<void> pause() => _handler.pause();

  Future<void> stop() async {
    await _handler.stop();
    state = state.copyWith(currentTitle: null, currentUrl: null);
  }
}

final audioHandlerProvider = Provider<RadioAudioHandler>((ref) {
  final handler = RadioAudioHandler();
  ref.onDispose(() => handler.dispose());
  return handler;
});

final radioPlayerProvider =
    StateNotifierProvider<RadioPlayerNotifier, RadioPlayerState>((ref) {
  final handler = ref.watch(audioHandlerProvider);
  return RadioPlayerNotifier(handler);
});