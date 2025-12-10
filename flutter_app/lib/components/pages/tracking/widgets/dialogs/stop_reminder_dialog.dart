import 'package:flutter/material.dart';
import 'package:flutter_app/models/stop_status.dart';
import 'package:flutter_app/models/bus_route.dart';
import 'package:flutter_app/services/notification_services/reminder_service.dart';

class StopReminderDialog extends StatelessWidget {
  final List<StopStatus> stops;
  final BusRoute? route;

  const StopReminderDialog({
    super.key,
    required this.stops,
    this.route,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Set Stop Reminder'),
      content: SizedBox(
        width: double.maxFinite,
        child: stops.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'No stops available',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: stops.length,
                itemBuilder: (context, index) {
                  final stop = stops[index];
                  final hasReminder =
                      ReminderService.instance.hasActiveReminder(
                    route?.routeId ?? 0,
                    stop.stopNumber,
                  );

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
                        ? Icon(Icons.notifications_active, color: Colors.blue)
                        : Icon(Icons.notifications_none, color: Colors.grey),
                    onTap: () async {
                      if (route != null) {
                        if (hasReminder) {
                          // Delete the reminder
                          final reminder = ReminderService.instance.getReminder(
                            route!.routeId,
                            stop.stopNumber,
                          );

                          if (reminder != null) {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Remove Reminder'),
                                content: Text(
                                    'Remove reminder for ${stop.stopName}?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: Text('Remove',
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await ReminderService.instance
                                  .removeReminder(reminder.id);

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Reminder removed for ${stop.stopName}'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            }
                          }
                        } else {
                          await ReminderService.instance.addReminder(
                            routeId: route!.routeId,
                            routeName: route!.name,
                            stopNumber: stop.stopNumber,
                            stopName: stop.stopName,
                          );

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Reminder set for ${stop.stopName}'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        }
                      }
                    },
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
