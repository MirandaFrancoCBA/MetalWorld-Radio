import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'presentation/views/home_page.dart';
import 'core/player/audio_handler.dart';
import 'core/player/radio_player.dart';
import 'package:audio_service/audio_service.dart';

late MyAudioHandler audioHandler;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  final container = ProviderContainer();
  final player = container.read(radioPlayerProvider.notifier);

  audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(player),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'metal.radio.channel',
      androidNotificationChannelName: 'Metal Radio',
      androidStopForegroundOnPause: false,
    ),
  );

  runApp(
    UncontrolledProviderScope(
      container: container,
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
      home: const HomePage(),
    );
  }
}