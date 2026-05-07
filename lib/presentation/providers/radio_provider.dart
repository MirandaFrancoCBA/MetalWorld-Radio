import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/radio_station.dart';
import '../../data/services/radio_api_service.dart';

final radioApiProvider = Provider((ref) => RadioApiService());

final radiosProvider = FutureProvider<List<RadioStation>>((ref) async {
  final api = ref.watch(radioApiProvider);
  return api.fetchRadios();
});

// Filtros
final searchQueryProvider = StateProvider<String>((ref) => '');
final selectedTagProvider = StateProvider<String?>((ref) => null);
final selectedCountryProvider = StateProvider<String?>((ref) => null);

// Lista filtrada
final filteredRadiosProvider = Provider<AsyncValue<List<RadioStation>>>((ref) {
  final radiosAsync = ref.watch(radiosProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final tag = ref.watch(selectedTagProvider);
  final country = ref.watch(selectedCountryProvider);

  return radiosAsync.whenData((list) {
    return list.where((r) {
      final matchesSearch = query.isEmpty ||
          r.name.toLowerCase().contains(query);
      final matchesTag = tag == null || r.tags.contains(tag.toLowerCase());
      final matchesCountry = country == null || r.countryCode == country;
      return matchesSearch && matchesTag && matchesCountry;
    }).toList();
  });
});

// Países disponibles en la lista cargada
final availableCountriesProvider = Provider<List<MapEntry<String, String>>>((ref) {
  final radiosAsync = ref.watch(radiosProvider);
  return radiosAsync.maybeWhen(
    data: (list) {
      final seen = <String>{};
      final countries = <MapEntry<String, String>>[];
      for (final r in list) {
        if (r.countryCode.isNotEmpty && seen.add(r.countryCode)) {
          countries.add(MapEntry(r.countryCode, r.country));
        }
      }
      countries.sort((a, b) => a.value.compareTo(b.value));
      return countries;
    },
    orElse: () => [],
  );
});