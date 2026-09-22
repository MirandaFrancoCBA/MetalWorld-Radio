import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/radio_station.dart';

class RadioApiException implements Exception {
  final String message;

  const RadioApiException(this.message);

  @override
  String toString() => message;
}

class RadioApiService {
  static final Uri _metalStationsUri = Uri.parse(
    'https://de1.api.radio-browser.info/json/stations/bytag/metal',
  );

  final http.Client _client;

  RadioApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<RadioStation>> fetchRadios() async {
    try {
      final response = await _client
          .get(_metalStationsUri)
          .timeout(const Duration(seconds: 12));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw RadioApiException(
          'Radio Browser returned HTTP ${response.statusCode}.',
        );
      }

      final decoded = json.decode(response.body);
      if (decoded is! List) {
        throw const RadioApiException('Unexpected Radio Browser response.');
      }

      return decoded
          .whereType<Map<String, dynamic>>()
          .map(RadioStation.fromJson)
          .where((station) => station.url.isNotEmpty)
          .toList();
    } on RadioApiException {
      rethrow;
    } on FormatException {
      throw const RadioApiException('Radio Browser returned invalid data.');
    } catch (error) {
      throw RadioApiException('Unable to load radio stations: $error');
    }
  }

  void dispose() => _client.close();
}
