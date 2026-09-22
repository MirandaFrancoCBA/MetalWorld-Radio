import 'package:flutter_test/flutter_test.dart';
import 'package:metal_world_radio/data/models/radio_station.dart';

void main() {
  group('RadioStation.fromJson', () {
    test('maps API fields and normalizes tags', () {
      final station = RadioStation.fromJson({
        'name': 'Metal Test',
        'url_resolved': 'https://example.com/stream',
        'favicon': 'https://example.com/icon.png',
        'country': 'Argentina',
        'countrycode': 'AR',
        'tags': 'Metal, Thrash Metal, ',
      });

      expect(station.name, 'Metal Test');
      expect(station.url, 'https://example.com/stream');
      expect(station.countryCode, 'AR');
      expect(station.tags, ['metal', 'thrash metal']);
    });

    test('uses safe defaults for missing optional fields', () {
      final station = RadioStation.fromJson(<String, dynamic>{});

      expect(station.name, 'Radio');
      expect(station.url, isEmpty);
      expect(station.tags, isEmpty);
    });
  });
}
