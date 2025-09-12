import 'package:flutter/material.dart';
import 'stopRecord.dart';

class StopsPanel extends StatefulWidget {
  static const List<String> stops = [
    'maraimalai nagar',
    'potheri',
    'kaatankalathur',
    'guduvancherry'
  ];
  const StopsPanel({super.key});

  @override
  State<StopsPanel> createState() => _StopsPanelState();
}

class _StopsPanelState extends State<StopsPanel> {
  List<bool> reached = List.filled(StopsPanel.stops.length, false);

  @override
  void initState() {
    super.initState();
    _simulateStops();
  }

  Future<void> _simulateStops() async {
    for (int i = 0; i < StopsPanel.stops.length; i++) {
      await Future.delayed(Duration(seconds: 3));
      setState(() {
        reached[i] = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: StopsPanel.stops.asMap().entries.map((entry) {
        final index = entry.key;
        final stopName = entry.value;

        return StopWidget(
          stopNumber: index,
          stopName: stopName,
          time: "08:20 AM", // you can later update this dynamically
          reached: reached[index],
        );
      }).toList(),
    );
  }
}
