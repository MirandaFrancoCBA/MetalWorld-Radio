class RadioStation {
  final String name;
  final String url;
  final String favicon;

  RadioStation({required this.name, required this.url, required this.favicon});

  // Esto convierte el JSON de la API a un objeto que Flutter entiende
  factory RadioStation.fromJson(Map<String, dynamic> json) {
    return RadioStation(
      name: json['name'] ?? 'Radio Sin Nombre',
      url: json['url_resolved'] ?? '',
      favicon: json['favicon'] ?? '',
    );
  }
}