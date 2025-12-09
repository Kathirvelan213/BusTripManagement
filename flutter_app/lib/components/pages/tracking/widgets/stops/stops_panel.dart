import 'package:flutter/material.dart';
import 'package:flutter_app/models/stop_status.dart';
import 'package:flutter_app/services/location_services/trip_status_service.dart';
import 'stop_record.dart';

class StopsPanel extends StatelessWidget {
  const StopsPanel({super.key});

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
                  stopNumber: stop.stopNumber,
                  stopName: stop.stopName,
                  time: stop.formattedReachedTime,
                  reached: stop.reached,
                  passed: stop.passed,
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
