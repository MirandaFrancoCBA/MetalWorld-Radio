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
  static const _bootstrapHost = 'de1.api.radio-browser.info';
  static const _requestTimeout = Duration(seconds: 20);
  static const _stationLimit = '200';

  final http.Client _client;

  RadioApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<RadioStation>> fetchRadios() async {
    final attempts = <String>[];
    final hosts = await _discoverHosts();

    for (final host in hosts) {
      try {
        final uri = Uri.https(host, '/json/stations/bytag/metal', {
          'hidebroken': 'true',
          'order': 'votes',
          'reverse': 'true',
          'limit': _stationLimit,
        });

        final response = await _client
            .get(uri, headers: _headers)
            .timeout(_requestTimeout);

        if (response.statusCode < 200 || response.statusCode >= 300) {
          attempts.add('$host: HTTP ${response.statusCode}');
          continue;
        }

        final decoded = json.decode(response.body);
        if (decoded is! List) {
          attempts.add('$host: unexpected response');
          continue;
        }

        final stations = decoded
            .whereType<Map<String, dynamic>>()
            .map(RadioStation.fromJson)
            .where((station) => station.url.isNotEmpty)
            .toList();

        if (stations.isNotEmpty) return stations;

        attempts.add('$host: no playable stations');
      } on FormatException {
        attempts.add('$host: invalid JSON');
      } catch (error) {
        attempts.add('$host: ${_describeError(error)}');
      }
    }

    throw RadioApiException(
      'Unable to load radio stations. Please check your connection and retry.'
      '${attempts.isEmpty ? '' : ' Attempts: ${attempts.join(' | ')}'}',
    );
  }

  Future<List<String>> _discoverHosts() async {
    try {
      // Radio Browser exposes /json/servers specifically for clients that
      // cannot perform the recommended DNS lookup/reverse lookup themselves.
      final uri = Uri.https(_bootstrapHost, '/json/servers');
      final response = await _client
          .get(uri, headers: _headers)
          .timeout(_requestTimeout);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return const [_bootstrapHost];
      }

      final decoded = json.decode(response.body);
      if (decoded is! List) return const [_bootstrapHost];

      final discovered = decoded
          .whereType<Map<String, dynamic>>()
          .map((server) => server['name'])
          .whereType<String>()
          .map((name) => name.trim())
          .where((name) => name.isNotEmpty)
          .toSet()
          .toList()
        ..shuffle();

      // The bootstrap host is a last-resort fallback. This also preserves the
      // endpoint that was known to work before V1 hardening.
      discovered.remove(_bootstrapHost);
      discovered.add(_bootstrapHost);
      return discovered;
    } catch (_) {
      return const [_bootstrapHost];
    }
  }

  String _describeError(Object error) {
    final text = error.toString();
    return text.length <= 180 ? text : '${text.substring(0, 180)}...';
  }

  static const _headers = {
    'User-Agent': 'MetalWorldRadio/1.0',
    'Accept': 'application/json',
  };

  void dispose() => _client.close();
}
