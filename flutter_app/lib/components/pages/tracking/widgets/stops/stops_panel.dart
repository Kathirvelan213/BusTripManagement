import 'package:flutter/material.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_app/models/stop_status.dart';
import 'package:flutter_app/models/bus_route.dart';
import 'package:flutter_app/services/location_services/trip_status_service.dart';
import 'package:latlong2/latlong.dart';
import 'stop_record.dart';

class StopsPanel extends StatelessWidget {
  final AnimatedMapController animatedMapController;
  final Function(LatLng) centerOnLocation;
  final BusRoute? route;

  const StopsPanel({
    super.key,
    required this.animatedMapController,
    required this.centerOnLocation,
    this.route,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<StopStatus>>(
      valueListenable: TripStatusService.instance.stopsNotifier,
      builder: (context, stops, _) {
        return Container(
          color: const Color.fromARGB(255, 244, 246, 247),
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: Colors.white,
            ),
            child: Column(
              children: stops.map((stop) {
                return StopWidget(
                  stop: stop,
                  animatedMapController: animatedMapController,
                  centerOnLocation: centerOnLocation,
                  route: route,
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
