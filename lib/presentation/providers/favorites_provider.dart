import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/radio_station.dart';
import '../../data/services/favorites_service.dart';

final favoritesServiceProvider = Provider((ref) => FavoritesService());

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<RadioStation>>((ref) {
  return FavoritesNotifier(ref);
});

class FavoritesNotifier extends StateNotifier<List<RadioStation>> {
  final Ref ref;

  FavoritesNotifier(this.ref) : super([]) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final favs =
        await ref.read(favoritesServiceProvider).getFavorites();
    state = favs;
  }

  Future<void> toggle(RadioStation radio) async {
    await ref.read(favoritesServiceProvider).toggleFavorite(radio);
    await loadFavorites();
  }

  bool isFavorite(String url) {
    return state.any((r) => r.url == url);
  }
}