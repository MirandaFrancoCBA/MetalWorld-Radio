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
      backgroundColor: const Color(0xFF0A0A0A),
      body: Column(
        children: [
          Expanded(child: pages[index]),
          const _MiniPlayer(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        backgroundColor: const Color(0xFF111111),
        selectedItemColor: const Color(0xFFCC0000),
        unselectedItemColor: Colors.grey,
        onTap: (value) => setState(() => index = value),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.radio),
            label: 'Radios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_bar),
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
      decoration: const BoxDecoration(
        color: Color(0xFF1A0000),
        border: Border(
          top: BorderSide(color: Color(0xFFCC0000), width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 70,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: state.playing
                  ? const Color(0xFFCC0000)
                  : const Color(0xFF333333),
            ),
            child: Icon(
              state.playing ? Icons.graphic_eq : Icons.radio,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.currentTitle!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  state.playing ? '▶ EN VIVO' : '⏸ PAUSADO',
                  style: TextStyle(
                    color: state.playing
                        ? const Color(0xFFCC0000)
                        : Colors.grey,
                    fontSize: 10,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              state.playing ? Icons.pause_circle : Icons.play_circle,
              color: const Color(0xFFCC0000),
              size: 36,
            ),
            onPressed: () => state.playing
                ? notifier.pause()
                : notifier.play(state.currentUrl!, state.currentTitle!),
          ),
          IconButton(
            icon: const Icon(Icons.stop_circle, color: Colors.grey, size: 30),
            onPressed: () => notifier.stop(),
          ),
        ],
      ),
    );
  }
}