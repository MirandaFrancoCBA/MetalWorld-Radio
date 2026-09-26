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
  // Radio Browser mirrors documented by the service. Keep the server choice
  // isolated here so discovery can be upgraded without touching consumers.
  static const _hosts = [
    'de1.api.radio-browser.info',
    'at1.api.radio-browser.info',
    'nl1.api.radio-browser.info',
  ];

  static const _requestTimeout = Duration(seconds: 30);

  final http.Client _client;

  RadioApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<RadioStation>> fetchRadios() async {
    Object? lastError;

    for (final host in _hosts) {
      try {
        final uri = Uri.https(host, '/json/stations/bytag/metal', {
          'hidebroken': 'true',
          'limit': '1000',
        });

        final response = await _client.get(
          uri,
          headers: const {
            'User-Agent': 'MetalWorldRadio/1.0',
            'Accept': 'application/json',
          },
        ).timeout(_requestTimeout);

        if (response.statusCode < 200 || response.statusCode >= 300) {
          lastError = RadioApiException(
            'Radio Browser returned HTTP ${response.statusCode}.',
          );
          continue;
        }

        final decoded = json.decode(response.body);
        if (decoded is! List) {
          lastError = const RadioApiException(
            'Radio Browser returned an unexpected response.',
          );
          continue;
        }

        final stations = decoded
            .whereType<Map<String, dynamic>>()
            .map(RadioStation.fromJson)
            .where((station) => station.url.isNotEmpty)
            .toList();

        if (stations.isNotEmpty) return stations;

        lastError = const RadioApiException(
          'Radio Browser returned no playable stations.',
        );
      } on FormatException {
        lastError = const RadioApiException(
          'Radio Browser returned invalid data.',
        );
      } catch (error) {
        lastError = error;
      }
    }

    throw RadioApiException(
      'Unable to load radio stations. Please check your connection and retry.'
      '${lastError == null ? '' : ' ($lastError)'}',
    );
  }

  void dispose() => _client.close();
}
