import 'package:flutter/material.dart';
import 'package:flutter_app/components/pages/tracking/widgets/pinging_location_icon.dart';
import 'package:flutter_app/config/custom_colors.dart';
import 'package:flutter_app/models/bus_route.dart';
import 'package:flutter_app/models/stop_status.dart';
import 'package:flutter_app/services/location_services/trip_status_service.dart';

class BusInfo extends StatelessWidget {
  final BusRoute? selectedRoute;

  BusInfo({super.key, required this.selectedRoute});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<StopStatus>>(
        valueListenable: TripStatusService.instance.stopsNotifier,
        builder: (context, stops, _) {
          final hasStops = stops.isNotEmpty;
          final firstStopName = hasStops ? stops.first.stopName : "Loading...";
          final lastStopName = hasStops ? stops.last.stopName : "Loading...";
          final lastReachedName = stops
              .lastWhere(
                (s) => s.reached == true,
                orElse: () => StopStatus(
                    routeId: 1, stopNumber: 0, stopName: "Not reached yet"),
              )
              .stopName;
          return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.appSecondary2),
              padding: EdgeInsets.only(left: 0, top: 24, bottom: 24),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Image(
                      image:
                          AssetImage('assets/images/yellow_bus_3d_front.png'),
                      width: 60,
                      height: 60,
                    ),
                  ),
                  Column(
                    spacing: 2,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Route: ${selectedRoute?.name ?? 'N/A'}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                      Text("$firstStopName -> $lastStopName",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          )),
                      Row(
                        children: [
                          PingingRedDotIcon(),
                          Text(lastReachedName,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.red,
                              ))
                        ],
                      ),
                      Text(TimeOfDay.now().format(context),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          )),
                    ],
                  )
                ],
              ));
        });
  }
}
