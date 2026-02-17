import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/constants/app_constants.dart';
import '../../di/injection.dart';
import '../controllers/workout_controller.dart';
import '../widgets/glass_card.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = getIt<WorkoutController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🏃 Workout',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Obx(() => Text(
                    ctrl.isWorkoutDone.value
                        ? 'Great job! Workout complete! 🔥'
                        : 'Before Iftar is best for fat burn',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  )),
              const SizedBox(height: 24),

              // Status Card
              Obx(() => GlassCard(
                    gradient: ctrl.isWorkoutDone.value
                        ? LinearGradient(
                            colors: [
                              AppColors.success.withValues(alpha: 0.3),
                              AppColors.primary.withValues(alpha: 0.2),
                            ],
                          )
                        : null,
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: ctrl.isWorkoutDone.value
                                ? AppColors.success.withValues(alpha: 0.2)
                                : AppColors.secondary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            ctrl.isWorkoutDone.value
                                ? Icons.check_circle_rounded
                                : Iconsax.flash_1,
                            color: ctrl.isWorkoutDone.value
                                ? AppColors.success
                                : AppColors.secondary,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Set ${ctrl.currentSet.value} of ${ctrl.totalSets.value}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '🔥 ${ctrl.totalCalories} cal burned • ${ctrl.streak.value} day streak',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 16),

              // Exercises
              Obx(() => Column(
                    children: ctrl.exercises.asMap().entries.map((entry) {
                      final i = entry.key;
                      final ex = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: ctrl.isWorkoutDone.value
                              ? null
                              : () => ctrl.toggleExercise(i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: ex.isCompleted
                                  ? AppColors.success.withValues(alpha: 0.1)
                                  : AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: ex.isCompleted
                                    ? AppColors.success.withValues(alpha: 0.3)
                                    : AppColors.surfaceLight.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(ex.icon, style: const TextStyle(fontSize: 32)),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ex.name,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                          decoration: ex.isCompleted
                                              ? TextDecoration.lineThrough
                                              : null,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${ex.reps} • ${ex.caloriesBurned} cal',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 13,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: ex.isCompleted
                                        ? AppColors.success
                                        : Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: ex.isCompleted
                                          ? AppColors.success
                                          : AppColors.textSecondary,
                                      width: 2,
                                    ),
                                  ),
                                  child: ex.isCompleted
                                      ? const Icon(Icons.check,
                                          size: 18, color: Colors.white)
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  )),

              const SizedBox(height: 16),

              // Reset button
              Obx(() {
                if (!ctrl.isWorkoutDone.value) return const SizedBox.shrink();
                return Center(
                  child: TextButton.icon(
                    onPressed: ctrl.resetWorkout,
                    icon: const Icon(Iconsax.refresh, size: 18),
                    label: Text(
                      'Reset Workout',
                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                    ),
                  ),
                );
              }),

              const SizedBox(height: 16),

              // Info card
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📋 Workout Plan',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _infoRow('Days 1-10', '3 sets of each exercise'),
                    _infoRow('Days 11-30', '4 sets (increase intensity)'),
                    _infoRow('Best time', '20-30 min before Iftar'),
                    _infoRow('Alt time', 'After Iftar (4 sets)'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
