import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_service/audio_service.dart'; // Importante para MediaItem
import '../providers/radio_provider.dart';
import '../main.dart'; // Importamos el main para poder usar 'audioHandler'

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final radiosAsync = ref.watch(metalRadiosProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'METAL WORLD RADIO',
          style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: radiosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.red)),
        error: (err, stack) => Center(
          child: Text('Error: $err', style: const TextStyle(color: Colors.white)),
        ),
        data: (radios) {
          return ListView.builder(
            itemCount: radios.length,
            itemBuilder: (context, index) {
              final radio = radios[index];
              return ListTile(
                leading: const Icon(Icons.radio, color: Colors.redAccent),
                title: Text(
                  radio.name,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Metal Radio Station', style: TextStyle(color: Colors.grey)),
                trailing: const Icon(Icons.play_arrow, color: Colors.white),
                onTap: () {
                  // USAMOS LA VARIABLE GLOBAL QUE DEFINIMOS EN MAIN
                  audioHandler.playMediaItem(
                    MediaItem(
                      id: radio.url, 
                      album: "Metal World Radio",
                      title: radio.name,
                      // Verificamos si hay favicon, si no ponemos uno por defecto
                      artUri: radio.favicon.isNotEmpty ? Uri.parse(radio.favicon) : null,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}