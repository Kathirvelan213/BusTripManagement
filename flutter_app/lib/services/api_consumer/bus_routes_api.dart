import 'api_client.dart';
import 'package:flutter_app/models/bus_route.dart';

final ApiClient _apiClient = ApiClient();

Future<List<BusRoute>> getBusRoutes() async {
  final List<dynamic> data = await _apiClient.get("/BusRoutes");

  return data.map((route) => BusRoute.fromJson(route)).toList();
}

Future<BusRoute?> getBusRouteById(int routeId) async {
  final data = await _apiClient.get("/BusRoutes/$routeId");

  if (data == null) return null;
  return BusRoute.fromJson(data);
}
