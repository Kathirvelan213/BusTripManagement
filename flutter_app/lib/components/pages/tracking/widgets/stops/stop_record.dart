import 'package:flutter/material.dart';
import 'package:flutter_app/models/stop_status.dart';
import 'package:flutter_app/models/bus_route.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_app/services/location_services/route_stops_service.dart';
import 'package:flutter_app/services/notification_services/reminder_service.dart';
import 'package:latlong2/latlong.dart';

class StopWidget extends StatelessWidget {
  final StopStatus stop;
  final AnimatedMapController animatedMapController;
  final Function(LatLng) centerOnLocation;
  final BusRoute? route;

  const StopWidget({
    super.key,
    required this.stop,
    required this.animatedMapController,
    required this.centerOnLocation,
    this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    height: 30,
                    width: 2,
                    color: stop.reached ? Colors.blue : Colors.grey.shade300,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    height: 30,
                    width: 2,
                    color: stop.passed ? Colors.blue : Colors.grey.shade300,
                  ),
                ],
              ),
              if (stop.reached && !stop.passed)
                Container(
                  width: 20,
                  height: 20,
                  child: Image.asset(
                    "assets/images/bus_front_icon.png",
                    fit: BoxFit.contain,
                  ),
                ),
            ],
          ),
        ]),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade100.withOpacity(0.15),
                  blurRadius: 2,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: InkWell(
              onTap: () {
                final location = RouteStopsService.instance
                    .getStopLocationBySequence(stop.stopNumber);
                if (location != null) {
                  centerOnLocation(location);
                }
              },
              onLongPress: () async {
                if (route != null) {
                  final hasReminder =
                      ReminderService.instance.hasActiveReminder(
                    route!.routeId,
                    stop.stopNumber,
                  );

                  if (hasReminder) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Reminder already set for ${stop.stopName}'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    // Show confirmation dialog before adding reminder
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Set Reminder'),
                        content: Text('Add a reminder for ${stop.stopName}?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text('Add'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await ReminderService.instance.addReminder(
                        routeId: route!.routeId,
                        routeName: route!.name,
                        stopNumber: stop.stopNumber,
                        stopName: stop.stopName,
                      );

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Reminder set for ${stop.stopName}'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  }
                }
              },
              child: Container(
                height: 55,
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade100.withOpacity(0.15),
                      blurRadius: 2,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 28,
                  children: [
                    Text(
                      stop.formattedReachedTime,
                      style: TextStyle(
                        fontSize: 14,
                        color: stop.reached
                            ? const Color.fromARGB(255, 40, 47, 53)
                            : Colors.grey.shade600,
                      ),
                      softWrap: true,
                    ),
                    Text(
                      stop.stopName,
                      style: TextStyle(
                        fontSize: 14,
                        color: stop.reached
                            ? const Color.fromARGB(255, 49, 145, 166)
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
