import 'package:get/get.dart';
import '../../core/services/storage_service.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/entities.dart';

class WorkoutController extends GetxController {
  final StorageService storage;

  WorkoutController({required this.storage});

  final exercises = <WorkoutExercise>[].obs;
  final isWorkoutDone = false.obs;
  final streak = 0.obs;
  final currentSet = 1.obs;
  final totalSets = 3.obs;

  int get totalCalories =>
      exercises.where((e) => e.isCompleted).fold(0, (sum, e) => sum + e.caloriesBurned * e.sets);

  bool get allExercisesDone => exercises.every((e) => e.isCompleted);

  @override
  void onInit() {
    super.onInit();
    _loadExercises();
    isWorkoutDone.value = storage.isTodayWorkoutDone();
    streak.value = storage.getWorkoutStreak();

    // After day 10, increase to 4 sets
    final startDate = DateTime.tryParse(
        storage.getSetting('start_date', DateTime.now().toIso8601String()));
    if (startDate != null) {
      final day = DateTime.now().difference(startDate).inDays + 1;
      if (day > 10) {
        totalSets.value = 4;
      }
    }
  }

  void _loadExercises() {
    exercises.value = MealData.workouts.map((w) {
      return WorkoutExercise(
        name: w['name'] as String,
        reps: (w['reps'] ?? w['duration'] ?? '') as String,
        icon: w['icon'] as String,
        sets: w['sets'] as int,
        caloriesBurned: w['calories'] as int,
      );
    }).toList();
  }

  void toggleExercise(int index) {
    final ex = exercises[index];
    exercises[index] = ex.copyWith(isCompleted: !ex.isCompleted);

    if (allExercisesDone) {
      if (currentSet.value < totalSets.value) {
        // Reset for next set
        currentSet.value++;
        for (int i = 0; i < exercises.length; i++) {
          exercises[i] = exercises[i].copyWith(isCompleted: false);
        }
      } else {
        _markWorkoutComplete();
      }
    }
  }

  Future<void> _markWorkoutComplete() async {
    isWorkoutDone.value = true;
    await storage.markWorkoutDone();
    streak.value = storage.getWorkoutStreak();
  }

  void resetWorkout() {
    currentSet.value = 1;
    for (int i = 0; i < exercises.length; i++) {
      exercises[i] = exercises[i].copyWith(isCompleted: false);
    }
  }
}
