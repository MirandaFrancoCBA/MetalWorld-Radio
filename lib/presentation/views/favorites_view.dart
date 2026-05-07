import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/favorites_provider.dart';
import '../../core/player/radio_player.dart';

class FavoritesView extends ConsumerWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              'FAVORITOS',
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
      body: favorites.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.music_off, color: Colors.grey, size: 64),
                  SizedBox(height: 16),
                  Text(
                    'NO HAY FAVORITOS',
                    style: TextStyle(
                      color: Colors.grey,
                      letterSpacing: 3,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: favorites.length,
              itemBuilder: (context, i) {
                final r = favorites[i];
                final isPlaying =
                    playerState.currentUrl == r.url && playerState.playing;

                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                              errorWidget: (_, __, ___) =>
                                  _defaultIcon(isPlaying),
                            )
                          : _defaultIcon(isPlaying),
                    ),
                    title: Text(
                      r.name,
                      style: TextStyle(
                        color:
                            isPlaying ? const Color(0xFFCC0000) : Colors.white,
                        fontWeight:
                            isPlaying ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.grey),
                      onPressed: () =>
                          ref.read(favoritesProvider.notifier).toggle(r),
                    ),
                    onTap: () => ref
                        .read(radioPlayerProvider.notifier)
                        .play(r.url, r.name),
                  ),
                );
              },
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