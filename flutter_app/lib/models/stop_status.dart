import 'package:intl/intl.dart';

class StopStatus {
  final int routeId;
  final int stopNumber;
  final String stopName;
  bool reached;
  bool passed;
  DateTime? reachedTime;

  StopStatus({
    required this.routeId,
    required this.stopNumber,
    required this.stopName,
    this.reached = false,
    this.passed = false,
    this.reachedTime,
  });

  factory StopStatus.fromJson(Map<String, dynamic> json) {
    return StopStatus(
      routeId: json['routeId'] as int,
      stopNumber: json['stopNumber'] as int,
      stopName: json['stopName'] as String,
      reached: json['reached'] as bool? ?? false,
      passed: false,
      reachedTime: json['reachedTime'] != null
          ? DateTime.parse(json['reachedTime'])
          : null,
    );
  }
  String get formattedReachedTime {
    if (reachedTime == null) return "--:--";
    return DateFormat("hh:mm a").format(reachedTime!); // e.g. 08:30 AM
  }
}
