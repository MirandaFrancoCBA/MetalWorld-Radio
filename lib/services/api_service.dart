import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/radio_station.dart';

class ApiService {
  Future<List<RadioStation>> fetchMetalRadios() async {
    final response = await http.get(
  Uri.parse('https://de1.api.radio-browser.info/json/stations/bytag/metal'),
);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => RadioStation.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar radios');
    }
  }
}