import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/radio_provider.dart';
import '../providers/favorites_provider.dart';
import '../../core/player/radio_player.dart';

class RadiosView extends ConsumerWidget {
  const RadiosView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final radios = ref.watch(radiosProvider);
    final favorites = ref.watch(favoritesProvider);
    final playerState = ref.watch(radioPlayerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        title: const Row(
          children: [
            Icon(Icons.bolt, color: Color(0xFFCC0000)),
            SizedBox(width: 8),
            Text(
              'METAL RADIO',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 3,
                fontSize: 18,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFCC0000)),
        ),
      ),
      body: radios.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFFCC0000)),
        ),
        error: (e, _) => Center(
          child: Text('Error: $e', style: const TextStyle(color: Colors.red)),
        ),
        data: (list) => ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: list.length,
          itemBuilder: (context, i) {
            final r = list[i];
            final isFav = favorites.any((f) => f.url == r.url);
            final isPlaying = playerState.currentUrl == r.url && playerState.playing;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isPlaying
                    ? const Color(0xFF1A0000)
                    : const Color(0xFF141414),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isPlaying
                      ? const Color(0xFFCC0000)
                      : const Color(0xFF222222),
                ),
              ),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: r.favicon.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: r.favicon,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => _defaultIcon(isPlaying),
                        )
                      : _defaultIcon(isPlaying),
                ),
                title: Text(
                  r.name,
                  style: TextStyle(
                    color: isPlaying ? const Color(0xFFCC0000) : Colors.white,
                    fontWeight: isPlaying ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
                subtitle: isPlaying
                    ? const Text(
                        '▶ EN VIVO',
                        style: TextStyle(
                          color: Color(0xFFCC0000),
                          fontSize: 10,
                          letterSpacing: 2,
                        ),
                      )
                    : null,
                trailing: IconButton(
                  icon: Icon(
                    isFav ? Icons.sports_esports : Icons.sports_esports_outlined,
                    color: isFav ? const Color(0xFFCC0000) : Colors.grey,
                  ),
                  onPressed: () =>
                      ref.read(favoritesProvider.notifier).toggle(r),
                ),
                onTap: () =>
                    ref.read(radioPlayerProvider.notifier).play(r.url, r.name),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _defaultIcon(bool isPlaying) {
    return Container(
      width: 40,
      height: 40,
      color: const Color(0xFF1A1A1A),
      child: Icon(
        Icons.radio,
        color: isPlaying ? const Color(0xFFCC0000) : Colors.grey,
        size: 20,
      ),
    );
  }
}