import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/radio_provider.dart';
import '../providers/favorites_provider.dart';
import '../../core/player/radio_player.dart';
//import 'package:media_kit/media_kit.dart';

class RadiosView extends ConsumerWidget {
  const RadiosView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final radios = ref.watch(radiosProvider);
    final player = ref.read(radioPlayerProvider.notifier);
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Metal Radios')),
      body: radios.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (list) => ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, i) {
            final r = list[i];

            final isFav = favorites.any((f) => f.url == r.url);

            return ListTile(
              title: Text(r.name),
              trailing: IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
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
      ),
    );
  }
}