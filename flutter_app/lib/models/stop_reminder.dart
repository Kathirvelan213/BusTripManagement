class StopReminder {
  final String id;
  final int routeId;
  final String routeName;
  final int stopNumber;
  final String stopName;
  final DateTime createdAt;
  bool isActive;

  StopReminder({
    required this.id,
    required this.routeId,
    required this.routeName,
    required this.stopNumber,
    required this.stopName,
    required this.createdAt,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'routeId': routeId,
      'routeName': routeName,
      'stopNumber': stopNumber,
      'stopName': stopName,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory StopReminder.fromJson(Map<String, dynamic> json) {
    return StopReminder(
      id: json['id'] as String,
      routeId: json['routeId'] as int,
      routeName: json['routeName'] as String,
      stopNumber: json['stopNumber'] as int,
      stopName: json['stopName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}
