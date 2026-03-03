import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _permissionAskedKey = 'notification_permission_asked';
  static const String _notificationsScheduledKey = 'notifications_scheduled';

  bool _isInitialized = false;

  // Fun messages for each meal - college student friendly! 🎉
  static const Map<String, List<String>> _mealMessages = {
    'breakfast': [
      '☀️ Rise and shine, champ! Breakfast awaits!',
      '🍳 Your morning fuel is ready. Don\'t skip!',
      '🌅 Early bird gets the best BF! Get moving!',
      '☕ Chai + Breakfast = Perfect morning combo!',
      '🔋 Recharge mode: ON. Breakfast served!',
      '🌞 Wakey wakey! Hot BF waiting for you!',
      '💪 Champions don\'t skip breakfast. Mess is open!',
      '🥐 Fresh breakfast alert! Your stomach called.',
    ],
    'lunch': [
      '🍛 Lunch o\'clock! Time to refuel!',
      '🚀 Midday munchies? Mess is calling!',
      '🍽️ Your afternoon energy boost is served!',
      '😋 Hungry already? Lunch is ready!',
      '🌯 Dal-Roti calling your name! Come eat!',
      '⚡ Power lunch awaits! Don\'t let it get cold!',
      '🎯 Mission: Lunch. Status: Ready to eat!',
      '🔔 Ding ding! Lunch is served, genius!',
    ],
    'snacks': [
      '☕ Chai time! Don\'t miss the snacks!',
      '🍪 Snack attack incoming! Mess is open!',
      '🫖 Evening chai + Snacks = happiness!',
      '✨ Take a break! Snacks are waiting!',
      '🎉 Study break approved! Snacks served!',
      '🍩 You deserve this snack break!',
      '☕ Coffee/Chai break! Your call, your snack!',
      '🌆 Evening munchies sorted. Head to mess!',
    ],
    'dinner': [
      '🌙 Dinner time! Feed your soul!',
      '🍽️ Last call of the day! Dinner is served!',
      '🌟 End your day right. Hot dinner awaits!',
      '🍛 Day\'s almost done! Time for dinner!',
      '🌜 Night owl fuel loading... Dinner ready!',
      '✨ Treat yourself! Dinner is served!',
      '🥘 Good food, good mood. Dinner time!',
      '🌙 Recharge for tomorrow. Eat well tonight!',
    ],
  };

  // Meal schedule: Different times for weekdays vs weekends
  // Format: {dayOfWeek: {mealType: TimeOfDay}}
  // dayOfWeek: 1=Monday, 7=Sunday
  static const Map<String, Map<String, List<int>>> _mealSchedule = {
    'weekday': {
      'breakfast': [7, 30], // 7:30 AM
      'lunch': [12, 15], // 12:15 PM
      'snacks': [17, 30], // 5:30 PM
      'dinner': [20, 0], // 8:00 PM
    },
    'weekend': {
      'breakfast': [8, 0], // 8:00 AM
      'lunch': [12, 30], // 12:30 PM
      'snacks': [17, 30], // 5:30 PM
      'dinner': [20, 0], // 8:00 PM
    },
  };

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize timezone
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    const androidSettings =
        AndroidInitializationSettings('@drawable/ic_notification');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _isInitialized = true;
    debugPrint('🔔 NotificationService initialized');
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - can navigate to specific screen
    debugPrint('📱 Notification tapped: ${response.payload}');
  }

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsEnabledKey) ?? false;
  }

  /// Check if permission has been asked before
  Future<bool> hasAskedPermission() async {
    final prefs = await SharedPreferences.getInstance();
    final asked = prefs.getBool(_permissionAskedKey) ?? false;
    debugPrint('🔔 hasAskedPermission check: $asked');
    return asked;
  }

  /// Mark that we've asked for permission
  Future<void> markPermissionAsked() async {
    final prefs = await SharedPreferences.getInstance();
    final success = await prefs.setBool(_permissionAskedKey, true);
    debugPrint('🔔 markPermissionAsked: success=$success');

    // Verify it was actually saved by reading it back
    final verified = prefs.getBool(_permissionAskedKey) ?? false;
    debugPrint('🔔 markPermissionAsked verified: $verified');
  }

  /// Request notification permission
  Future<bool> requestPermission() async {
    bool granted = false;

    if (Platform.isAndroid) {
      final android = _notifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (android != null) {
        // Request exact alarm permission for Android 12+
        await android.requestExactAlarmsPermission();
        // Request notification permission for Android 13+
        granted = await android.requestNotificationsPermission() ?? false;
      }
    } else if (Platform.isIOS) {
      final ios = _notifications.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      if (ios != null) {
        granted = await ios.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            ) ??
            false;
      }
    }

    debugPrint('🔔 Notification permission granted: $granted');
    return granted;
  }

  /// Enable notifications and schedule all meal reminders
  Future<void> enableNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, true);
    await scheduleAllMealNotifications();
    debugPrint('✅ Notifications enabled');
  }

  /// Disable notifications and cancel all scheduled reminders
  Future<void> disableNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, false);
    await prefs.setBool(_notificationsScheduledKey, false);
    await cancelAllNotifications();
    debugPrint('🔕 Notifications disabled');
  }

  /// Cancel all scheduled notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    debugPrint('🗑️ All notifications cancelled');
  }

  /// Get a random message for a meal type
  String _getRandomMessage(String mealType) {
    final messages = _mealMessages[mealType] ?? _mealMessages['breakfast']!;
    return messages[Random().nextInt(messages.length)];
  }

  /// Get notification details
  NotificationDetails _getNotificationDetails(String mealType) {
    // Channel IDs for each meal type for better organization
    final channelId = 'meal_${mealType}_channel';
    final channelName =
        '${mealType.substring(0, 1).toUpperCase()}${mealType.substring(1)} Reminders';

    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: 'Notifications for $mealType time',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
      // Enable in low power mode
      category: AndroidNotificationCategory.reminder,
      visibility: NotificationVisibility.public,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    return NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
  }

  /// Schedule all meal notifications for the week
  Future<void> scheduleAllMealNotifications() async {
    // Cancel existing notifications first
    await cancelAllNotifications();

    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(_notificationsEnabledKey) ?? false;

    if (!enabled) {
      debugPrint('🔕 Notifications disabled, skipping schedule');
      return;
    }

    final meals = ['breakfast', 'lunch', 'snacks', 'dinner'];
    int notificationId = 0;

    // Schedule for next 7 days
    for (int dayOffset = 0; dayOffset < 7; dayOffset++) {
      final targetDate = DateTime.now().add(Duration(days: dayOffset));
      final dayOfWeek = targetDate.weekday;
      final isWeekend = dayOfWeek == 6 || dayOfWeek == 7; // Saturday or Sunday

      final schedule =
          isWeekend ? _mealSchedule['weekend']! : _mealSchedule['weekday']!;

      for (final meal in meals) {
        final time = schedule[meal]!;
        final scheduledTime = DateTime(
          targetDate.year,
          targetDate.month,
          targetDate.day,
          time[0],
          time[1],
        );

        // Only schedule if time is in the future
        if (scheduledTime.isAfter(DateTime.now())) {
          await _scheduleNotification(
            id: notificationId++,
            title: _getMealTitle(meal),
            body: _getRandomMessage(meal),
            scheduledTime: scheduledTime,
            mealType: meal,
          );
        }
      }
    }

    await prefs.setBool(_notificationsScheduledKey, true);
    debugPrint('📅 Scheduled ${notificationId} notifications for the week');
  }

  String _getMealTitle(String mealType) {
    switch (mealType) {
      case 'breakfast':
        return 'Breakfast Time!';
      case 'lunch':
        return 'Lunch Time!';
      case 'snacks':
        return 'Snacks Time!';
      case 'dinner':
        return 'Dinner Time!';
      default:
        return 'Meal Time!';
    }
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    required String mealType,
  }) async {
    final tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tzScheduledTime,
      _getNotificationDetails(mealType),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: null,
      payload: mealType,
    );

    debugPrint(
        '📅 Scheduled: $title at ${scheduledTime.toString().substring(0, 16)}');
  }

  /// Reschedule notifications (call this daily or when app opens)
  Future<void> rescheduleIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(_notificationsEnabledKey) ?? false;

    if (enabled) {
      // Reschedule to ensure we always have 7 days of notifications
      await scheduleAllMealNotifications();
    }
  }

  /// Show an immediate test notification
  Future<void> showTestNotification() async {
    await _notifications.show(
      999,
      '🎉 Notifications Enabled!',
      'You\'ll now receive meal reminders. Bon appétit!',
      _getNotificationDetails('breakfast'),
    );
  }
}
