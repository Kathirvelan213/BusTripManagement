import 'package:flutter/material.dart';
import 'package:flutter_app/services/location_services/trip_status_service.dart';
import 'stopRecord.dart';

class StopsPanel extends StatefulWidget {
  const StopsPanel({super.key});

  @override
  State<StopsPanel> createState() => _StopsPanelState();
}

class _StopsPanelState extends State<StopsPanel> {
  List<bool> reached =
      List.filled(TripStatusService.instance.stopsNotifier.value.length, false);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<StopStatus>>(
        valueListenable: TripStatusService.instance.stopsNotifier,
        builder: (context, stops, _) {
          return Column(
              children: stops.map((stop) {
            print(stop.reached);
            return StopWidget(
              stopNumber: stop.stopNumber,
              stopName: stop.stopName,
              time: stop.reachedTime ?? '--:--',
              reached: stop.reached,
            );
          }).toList());
        });
  }
}
