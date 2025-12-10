import 'package:flutter/foundation.dart';
import 'package:flutter_app/models/stop_reminder.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ReminderService {
  static final ReminderService _instance = ReminderService._internal();
  static ReminderService get instance => _instance;

  factory ReminderService() => _instance;
  ReminderService._internal();

  final ValueNotifier<List<StopReminder>> remindersNotifier = ValueNotifier([]);
  final _storage = const FlutterSecureStorage();
  static const String _storageKey = 'stop_reminders';

  /// Initialize and load reminders from storage
  Future<void> initialize() async {
    await _loadReminders();
  }

  /// Load reminders from secure storage
  Future<void> _loadReminders() async {
    try {
      final String? remindersJson = await _storage.read(key: _storageKey);
      if (remindersJson != null) {
        final List<dynamic> decoded = jsonDecode(remindersJson);
        remindersNotifier.value =
            decoded.map((json) => StopReminder.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error loading reminders: $e');
      remindersNotifier.value = [];
    }
  }

  /// Save reminders to secure storage
  Future<void> _saveReminders() async {
    try {
      final remindersJson = jsonEncode(
        remindersNotifier.value.map((r) => r.toJson()).toList(),
      );
      await _storage.write(key: _storageKey, value: remindersJson);
    } catch (e) {
      debugPrint('Error saving reminders: $e');
    }
  }

  /// Add a new reminder
  Future<void> addReminder({
    required int routeId,
    required String routeName,
    required int stopNumber,
    required String stopName,
  }) async {
    print("adding reminder for $routeName - $stopName");
    // Check if reminder already exists (active)
    final activeExists = remindersNotifier.value.any(
      (r) => r.routeId == routeId && r.stopNumber == stopNumber && r.isActive,
    );

    if (activeExists) {
      debugPrint('Reminder already exists for this stop');
      return;
    }

    // Check if a disabled reminder exists for this stop
    StopReminder? disabledReminder;
    try {
      disabledReminder = remindersNotifier.value.firstWhere(
        (r) =>
            r.routeId == routeId && r.stopNumber == stopNumber && !r.isActive,
      );
    } catch (e) {
      disabledReminder = null;
    }

    if (disabledReminder != null) {
      // Enable the disabled reminder instead of creating a new one

      await toggleReminder(disabledReminder.id);
      return;
    }

    // Create a new reminder if no disabled one exists
    final newReminder = StopReminder(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      routeId: routeId,
      routeName: routeName,
      stopNumber: stopNumber,
      stopName: stopName,
      createdAt: DateTime.now(),
    );

    remindersNotifier.value = [...remindersNotifier.value, newReminder];
    await _saveReminders();
  }

  /// Remove a reminder by ID
  Future<void> removeReminder(String id) async {
    final updated =
        remindersNotifier.value.where((reminder) => reminder.id != id).toList();
    remindersNotifier.value = updated;
    await _saveReminders();
  }

  /// Toggle reminder active status
  Future<void> toggleReminder(String id) async {
    final index = remindersNotifier.value.indexWhere((r) => r.id == id);
    if (index != -1) {
      // Create a new list with updated reminder
      final updated = List<StopReminder>.from(remindersNotifier.value);
      updated[index].isActive = !updated[index].isActive;
      remindersNotifier.value = updated;
      await _saveReminders();
    }
  }

  /// Check if a stop has an active reminder
  bool hasActiveReminder(int routeId, int stopNumber) {
    return remindersNotifier.value.any(
      (r) => r.routeId == routeId && r.stopNumber == stopNumber && r.isActive,
    );
  }

  /// Get reminder for a specific stop
  StopReminder? getReminder(int routeId, int stopNumber) {
    try {
      return remindersNotifier.value.firstWhere(
        (r) => r.routeId == routeId && r.stopNumber == stopNumber && r.isActive,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get all active reminders
  List<StopReminder> get activeReminders =>
      remindersNotifier.value.where((r) => r.isActive).toList();

  /// Clear all reminders
  Future<void> clearAll() async {
    remindersNotifier.value = [];
    await _saveReminders();
  }
}
