import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/radio_provider.dart';
import '../../core/player/radio_player.dart';
import 'package:media_kit/media_kit.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final radios = ref.watch(radiosProvider);
    final player = ref.watch(playerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Metal Radio')),
      body: radios.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (list) => ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, i) {
            final r = list[i];
            return ListTile(
              title: Text(r.name),
              onTap: () async {
                await player.open(
                  Media(r.url),
                  play: true,
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: StreamBuilder<bool>(
        stream: player.stream.playing,
        builder: (context, snapshot) {
          final playing = snapshot.data ?? false;

          return Container(
            color: Colors.black,
            child: Row(
              children: [
                const SizedBox(width: 10),
                const Text(
                  'Playing...',
                  style: TextStyle(color: Colors.white),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    playing ? Icons.pause : Icons.play_arrow,
                  ),
                  onPressed: () {
                    playing ? player.pause() : player.play();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.stop),
                  onPressed: () => player.stop(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}