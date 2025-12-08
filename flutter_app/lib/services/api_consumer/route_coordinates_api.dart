import 'api_client.dart';
import 'package:flutter_app/models/route_coordinates.dart';

final ApiClient _apiClient = ApiClient();

Future<List<List<RouteCoordinate>>> getRouteSegments(int routeId) async {
  final data = await _apiClient.get("/api/RouteCoordinate/segments/$routeId");
  // JSON key is "Segments" (capital S)
  final List<dynamic> segmentsJson = data["segments"];

  // Convert each segment into List<RouteCoordinate>
  final List<List<RouteCoordinate>> segments = segmentsJson.map((seg) {
    final List<dynamic> segList = seg as List<dynamic>;
    return segList
        .map((c) => RouteCoordinate(
            coordId: c["coordId"],
            routeId: routeId,
            lat: (c["lat"] as num).toDouble(),
            lng: (c["lng"] as num).toDouble(),
            sequence: c["sequence"]))
        .toList();
  }).toList();

  return segments;
}
