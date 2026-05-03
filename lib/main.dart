import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'views/home_view.dart';

void main() {
  // ProviderScope es obligatorio para que Riverpod funcione
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