class UserProfile {
  final double weight;
  final double height;
  final int age;
  final double targetWeight;

  const UserProfile({
    required this.weight,
    required this.height,
    required this.age,
    required this.targetWeight,
  });

  double get bmi => weight / ((height / 100) * (height / 100));

  String get bmiCategory {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  double get weightToLose => weight - targetWeight;

  double progressPercent(double currentWeight) {
    final total = weight - targetWeight;
    if (total <= 0) return 1.0;
    final lost = weight - currentWeight;
    return (lost / total).clamp(0.0, 1.0);
  }
}

class DailyProgress {
  final int waterGlasses;
  final bool workoutDone;
  final double? weight;
  final DateTime date;

  const DailyProgress({
    required this.waterGlasses,
    required this.workoutDone,
    this.weight,
    required this.date,
  });

  int get waterMl => waterGlasses * 250;
  double get waterProgress => (waterMl / 3000).clamp(0.0, 1.0);
}

class MealItem {
  final String name;
  final int calories;
  final String icon;
  final String protein;
  final bool isCompleted;

  const MealItem({
    required this.name,
    required this.calories,
    required this.icon,
    required this.protein,
    this.isCompleted = false,
  });

  MealItem copyWith({bool? isCompleted}) => MealItem(
        name: name,
        calories: calories,
        icon: icon,
        protein: protein,
        isCompleted: isCompleted ?? this.isCompleted,
      );
}

class WorkoutExercise {
  final String name;
  final String reps;
  final String icon;
  final int sets;
  final int caloriesBurned;
  final bool isCompleted;

  const WorkoutExercise({
    required this.name,
    required this.reps,
    required this.icon,
    required this.sets,
    required this.caloriesBurned,
    this.isCompleted = false,
  });

  WorkoutExercise copyWith({bool? isCompleted}) => WorkoutExercise(
        name: name,
        reps: reps,
        icon: icon,
        sets: sets,
        caloriesBurned: caloriesBurned,
        isCompleted: isCompleted ?? this.isCompleted,
      );
}

class NotificationSchedule {
  final int suhoorHour;
  final int suhoorMinute;
  final int iftarHour;
  final int iftarMinute;
  final int exerciseHour;
  final int exerciseMinute;
  final int waterIntervalMinutes;

  const NotificationSchedule({
    this.suhoorHour = 4,
    this.suhoorMinute = 30,
    this.iftarHour = 18,
    this.iftarMinute = 30,
    this.exerciseHour = 17,
    this.exerciseMinute = 30,
    this.waterIntervalMinutes = 30,
  });
}
