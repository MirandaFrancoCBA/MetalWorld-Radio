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
  static const _hosts = [
    'de2.api.radio-browser.info',
    'fi1.api.radio-browser.info',
    'de1.api.radio-browser.info',
    'at1.api.radio-browser.info',
    'nl1.api.radio-browser.info',
  ];

  final http.Client _client;

  RadioApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<RadioStation>> fetchRadios() async {
    Object? lastError;

    for (final host in _hosts) {
      try {
        final uri = Uri.https(host, '/json/stations/bytag/metal', {
          'hidebroken': 'true',
        });
        final response = await _client.get(
          uri,
          headers: const {
            'User-Agent': 'MetalWorldRadio/1.0',
            'Accept': 'application/json',
          },
        ).timeout(const Duration(seconds: 8));

        if (response.statusCode < 200 || response.statusCode >= 300) {
          lastError = RadioApiException(
            'Radio Browser returned HTTP ${response.statusCode} from $host.',
          );
          continue;
        }

        final decoded = json.decode(response.body);
        if (decoded is! List) {
          lastError = const RadioApiException(
            'Unexpected Radio Browser response.',
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
      'Unable to load radio stations after trying multiple Radio Browser servers'
      '${lastError == null ? '.' : ': $lastError'}',
    );
  }

  void dispose() => _client.close();
}
