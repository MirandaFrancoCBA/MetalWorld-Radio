import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_service/audio_service.dart';
import 'views/home_view.dart';
import 'services/audio_handler.dart';

// Eliminamos el 'late' y lo hacemos accesible
// Quitamos el guion bajo (_) para que no sea privada y otros archivos la vean
late MyAudioHandler audioHandler;

Future<void> main() async {
  // 1. Asegurar que los plugins de Flutter estén listos
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Inicializar el servicio de audio ANTES de lanzar la app
  audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.tu_usuario.metal_radio.channel.audio',
      androidNotificationChannelName: 'Reproducción de Metal',
      androidStopForegroundOnPause: true,
    ),
  );

  runApp(const ProviderScope(child: MetalRadioApp()));
}

class MetalRadioApp extends StatelessWidget {
  const MetalRadioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Metal World Radio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
      ),
      home: const HomeView(),
    );
  }
}