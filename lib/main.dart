import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_service/audio_service.dart';
import 'core/player/audio_handler.dart';
import 'presentation/views/home_page.dart';

late RadioAudioHandler audioHandler;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  audioHandler = await AudioService.init(
  builder: () => RadioAudioHandler(),
  config: const AudioServiceConfig(
    androidNotificationChannelId: 'metal.radio.channel',
    androidNotificationChannelName: 'Metal Radio',
    androidNotificationOngoing: false, // Permitir que deje de ser persistente
    androidStopForegroundOnPause: true, // Permitir que el servicio baje de prioridad al pausar
  ),
);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}