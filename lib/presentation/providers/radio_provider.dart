import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/radio_station.dart';
import '../../data/services/radio_api_service.dart';

final radioApiProvider = Provider((ref) => RadioApiService());

final radiosProvider = FutureProvider<List<RadioStation>>((ref) async {
  final api = ref.watch(radioApiProvider);
  return api.fetchRadios();
});