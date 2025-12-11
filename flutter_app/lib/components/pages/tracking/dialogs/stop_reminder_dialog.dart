import 'package:flutter/material.dart';
import 'package:flutter_app/models/stop_status.dart';
import 'package:flutter_app/models/bus_route.dart';
import 'package:flutter_app/models/stop_reminder.dart';
import 'package:flutter_app/services/notification_services/reminder_service.dart';

class StopReminderDialog extends StatefulWidget {
  final List<StopStatus> stops;
  final BusRoute? route;

  const StopReminderDialog({
    super.key,
    required this.stops,
    this.route,
  });

  @override
  State<StopReminderDialog> createState() => _StopReminderDialogState();
}

class _StopReminderDialogState extends State<StopReminderDialog> {
  // Helper to show a confirmation dialog and return true if user confirms.
  Future<bool?> _confirmRemoval(BuildContext context, String stopName) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Reminder'),
        content: Text('Remove reminder for $stopName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Remove',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set Stop Reminder'),
      content: SizedBox(
        width: double.maxFinite,
        child: widget.stops.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No stops available',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            : ValueListenableBuilder<List<StopReminder>>(
                valueListenable: ReminderService.instance.remindersNotifier,
                builder: (context, reminders, _) {
                  print(
                      'Rebuilding StopReminderDialog with ${reminders.length} reminders');
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.stops.length,
                    itemBuilder: (context, index) {
                      final stop = widget.stops[index];

                      // Compute from current notifier snapshot; require a valid routeId to match
                      final routeId = widget.route?.routeId;
                      final hasReminder = routeId != null
                          ? reminders.any((r) =>
                              r.routeId == routeId &&
                              r.stopNumber == stop.stopNumber &&
                              r.isActive)
                          : false;

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: hasReminder
                              ? Colors.blue.shade100
                              : Colors.grey.shade200,
                          child: Text(
                            '${stop.stopNumber}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: hasReminder
                                  ? Colors.blue.shade700
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ),
                        title: Text(stop.stopName),
                        trailing: hasReminder
                            ? const Icon(Icons.notifications_active,
                                color: Colors.blue)
                            : const Icon(Icons.notifications_none,
                                color: Colors.grey),
                        onTap: () async {
                          // Ensure route is present
                          if (widget.route == null) return;

                          if (hasReminder) {
                            // Find the reminder object
                            final reminder =
                                ReminderService.instance.getReminder(
                              widget.route!.routeId,
                              stop.stopNumber,
                            );

                            if (reminder != null) {
                              final confirm =
                                  await _confirmRemoval(context, stop.stopName);
                              if (confirm == true) {
                                await ReminderService.instance
                                    .removeReminder(reminder.id);
                              }
                            }
                          } else {
                            await ReminderService.instance.addReminder(
                              routeId: widget.route!.routeId,
                              routeName: widget.route!.name,
                              stopNumber: stop.stopNumber,
                              stopName: stop.stopName,
                            );
                          }
                        },
                      );
                    },
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
