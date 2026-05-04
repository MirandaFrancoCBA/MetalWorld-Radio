import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/favorites_provider.dart';
import '../../core/player/radio_player.dart';
//import 'package:media_kit/media_kit.dart';

class FavoritesView extends ConsumerWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final player = ref.read(radioPlayerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                'No tenés favoritos todavía',
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, i) {
                final r = favorites[i];

                return ListTile(
                  title: Text(r.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      ref.read(favoritesProvider.notifier).toggle(r);
                    },
                  ),
                  onTap: () async {
                    await player.play(r.url, r.name);
                  },
                );
              },
            ),
    );
  }
}