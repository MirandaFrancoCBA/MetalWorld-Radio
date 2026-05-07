import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_service/audio_service.dart';
import 'core/player/audio_handler.dart';
import 'core/player/radio_player.dart';
import 'presentation/views/splash_page.dart';
import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final handler = await AudioService.init(
    builder: () => RadioAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'metal.radio.channel',
      androidNotificationChannelName: 'Metal Radio',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );

  // ✅ Splash visible 3 segundos
  await Future.delayed(const Duration(seconds: 3));

  runApp(
    ProviderScope(
      overrides: [audioHandlerProvider.overrideWithValue(handler)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const SplashPage(),
    );
  }
}
