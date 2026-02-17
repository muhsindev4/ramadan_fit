import 'package:get/get.dart';
import '../../core/services/notification_service.dart';
import '../../core/services/storage_service.dart';

class WaterController extends GetxController {
  final StorageService storage;
  final NotificationService notifications;

  WaterController({required this.storage, required this.notifications});

  final glasses = 0.obs;
  final targetGlasses = 12.obs; // 12 × 250ml = 3L
  final history = <String, int>{}.obs;

  int get totalMl => glasses.value * 250;
  double get progress => (glasses.value / targetGlasses.value).clamp(0.0, 1.0);
  bool get targetReached => glasses.value >= targetGlasses.value;

  @override
  void onInit() {
    super.onInit();
    glasses.value = storage.getTodayWaterGlasses();
    history.value = storage.getWaterHistory(7);
  }

  Future<void> addGlass() async {
    await storage.addWaterGlass();
    glasses.value = storage.getTodayWaterGlasses();

    if (glasses.value == targetGlasses.value) {
      notifications.showNow(
        id: 300,
        title: '🎉 Water Goal Reached!',
        body: 'You drank ${totalMl}ml today. Great job staying hydrated!',
      );
    }
  }

  Future<void> removeGlass() async {
    await storage.removeWaterGlass();
    glasses.value = storage.getTodayWaterGlasses();
  }

  void refreshHistory() {
    history.value = storage.getWaterHistory(7);
  }
}
