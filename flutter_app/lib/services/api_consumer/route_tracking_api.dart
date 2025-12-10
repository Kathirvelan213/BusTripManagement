import 'package:flutter_app/models/route_status_response.dart';
import 'api_client.dart';

final ApiClient _apiClient = ApiClient();

Future<RouteStatusResponse?> getRouteStatus(int routeId) async {
  try {
    final response = await _apiClient.get("/api/RouteTracking/status/$routeId");
    print('Fetched route status for route $routeId');
    return RouteStatusResponse.fromJson(response as Map<String, dynamic>);
  } catch (e) {
    print('Error fetching route status: $e');
    return null;
  }
}
