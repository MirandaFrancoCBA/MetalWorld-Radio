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
    final countries = ref.watch(availableCountriesProvider);

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

          // Chips de subgénero
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _metalTags.length,
              itemBuilder: (context, i) {
                final tag = _metalTags[i];
                final isSelected = selectedTag == tag;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    materialTapTargetSize:
                        MaterialTapTargetSize.shrinkWrap, // ← agregá
                    labelPadding: const EdgeInsets.symmetric(
                      horizontal: 4,
                    ), // ← agregá
                    label: Text(
                      tag.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 0.5, // ← reducí de 1 a 0.5
                        color: isSelected ? Colors.white : Colors.grey,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (_) {
                      ref.read(selectedTagProvider.notifier).state = isSelected
                          ? null
                          : tag;
                    },
                    backgroundColor: const Color(0xFF1A1A1A),
                    selectedColor: const Color(0xFFCC0000),
                    checkmarkColor: Colors.white,
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFFCC0000)
                          : const Color(0xFF333333),
                    ),
                  ),
                );
              },
            ),
          ),

          // Dropdown de país
          if (countries.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
              child: DropdownButtonFormField<String?>(
                value: selectedCountry,
                dropdownColor: const Color(0xFF1A1A1A),
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.flag,
                    color: Colors.grey,
                    size: 18,
                  ),
                  hintText: 'Todos los países',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF1A1A1A),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
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
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Todos los países'),
                  ),
                  ...countries.map(
                    (e) => DropdownMenuItem(
                      value: e.key,
                      child: Text('${e.key}  ${e.value}'),
                    ),
                  ),
                ],
                onChanged: (v) =>
                    ref.read(selectedCountryProvider.notifier).state = v,
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
