import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  static NotificationService get instance => _instance;

  factory NotificationService() => _instance;
  NotificationService._internal();

  FlutterLocalNotificationsPlugin? _notificationsPlugin;

  bool _initialized = false;

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      _notificationsPlugin = FlutterLocalNotificationsPlugin();

      // Android initialization settings
      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS initialization settings
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      // Combined initialization settings
      const initializationSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      // Initialize the plugin
      final result = await _notificationsPlugin!.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      if (result == true) {
        debugPrint('NotificationService plugin initialized');

        // Create Android notification channel (required for Android 8.0+)
        if (defaultTargetPlatform == TargetPlatform.android) {
          await _createAndroidNotificationChannel();
        }

        // Request permissions for Android 13+ and iOS
        await _requestPermissions();

        _initialized = true;
        debugPrint('NotificationService initialized successfully');
      } else {
        debugPrint('NotificationService initialization failed');
      }
    } catch (e) {
      debugPrint('Error initializing NotificationService: $e');
      _initialized = false;
    }
  }

  /// Create Android notification channel
  Future<void> _createAndroidNotificationChannel() async {
    const androidChannel = AndroidNotificationChannel(
      'bus_stops_channel', // Channel ID
      'Bus Stop Notifications', // Channel name
      description: 'Notifications when the bus reaches your stop',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    final androidPlugin =
        _notificationsPlugin?.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(androidChannel);
      debugPrint('Android notification channel created');
    }
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    // Android 13+ permissions
    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidPlugin =
          _notificationsPlugin?.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        await androidPlugin.requestNotificationsPermission();
      }
    }

    // iOS permissions
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final iosPlugin =
          _notificationsPlugin?.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();

      if (iosPlugin != null) {
        await iosPlugin.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
      }
    }
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    // TODO: Navigate to specific page or show details when notification is tapped
  }

  /// Show notification when bus reaches a stop
  Future<void> showStopReachedNotification({
    required String stopName,
    required String routeName,
    required int stopNumber,
  }) async {
    if (!_initialized) {
      debugPrint(
          'NotificationService not initialized, cannot show notification');
      return;
    }

    // Create notification details
    const androidDetails = AndroidNotificationDetails(
      'bus_stops_channel', // Channel ID
      'Bus Stop Notifications', // Channel name
      channelDescription: 'Notifications when the bus reaches your stop',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Show the notification
    await _notificationsPlugin?.show(
      stopNumber, // Use stop number as notification ID
      'Bus Approaching!',
      'The bus is approaching $stopName on $routeName',
      notificationDetails,
      payload: '$routeName|$stopNumber|$stopName',
    );

    debugPrint('Notification shown for stop: $stopName');
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin?.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin?.cancelAll();
  }
}
