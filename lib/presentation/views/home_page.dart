import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'radios_view.dart';
import 'favorites_view.dart';
import '../../core/player/radio_player.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int index = 0;

  final pages = const [RadiosView(), FavoritesView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: pages[index]),
          const _MiniPlayer(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) => setState(() => index = value),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.radio), label: 'Radios'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }
}

class _MiniPlayer extends ConsumerWidget {
  const _MiniPlayer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(radioPlayerProvider);
    final notifier = ref.read(radioPlayerProvider.notifier);

    if (state.currentTitle == null) return const SizedBox();

    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 60,
      child: Row(
        children: [
          Expanded(
            child: Text(
              state.currentTitle!,
              style: const TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: Icon(
              state.playing ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
            onPressed: () => state.playing
                ? notifier.pause()
                : notifier.play(state.currentUrl!, state.currentTitle!),
          ),
          IconButton(
            icon: const Icon(Icons.stop, color: Colors.red),
            onPressed: () => notifier.stop(),
          ),
        ],
      ),
    );
  }
}
