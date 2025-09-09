import 'package:flutter/material.dart';
import './stop.dart';

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
  @override
  Widget build(BuildContext context) {
    return Column(
        children: StopsPanel.stops.asMap().entries.map((entry) {
      return StopWidget(
          stopNumber: entry.key, stopName: entry.value, time: "08:20 AM");
    }).toList());
  }
}
