import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/radio_station.dart';

class FavoritesService {
  static const _key = 'favorite_radios';

  Future<List<RadioStation>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];

    return data.map((e) => RadioStation.fromJson(json.decode(e))).toList();
  }

  Future<void> toggleFavorite(RadioStation radio) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];

    final exists = data.any((e) {
      final r = RadioStation.fromJson(json.decode(e));
      return r.url == radio.url;
    });

    if (exists) {
      data.removeWhere((e) {
        final r = RadioStation.fromJson(json.decode(e));
        return r.url == radio.url;
      });
    } else {
      data.add(
        json.encode({
          'name': radio.name,
          'url_resolved': radio.url,
          'favicon': radio.favicon,
          'country': radio.country, 
          'countrycode': radio.countryCode, 
          'tags': radio.tags.join(','), 
        }),
      );
    }

    await prefs.setStringList(_key, data);
  }

  Future<bool> isFavorite(String url) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];

    return data.any((e) {
      final r = RadioStation.fromJson(json.decode(e));
      return r.url == url;
    });
  }
}
