import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../models/radio_station.dart';

// 1. Creamos una instancia del servicio
final apiServiceProvider = Provider((ref) => ApiService());

// 2. Este "FutureProvider" se encarga de llamar a la API y guardar el resultado
final metalRadiosProvider = FutureProvider<List<RadioStation>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.fetchMetalRadios();
});