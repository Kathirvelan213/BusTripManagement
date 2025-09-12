import 'package:flutter_app/models/routeStop.dart';

import 'api_client.dart';

final ApiClient _apiClient = ApiClient();

Future<List<RouteStop>> getRouteStops(int routeId) async {
  final response = await _apiClient.get("/StopsRoutes/for-route/$routeId");
  final List<dynamic> stopsJson = response as List<dynamic>;

  return stopsJson.map((json) => RouteStop.fromJson(json)).toList();
}
