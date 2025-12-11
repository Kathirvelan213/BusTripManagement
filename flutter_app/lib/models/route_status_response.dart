class RouteStatusResponse {
  final int routeId;
  final int nextStopIndex;
  final List<StopStatusInfo> reachedStops;
  final LocationInfo? lastLocation;

  RouteStatusResponse({
    required this.routeId,
    required this.nextStopIndex,
    required this.reachedStops,
    this.lastLocation,
  });

  factory RouteStatusResponse.fromJson(Map<String, dynamic> json) {
    return RouteStatusResponse(
      routeId: json['routeId'] as int,
      nextStopIndex: json['nextStopIndex'] as int,
      reachedStops: (json['reachedStops'] as List<dynamic>)
          .map((item) => StopStatusInfo.fromJson(item as Map<String, dynamic>))
          .toList(),
      lastLocation: json['lastLocation'] != null
          ? LocationInfo.fromJson(json['lastLocation'] as Map<String, dynamic>)
          : null,
    );
  }
}

class LocationInfo {
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  LocationInfo({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  factory LocationInfo.fromJson(Map<String, dynamic> json) {
    return LocationInfo(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}

class StopStatusInfo {
  final int stopNumber;
  final String stopName;
  final DateTime reachedTime;

  StopStatusInfo({
    required this.stopNumber,
    required this.stopName,
    required this.reachedTime,
  });

  factory StopStatusInfo.fromJson(Map<String, dynamic> json) {
    return StopStatusInfo(
      stopNumber: json['stopNumber'] as int,
      stopName: json['stopName'] as String,
      reachedTime: DateTime.parse(json['reachedTime'] as String),
    );
  }
}
