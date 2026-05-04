class RadioStation {
  final String name;
  final String url;
  final String favicon;

  RadioStation({
    required this.name,
    required this.url,
    required this.favicon,
  });

  factory RadioStation.fromJson(Map<String, dynamic> json) {
    return RadioStation(
      name: json['name'] ?? 'Radio',
      url: json['url_resolved'] ?? '',
      favicon: json['favicon'] ?? '',
    );
  }
}