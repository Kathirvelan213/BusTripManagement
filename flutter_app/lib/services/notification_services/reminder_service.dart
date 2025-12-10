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
    // Check if reminder already exists
    final exists = remindersNotifier.value.any(
      (r) => r.routeId == routeId && r.stopNumber == stopNumber && r.isActive,
    );

    if (exists) {
      debugPrint('Reminder already exists for this stop');
      return;
    }

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
    remindersNotifier.value =
        remindersNotifier.value.where((reminder) => reminder.id != id).toList();
    await _saveReminders();
  }

  /// Toggle reminder active status
  Future<void> toggleReminder(String id) async {
    final index = remindersNotifier.value.indexWhere((r) => r.id == id);
    if (index != -1) {
      final updated = [...remindersNotifier.value];
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
