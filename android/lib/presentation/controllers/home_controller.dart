import 'package:get/get.dart';
import '../../core/services/notification_service.dart';
import '../../core/services/storage_service.dart';
import '../../domain/entities/entities.dart';

class HomeController extends GetxController {
  final StorageService storage;
  final NotificationService notifications;

  HomeController({required this.storage, required this.notifications});

  final currentDay = 1.obs;
  final currentWeight = 75.0.obs;
  final waterGlasses = 0.obs;
  final workoutDone = false.obs;
  final streak = 0.obs;

  UserProfile get profile => UserProfile(
        weight: storage.startWeight,
        height: storage.height,
        age: storage.age,
        targetWeight: storage.targetWeight,
      );

  double get progressPercent =>
      profile.progressPercent(currentWeight.value);

  double get bmi => currentWeight.value / ((storage.height / 100) * (storage.height / 100));

  @override
  void onInit() {
    super.onInit();
    _loadTodayData();
    _calculateDay();
  }

  void _loadTodayData() {
    waterGlasses.value = storage.getTodayWaterGlasses();
    workoutDone.value = storage.isTodayWorkoutDone();
    streak.value = storage.getWorkoutStreak();

    final todayWeight = storage.getTodayWeight();
    if (todayWeight != null) {
      currentWeight.value = todayWeight;
    } else {
      currentWeight.value = storage.startWeight;
    }
  }

  void _calculateDay() {
    final startDate = DateTime.tryParse(
        storage.getSetting('start_date', DateTime.now().toIso8601String()));
    if (startDate != null) {
      currentDay.value = DateTime.now().difference(startDate).inDays + 1;
      if (currentDay.value > 30) currentDay.value = 30;
      if (currentDay.value < 1) currentDay.value = 1;
    }
  }

  Future<void> logWeight(double weight) async {
    currentWeight.value = weight;
    await storage.logWeight(weight);
  }

  void refresh() => _loadTodayData();
}
