import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ramadan_fit/presentation/pages/splash_page.dart';
import 'core/services/notification_service.dart';
import 'core/services/storage_service.dart';
import 'core/theme/app_theme.dart';
import 'di/injection.dart';
import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Set system UI
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF161929),
  ));

  // Initialize services
  await StorageService.instance.init();
  await NotificationService.instance.init();

  // Set start date if first launch
  final startDate = StorageService.instance.getSetting<String?>('start_date', null);
  if (startDate == null) {
    await StorageService.instance.setSetting('start_date', DateTime.now().toIso8601String());
  }

  // Setup DI
  await setupDependencies();

  runApp(const RamadanFitApp());
}

class RamadanFitApp extends StatelessWidget {
  const RamadanFitApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp.router(
      title: 'Ramadan Fit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
