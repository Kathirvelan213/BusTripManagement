class RouteStop {
  final int routeId;
  final int stopId;
  final int sequence;
  final String name;
  final double lat;
  final double lng;

  RouteStop({
    required this.routeId,
    required this.stopId,
    required this.sequence,
    required this.name,
    required this.lat,
    required this.lng,
  });

  factory RouteStop.fromJson(Map<String, dynamic> json) {
    return RouteStop(
      routeId: json["routeId"] ?? 0,
      stopId: json["stopId"] ?? 0,
      sequence: json["sequence"] ?? 0,
      lat: (json["lat"] as num?)?.toDouble() ?? 0.0,
      lng: (json["lng"] as num?)?.toDouble() ?? 0.0,
      name: json["name"] ?? "Unknown",
    );
  }
}
