import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/radio_provider.dart';
import '../providers/favorites_provider.dart';
import '../../core/player/radio_player.dart';

const _metalTags = [
  'metal',
  'death metal',
  'black metal',
  'thrash metal',
  'doom metal',
  'heavy metal',
  'power metal',
  'folk metal',
  'gothic metal',
  'metalcore',
];

class RadiosView extends ConsumerWidget {
  const RadiosView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredAsync = ref.watch(filteredRadiosProvider);
    final favorites = ref.watch(favoritesProvider);
    final playerState = ref.watch(radioPlayerProvider);
    final selectedTag = ref.watch(selectedTagProvider);
    final selectedCountry = ref.watch(selectedCountryProvider);

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
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.tune, color: Colors.white),
                onPressed: () => _showFilters(context, ref),
              ),
              if (selectedTag != null || selectedCountry != null)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFCC0000),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFCC0000)),
        ),
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: TextField(
              onChanged: (v) =>
                  ref.read(searchQueryProvider.notifier).state = v,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar radios...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: ref.watch(searchQueryProvider).isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () =>
                            ref.read(searchQueryProvider.notifier).state = '',
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFF1A1A1A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF333333)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF333333)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFCC0000)),
                ),
              ),
            ),
          ),

          // Contador de resultados
          filteredAsync.maybeWhen(
            data: (list) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${list.length} radios',
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ),
            ),
            orElse: () => const SizedBox(),
          ),

          // Lista
          Expanded(
            child: filteredAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: Color(0xFFCC0000)),
              ),
              error: (e, _) => Center(
                child: Text(
                  'Error: $e',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              data: (list) => list.isEmpty
                  ? const Center(
                      child: Text(
                        'SIN RESULTADOS',
                        style: TextStyle(
                          color: Colors.grey,
                          letterSpacing: 3,
                          fontSize: 13,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: list.length,
                      itemBuilder: (context, i) {
                        final r = list[i];
                        final isFav = favorites.any((f) => f.url == r.url);
                        final isPlaying =
                            playerState.currentUrl == r.url &&
                            playerState.playing;

                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 3,
                          ),
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
                                color: isPlaying
                                    ? const Color(0xFFCC0000)
                                    : Colors.white,
                                fontWeight: isPlaying
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                if (r.countryCode.isNotEmpty) ...[
                                  Text(
                                    r.countryCode,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                if (isPlaying)
                                  const Text(
                                    '▶ EN VIVO',
                                    style: TextStyle(
                                      color: Color(0xFFCC0000),
                                      fontSize: 10,
                                      letterSpacing: 2,
                                    ),
                                  ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                isFav
                                    ? Icons.sports_esports
                                    : Icons.sports_esports_outlined,
                                color: isFav
                                    ? const Color(0xFFCC0000)
                                    : Colors.grey,
                              ),
                              onPressed: () => ref
                                  .read(favoritesProvider.notifier)
                                  .toggle(r),
                            ),
                            onTap: () => ref
                                .read(radioPlayerProvider.notifier)
                                .play(r.url, r.name),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilters(BuildContext context, WidgetRef ref) {
  

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111111),
      isScrollControlled: true, // ← agregá esto
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        side: BorderSide(color: Color(0xFFCC0000), width: 1),
      ),
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final tag = ref.watch(selectedTagProvider);
          
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16, // ← y esto
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'FILTROS',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3,
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        ref.read(selectedTagProvider.notifier).state = null;
                        ref.read(selectedCountryProvider.notifier).state = null;
                      },
                      child: const Text(
                        'LIMPIAR',
                        style: TextStyle(
                          color: Color(0xFFCC0000),
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(color: Color(0xFF333333)),
                const SizedBox(height: 8),

                // Subgéneros
                const Text(
                  'SUBGÉNERO',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _metalTags.map((t) {
                    final isSelected = tag == t;
                    return GestureDetector(
                      onTap: () =>
                          ref.read(selectedTagProvider.notifier).state =
                              isSelected ? null : t,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFCC0000)
                              : const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFCC0000)
                                : const Color(0xFF444444),
                          ),
                        ),
                        child: Text(
                          t.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 0.5,
                            color: isSelected ? Colors.white : Colors.grey,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // País
                const Text(
                  'PAÍS',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Consumer(
                  builder: (context, ref, _) {
                    final country = ref.watch(selectedCountryProvider);
                    final countries = ref.watch(availableCountriesProvider);
                    return GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: const Color(0xFF111111),
                          builder: (context) => ListView(
                            children: [
                              ListTile(
                                title: const Text(
                                  'Todos los países',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onTap: () {
                                  ref
                                          .read(
                                            selectedCountryProvider.notifier,
                                          )
                                          .state =
                                      null;
                                  Navigator.pop(context);
                                },
                              ),
                              ...countries.map(
                                (e) => ListTile(
                                  title: Text(
                                    '${e.key}  ${e.value}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  trailing: country == e.key
                                      ? const Icon(
                                          Icons.check,
                                          color: Color(0xFFCC0000),
                                        )
                                      : null,
                                  onTap: () {
                                    ref
                                        .read(selectedCountryProvider.notifier)
                                        .state = e
                                        .key;
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: country != null
                                ? const Color(0xFFCC0000)
                                : const Color(0xFF333333),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.flag,
                              color: Colors.grey,
                              size: 18,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                country != null
                                    ? countries
                                          .firstWhere(
                                            (e) => e.key == country,
                                            orElse: () =>
                                                MapEntry(country, country),
                                          )
                                          .value
                                    : 'Todos los países',
                                style: TextStyle(
                                  color: country != null
                                      ? Colors.white
                                      : Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
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
