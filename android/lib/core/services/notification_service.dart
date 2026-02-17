import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import '../constants/app_constants.dart';

/// Top-level callback for background/terminated notification taps
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse details) {
  debugPrint('BG notification tapped: ${details.payload}');
}

class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  /// Initialize timezone + notification plugin.
  /// Must be called in main() before runApp.
  Future<void> init() async {
    if (_initialized) return;

    // Timezone setup
    tz.initializeTimeZones();
    final tzName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(tzName));

    // Android init
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS/macOS init
    const darwinInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: darwinInit,
      macOS: darwinInit,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onForegroundTap,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // Create Android notification channels
    await _createChannels();

    // Request permissions
    await _requestPermissions();

    _initialized = true;
    debugPrint('✅ NotificationService initialized');
  }

  Future<void> _createChannels() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return;

    final channels = [
      const AndroidNotificationChannel(
        NotificationChannels.suhoorId,
        NotificationChannels.suhoorName,
        description: 'Suhoor meal reminders',
        importance: Importance.high,
        enableVibration: true,
        playSound: true,
      ),
      const AndroidNotificationChannel(
        NotificationChannels.iftarId,
        NotificationChannels.iftarName,
        description: 'Iftar time reminders',
        importance: Importance.high,
        enableVibration: true,
        playSound: true,
      ),
      const AndroidNotificationChannel(
        NotificationChannels.waterId,
        NotificationChannels.waterName,
        description: 'Water intake reminders',
        importance: Importance.defaultImportance,
        enableVibration: true,
      ),
      const AndroidNotificationChannel(
        NotificationChannels.exerciseId,
        NotificationChannels.exerciseName,
        description: 'Workout reminders',
        importance: Importance.high,
        enableVibration: true,
      ),
    ];

    for (final ch in channels) {
      await android.createNotificationChannel(ch);
    }
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await android?.requestNotificationsPermission();
      await android?.requestExactAlarmsPermission();
    } else if (Platform.isIOS) {
      final ios = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      await ios?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  void _onForegroundTap(NotificationResponse details) {
    debugPrint('FG notification tapped: ${details.payload}');
    // Handle navigation based on payload
  }

  // ─── Immediate Notification ───
  Future<void> showNow({
    required int id,
    required String title,
    required String body,
    String channelId = NotificationChannels.waterId,
    String channelName = NotificationChannels.waterName,
    String? payload,
  }) async {
    await _plugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          styleInformation: BigTextStyleInformation(body),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }

  // ─── Scheduled Notification ───
  Future<void> scheduleDaily({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    required String channelId,
    required String channelName,
    String? payload,
  }) async {
    final scheduledDate = _nextInstanceOfTime(hour, minute);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          styleInformation: BigTextStyleInformation(body),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // ─── Schedule Water Reminders (interval-based between iftar & suhoor) ───
  Future<void> scheduleWaterReminders({
    required int iftarHour,
    required int suhoorHour,
    required int intervalMinutes,
  }) async {
    // Cancel old water notifications (IDs 200-220)
    for (int i = 200; i <= 220; i++) {
      await _plugin.cancel(i);
    }

    int id = 200;
    int currentHour = iftarHour;
    int currentMinute = 30; // Start 30 min after iftar

    while (currentHour < suhoorHour || (currentHour == suhoorHour && currentMinute == 0)) {
      await scheduleDaily(
        id: id,
        title: '💧 Drink Water!',
        body: 'Stay hydrated! Have a glass of water now. Target: 2.5-3L',
        hour: currentHour % 24,
        minute: currentMinute,
        channelId: NotificationChannels.waterId,
        channelName: NotificationChannels.waterName,
        payload: 'water',
      );

      currentMinute += intervalMinutes;
      if (currentMinute >= 60) {
        currentHour += currentMinute ~/ 60;
        currentMinute = currentMinute % 60;
      }
      id++;
      if (id > 220) break; // Safety limit
    }
  }

  // ─── Schedule Suhoor Reminder ───
  Future<void> scheduleSuhoor({required int hour, required int minute}) async {
    // 30 min before suhoor ends
    int reminderMinute = minute - 30;
    int reminderHour = hour;
    if (reminderMinute < 0) {
      reminderMinute += 60;
      reminderHour -= 1;
    }

    await scheduleDaily(
      id: 100,
      title: '🌙 Suhoor Time!',
      body: 'Wake up for Suhoor! Eat: 2 eggs, 1 banana, 1 chapati & drink 2 glasses water.',
      hour: reminderHour,
      minute: reminderMinute,
      channelId: NotificationChannels.suhoorId,
      channelName: NotificationChannels.suhoorName,
      payload: 'suhoor',
    );
  }

  // ─── Schedule Iftar Reminder ───
  Future<void> scheduleIftar({required int hour, required int minute}) async {
    // 15 min before iftar
    int reminderMinute = minute - 15;
    int reminderHour = hour;
    if (reminderMinute < 0) {
      reminderMinute += 60;
      reminderHour -= 1;
    }

    await scheduleDaily(
      id: 101,
      title: '🌇 Iftar in 15 minutes!',
      body: 'Prepare for Iftar! Start with 2 dates + water. No fried snacks!',
      hour: reminderHour,
      minute: reminderMinute,
      channelId: NotificationChannels.iftarId,
      channelName: NotificationChannels.iftarName,
      payload: 'iftar',
    );
  }

  // ─── Schedule Exercise Reminder ───
  Future<void> scheduleExercise({required int hour, required int minute}) async {
    await scheduleDaily(
      id: 102,
      title: '🏃 Workout Time!',
      body: 'Time for your fat-burning session! 15 Squats, 10 Push-ups, 30s Plank × 3 sets',
      hour: hour,
      minute: minute,
      channelId: NotificationChannels.exerciseId,
      channelName: NotificationChannels.exerciseName,
      payload: 'exercise',
    );
  }

  // ─── Cancel All ───
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  Future<void> cancel(int id) async {
    await _plugin.cancel(id);
  }

  // ─── Get Pending Notifications ───
  Future<List<PendingNotificationRequest>> getPending() async {
    return _plugin.pendingNotificationRequests();
  }

  // ─── Helper: next occurrence of HH:mm ───
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
