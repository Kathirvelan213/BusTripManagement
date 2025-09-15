import 'package:flutter/material.dart';
import 'package:flutter_app/models/stop_status.dart';
import 'package:flutter_app/services/location_services/trip_status_service.dart';
import 'stop_record.dart';

class StopsPanel extends StatefulWidget {
  const StopsPanel({super.key});

  @override
  State<StopsPanel> createState() => _StopsPanelState();
}

class _StopsPanelState extends State<StopsPanel> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<StopStatus>>(
        valueListenable: TripStatusService.instance.stopsNotifier,
        builder: (context, stops, _) {
          return Column(
              children: stops.map((stop) {
            return StopWidget(
                stopNumber: stop.stopNumber,
                stopName: stop.stopName,
                time: stop.formattedReachedTime,
                reached: stop.reached);
          }).toList());
        });
  }
}
