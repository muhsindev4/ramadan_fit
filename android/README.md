# 🌙 Ramadan Fit - 30 Day Transformation App

## Architecture
```
lib/
├── core/
│   ├── constants/      # Colors, strings, meal data
│   ├── services/       # NotificationService, StorageService
│   └── theme/          # Dark theme with Google Fonts
├── data/               # (Extensible - repos, datasources)
├── domain/
│   └── entities/       # UserProfile, DailyProgress, MealItem, etc.
├── presentation/
│   ├── controllers/    # GetX controllers (Home, Water, Workout, Settings)
│   ├── pages/          # All screens
│   └── widgets/        # Reusable UI components
├── di/
│   └── injection.dart  # GetIt dependency injection
├── routes/
│   └── app_router.dart # GoRouter with ShellRoute
└── main.dart
```

## Setup

### 1. Android Permissions
Add to `android/app/src/main/AndroidManifest.xml` (inside `<manifest>`):

```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.USE_EXACT_ALARM" />
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

Add inside `<application>`:

```xml
<receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
<receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
        <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
        <action android:name="android.intent.action.QUICKBOOT_POWERON" />
        <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
    </intent-filter>
</receiver>
```

### 2. iOS Setup
In `ios/Runner/AppDelegate.swift`:

```swift
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
      GeneratedPluginRegistrant.register(with: registry)
    }

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

### 3. Run
```bash
flutter pub get
flutter run
```

## Notification System
The app handles all three states:
- **Foreground**: `onDidReceiveNotificationResponse` callback
- **Background**: `@pragma('vm:entry-point')` annotated `notificationTapBackground`
- **Terminated**: `BOOT_COMPLETED` receiver reschedules + `zonedSchedule` with `matchDateTimeComponents`

### Notification IDs
| ID Range | Type |
|----------|------|
| 100 | Suhoor |
| 101 | Iftar |
| 102 | Exercise |
| 200-220 | Water (interval) |
| 300 | Water goal reached |

## Features
- 📊 BMI tracking & weight logging
- 🍽 Complete meal plan (Suhoor/Iftar/Dinner)
- 🏃 Workout tracker with set/rep counting
- 💧 Water intake tracker with glass visualization
- 📈 Progress tracking with history
- 🔔 Configurable notifications for all events
- 🌙 Phase-based tips (Day 1-10, 11-20, 21-30)

## Tech Stack
- **State**: GetX (reactive)
- **DI**: GetIt (lazy singletons)
- **Router**: GoRouter (ShellRoute for bottom nav)
- **Storage**: Hive (local persistence)
- **Notifications**: flutter_local_notifications
- **UI**: Google Fonts, Iconsax, percent_indicator
