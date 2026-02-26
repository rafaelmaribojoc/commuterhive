class RoutePoint {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String kind; // 'stop' or 'waypoint'
  final double? heading;

  const RoutePoint({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.kind = 'stop',
    this.heading,
  });

  factory RoutePoint.fromJson(Map<String, dynamic> json) {
    return RoutePoint(
      id: json['id'] as String,
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      kind: json['kind'] as String? ?? 'stop',
      heading: (json['heading'] as num?)?.toDouble(),
    );
  }

  bool get isStop => kind == 'stop';
}
