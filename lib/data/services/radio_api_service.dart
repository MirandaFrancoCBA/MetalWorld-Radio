import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/radio_station.dart';

class RadioApiService {
  Future<List<RadioStation>> fetchRadios() async {
    final res = await http.get(
      Uri.parse('https://de1.api.radio-browser.info/json/stations/bytag/metal'),
    );

    final data = json.decode(res.body) as List;

    return data
        .map((e) => RadioStation.fromJson(e))
        .where((r) => r.url.isNotEmpty)
        .toList();
  }
}