import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  StorageService._();
  static final instance = StorageService._();

  late Box _settingsBox;
  late Box _waterBox;
  late Box _workoutBox;
  late Box _weightBox;

  Future<void> init() async {
    await Hive.initFlutter();
    _settingsBox = await Hive.openBox('settings');
    _waterBox = await Hive.openBox('water');
    _workoutBox = await Hive.openBox('workout');
    _weightBox = await Hive.openBox('weight');
  }

  // ─── Settings ───
  T getSetting<T>(String key, T defaultValue) =>
      _settingsBox.get(key, defaultValue: defaultValue) as T;

  Future<void> setSetting(String key, dynamic value) =>
      _settingsBox.put(key, value);

  // ─── Water Intake ───
  String get _todayKey {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  int getTodayWaterGlasses() =>
      _waterBox.get(_todayKey, defaultValue: 0) as int;

  Future<void> addWaterGlass() async {
    final current = getTodayWaterGlasses();
    await _waterBox.put(_todayKey, current + 1);
  }

  Future<void> removeWaterGlass() async {
    final current = getTodayWaterGlasses();
    if (current > 0) {
      await _waterBox.put(_todayKey, current - 1);
    }
  }

  Map<String, int> getWaterHistory(int days) {
    final history = <String, int>{};
    for (int i = 0; i < days; i++) {
      final date = DateTime.now().subtract(Duration(days: i));
      final key = '${date.year}-${date.month}-${date.day}';
      history[key] = _waterBox.get(key, defaultValue: 0) as int;
    }
    return history;
  }

  // ─── Workout Tracking ───
  bool isTodayWorkoutDone() =>
      _workoutBox.get(_todayKey, defaultValue: false) as bool;

  Future<void> markWorkoutDone() => _workoutBox.put(_todayKey, true);

  int getWorkoutStreak() {
    int streak = 0;
    for (int i = 0; i < 60; i++) {
      final date = DateTime.now().subtract(Duration(days: i));
      final key = '${date.year}-${date.month}-${date.day}';
      if (_workoutBox.get(key, defaultValue: false) as bool) {
        streak++;
      } else if (i > 0) {
        break;
      }
    }
    return streak;
  }

  Map<String, bool> getWorkoutHistory(int days) {
    final history = <String, bool>{};
    for (int i = 0; i < days; i++) {
      final date = DateTime.now().subtract(Duration(days: i));
      final key = '${date.year}-${date.month}-${date.day}';
      history[key] = _workoutBox.get(key, defaultValue: false) as bool;
    }
    return history;
  }

  // ─── Weight Tracking ───
  Future<void> logWeight(double weight) async {
    await _weightBox.put(_todayKey, weight);
  }

  double? getTodayWeight() => _weightBox.get(_todayKey) as double?;

  Map<String, double> getWeightHistory(int days) {
    final history = <String, double>{};
    for (int i = 0; i < days; i++) {
      final date = DateTime.now().subtract(Duration(days: i));
      final key = '${date.year}-${date.month}-${date.day}';
      final weight = _weightBox.get(key);
      if (weight != null) {
        history[key] = weight as double;
      }
    }
    return history;
  }

  double get startWeight => getSetting('start_weight', 75.0);
  double get targetWeight => getSetting('target_weight', 70.0);
  double get height => getSetting('height', 165.0);
  int get age => getSetting('age', 25);
}
