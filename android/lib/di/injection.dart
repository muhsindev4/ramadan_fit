import 'package:get_it/get_it.dart';
import '../core/services/notification_service.dart';
import '../core/services/storage_service.dart';
import '../presentation/controllers/home_controller.dart';
import '../presentation/controllers/water_controller.dart';
import '../presentation/controllers/workout_controller.dart';
import '../presentation/controllers/settings_controller.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // ─── Services (Singletons) ───
  getIt.registerSingleton<StorageService>(StorageService.instance);
  getIt.registerSingleton<NotificationService>(NotificationService.instance);

  // ─── Controllers (Lazy Singletons) ───
  getIt.registerLazySingleton<HomeController>(
    () => HomeController(
      storage: getIt<StorageService>(),
      notifications: getIt<NotificationService>(),
    ),
  );

  getIt.registerLazySingleton<WaterController>(
    () => WaterController(
      storage: getIt<StorageService>(),
      notifications: getIt<NotificationService>(),
    ),
  );

  getIt.registerLazySingleton<WorkoutController>(
    () => WorkoutController(storage: getIt<StorageService>()),
  );

  getIt.registerLazySingleton<SettingsController>(
    () => SettingsController(
      storage: getIt<StorageService>(),
      notifications: getIt<NotificationService>(),
    ),
  );
}
