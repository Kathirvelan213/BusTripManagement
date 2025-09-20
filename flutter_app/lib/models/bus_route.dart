class BusRoute {
  final int routeId;
  final String name;
  final String destination;

  BusRoute({
    required this.routeId,
    required this.name,
    required this.destination,
  });

  factory BusRoute.fromJson(Map<String, dynamic> json) {
    return BusRoute(
      routeId: json['routeId'],
      name: json['name'],
      destination: json['destination'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'routeId': routeId,
      'name': name,
      'destination': destination,
    };
  }
}
