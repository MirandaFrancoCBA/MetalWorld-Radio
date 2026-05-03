// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/radio_provider.dart';
import '../main.dart'; // Para usar la variable 'audioHandler'

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final radiosAsync = ref.watch(metalRadiosProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A), // Negro más profundo
      appBar: AppBar(
        title: const Text(
          'METAL WORLD RADIO',
          style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 10,
        shadowColor: Colors.red.withOpacity(0.5),
      ),
      body: radiosAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.red)),
        error: (err, stack) => Center(
          child: Text(
            'Error: $err',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        data: (radios) {
          return Column(
            children: [
              // 1. LISTA DE RADIOS
              Expanded(
                child: ListView.builder(
                  itemCount: radios.length,
                  itemBuilder: (context, index) {
                    final radio = radios[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: CachedNetworkImage(
                          imageUrl: radio.favicon,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[900],
                            child: const Icon(Icons.album, color: Colors.white24),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[900],
                            child: const Icon(Icons.error_outline, color: Colors.red),
                          ),
                        ),
                      ),
                      title: Text(
                        radio.name.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      subtitle: const Text(
                        'METAL STREAM',
                        style: TextStyle(color: Colors.redAccent, fontSize: 10),
                      ),
                      trailing: const Icon(
                        Icons.play_circle_fill,
                        color: Colors.red,
                        size: 35,
                      ),
                      onTap: () {
                        audioHandler.playMediaItem(
                          MediaItem(
                            id: radio.url,
                            album: "Metal World Radio",
                            title: radio.name,
                            artUri: radio.favicon.isNotEmpty
                                ? Uri.parse(radio.favicon)
                                : null,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              
              // 2. MINI PLAYER PERSISTENTE
              _buildMiniPlayer(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMiniPlayer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(color: Colors.red.withOpacity(0.5), width: 1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea( // Para que no se corte en celulares con "notch" abajo
        child: Row(
          children: [
            const Icon(Icons.graphic_eq, color: Colors.red),
            const SizedBox(width: 15),
            const Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "SISTEMA ACTIVO",
                    style: TextStyle(
                      color: Colors.redAccent, 
                      fontSize: 10, 
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2
                    ),
                  ),
                  Text(
                    "REPRODUCIENDO METAL...",
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 13, 
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.stop_circle, color: Colors.white, size: 35),
              onPressed: () => audioHandler.stop(),
            ),
          ],
        ),
      ),
    );
  }
}