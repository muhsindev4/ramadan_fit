import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/notification_service.dart';
import '../../core/services/storage_service.dart';

class SettingsController extends GetxController {
  final StorageService storage;
  final NotificationService notifications;

  SettingsController({required this.storage, required this.notifications});

  // Notification times
  final suhoorTime = const TimeOfDay(hour: 4, minute: 30).obs;
  final iftarTime = const TimeOfDay(hour: 18, minute: 30).obs;
  final exerciseTime = const TimeOfDay(hour: 17, minute: 30).obs;
  final waterInterval = 30.obs; // minutes

  // Toggles
  final suhoorEnabled = true.obs;
  final iftarEnabled = true.obs;
  final exerciseEnabled = true.obs;
  final waterEnabled = true.obs;

  // User data
  final startWeight = 75.0.obs;
  final targetWeight = 70.0.obs;
  final height = 165.0.obs;
  final age = 25.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  void _loadSettings() {
    suhoorTime.value = TimeOfDay(
      hour: storage.getSetting('suhoor_hour', 4),
      minute: storage.getSetting('suhoor_minute', 30),
    );
    iftarTime.value = TimeOfDay(
      hour: storage.getSetting('iftar_hour', 18),
      minute: storage.getSetting('iftar_minute', 30),
    );
    exerciseTime.value = TimeOfDay(
      hour: storage.getSetting('exercise_hour', 17),
      minute: storage.getSetting('exercise_minute', 30),
    );
    waterInterval.value = storage.getSetting('water_interval', 30);

    suhoorEnabled.value = storage.getSetting('suhoor_enabled', true);
    iftarEnabled.value = storage.getSetting('iftar_enabled', true);
    exerciseEnabled.value = storage.getSetting('exercise_enabled', true);
    waterEnabled.value = storage.getSetting('water_enabled', true);

    startWeight.value = storage.getSetting('start_weight', 75.0);
    targetWeight.value = storage.getSetting('target_weight', 70.0);
    height.value = storage.getSetting('height', 165.0);
    age.value = storage.getSetting('age', 25);
  }

  Future<void> updateSuhoorTime(TimeOfDay time) async {
    suhoorTime.value = time;
    await storage.setSetting('suhoor_hour', time.hour);
    await storage.setSetting('suhoor_minute', time.minute);
    if (suhoorEnabled.value) {
      await notifications.scheduleSuhoor(hour: time.hour, minute: time.minute);
    }
  }

  Future<void> updateIftarTime(TimeOfDay time) async {
    iftarTime.value = time;
    await storage.setSetting('iftar_hour', time.hour);
    await storage.setSetting('iftar_minute', time.minute);
    if (iftarEnabled.value) {
      await notifications.scheduleIftar(hour: time.hour, minute: time.minute);
    }
  }

  Future<void> updateExerciseTime(TimeOfDay time) async {
    exerciseTime.value = time;
    await storage.setSetting('exercise_hour', time.hour);
    await storage.setSetting('exercise_minute', time.minute);
    if (exerciseEnabled.value) {
      await notifications.scheduleExercise(hour: time.hour, minute: time.minute);
    }
  }

  Future<void> toggleSuhoor(bool enabled) async {
    suhoorEnabled.value = enabled;
    await storage.setSetting('suhoor_enabled', enabled);
    if (enabled) {
      await notifications.scheduleSuhoor(
          hour: suhoorTime.value.hour, minute: suhoorTime.value.minute);
    } else {
      await notifications.cancel(100);
    }
  }

  Future<void> toggleIftar(bool enabled) async {
    iftarEnabled.value = enabled;
    await storage.setSetting('iftar_enabled', enabled);
    if (enabled) {
      await notifications.scheduleIftar(
          hour: iftarTime.value.hour, minute: iftarTime.value.minute);
    } else {
      await notifications.cancel(101);
    }
  }

  Future<void> toggleExercise(bool enabled) async {
    exerciseEnabled.value = enabled;
    await storage.setSetting('exercise_enabled', enabled);
    if (enabled) {
      await notifications.scheduleExercise(
          hour: exerciseTime.value.hour, minute: exerciseTime.value.minute);
    } else {
      await notifications.cancel(102);
    }
  }

  Future<void> toggleWater(bool enabled) async {
    waterEnabled.value = enabled;
    await storage.setSetting('water_enabled', enabled);
    if (enabled) {
      await notifications.scheduleWaterReminders(
        iftarHour: iftarTime.value.hour,
        suhoorHour: suhoorTime.value.hour,
        intervalMinutes: waterInterval.value,
      );
    } else {
      for (int i = 200; i <= 220; i++) {
        await notifications.cancel(i);
      }
    }
  }

  Future<void> updateUserData({
    double? weight,
    double? target,
    double? h,
    int? a,
  }) async {
    if (weight != null) {
      startWeight.value = weight;
      await storage.setSetting('start_weight', weight);
    }
    if (target != null) {
      targetWeight.value = target;
      await storage.setSetting('target_weight', target);
    }
    if (h != null) {
      height.value = h;
      await storage.setSetting('height', h);
    }
    if (a != null) {
      age.value = a;
      await storage.setSetting('age', a);
    }
  }

  Future<void> scheduleAllNotifications() async {
    if (suhoorEnabled.value) {
      await notifications.scheduleSuhoor(
          hour: suhoorTime.value.hour, minute: suhoorTime.value.minute);
    }
    if (iftarEnabled.value) {
      await notifications.scheduleIftar(
          hour: iftarTime.value.hour, minute: iftarTime.value.minute);
    }
    if (exerciseEnabled.value) {
      await notifications.scheduleExercise(
          hour: exerciseTime.value.hour, minute: exerciseTime.value.minute);
    }
    if (waterEnabled.value) {
      await notifications.scheduleWaterReminders(
        iftarHour: iftarTime.value.hour,
        suhoorHour: suhoorTime.value.hour,
        intervalMinutes: waterInterval.value,
      );
    }
  }
}
