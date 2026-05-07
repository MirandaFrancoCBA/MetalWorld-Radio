class RadioStation {
  final String name;
  final String url;
  final String favicon;
  final String country;
  final String countryCode;
  final List<String> tags;

  RadioStation({
    required this.name,
    required this.url,
    required this.favicon,
    required this.country,
    required this.countryCode,
    required this.tags,
  });

  factory RadioStation.fromJson(Map<String, dynamic> json) {
    final rawTags = (json['tags'] ?? '') as String;
    final tagList = rawTags
        .split(',')
        .map((t) => t.trim().toLowerCase())
        .where((t) => t.isNotEmpty)
        .toList();

    return RadioStation(
      name: json['name'] ?? 'Radio',
      url: json['url_resolved'] ?? '',
      favicon: json['favicon'] ?? '',
      country: json['country'] ?? '',
      countryCode: json['countrycode'] ?? '',
      tags: tagList,
    );
  }
}