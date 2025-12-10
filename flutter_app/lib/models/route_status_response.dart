class RouteStatusResponse {
  final int routeId;
  final int nextStopIndex;
  final List<StopStatusInfo> reachedStops;

  RouteStatusResponse({
    required this.routeId,
    required this.nextStopIndex,
    required this.reachedStops,
  });

  factory RouteStatusResponse.fromJson(Map<String, dynamic> json) {
    return RouteStatusResponse(
      routeId: json['routeId'] as int,
      nextStopIndex: json['nextStopIndex'] as int,
      reachedStops: (json['reachedStops'] as List<dynamic>)
          .map((item) => StopStatusInfo.fromJson(item as Map<String, dynamic>))
          .toList(),
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
