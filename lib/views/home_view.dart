import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/radio_provider.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuchamos el provider de las radios
    final radiosAsync = ref.watch(metalRadiosProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Fondo oscuro profundo
      appBar: AppBar(
        title: const Text('METAL WORLD RADIO', 
          style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: radiosAsync.when(
        // Caso 1: Mientras carga
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.red)),
        // Caso 2: Si hay un error
        error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.white))),
        // Caso 3: Cuando ya tenemos los datos
        data: (radios) {
          return ListView.builder(
            itemCount: radios.length,
            itemBuilder: (context, index) {
              final radio = radios[index];
              return ListTile(
                leading: const Icon(Icons.radio, color: Colors.redAccent),
                title: Text(radio.name, 
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: const Text('Metal Radio Station', 
                  style: TextStyle(color: Colors.grey)),
                trailing: const Icon(Icons.play_arrow, color: Colors.white),
                onTap: () {
                  // Aquí conectaremos el reproductor en la US#2
                  print('Tocaste: ${radio.name}');
                },
              );
            },
          );
        },
      ),
    );
  }
}