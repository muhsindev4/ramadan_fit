import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../core/constants/app_constants.dart';
import '../../di/injection.dart';
import '../controllers/home_controller.dart';
import '../controllers/water_controller.dart';
import '../controllers/workout_controller.dart';
import '../widgets/glass_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final home = getIt<HomeController>();
    final water = getIt<WaterController>();
    final workout = getIt<WorkoutController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => home.refresh(),
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(context, home),
                const SizedBox(height: 24),

                // Day Progress Card
                _buildDayCard(home),
                const SizedBox(height: 16),

                // BMI & Weight Card
                _buildBmiCard(home),
                const SizedBox(height: 16),

                // Quick Stats Row
                _buildQuickStats(water, workout),
                const SizedBox(height: 16),

                // Target Card
                _buildTargetCard(home),
                const SizedBox(height: 16),

                // Tips Card
                _buildTipsCard(home),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, HomeController home) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🌙 Ramadan Fit',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Obx(() => Text(
                  'Day ${home.currentDay.value} of 30',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                )),
          ],
        ),
        GestureDetector(
          onTap: () => context.push(AppStrings.settingsRoute),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.surfaceLight.withValues(alpha: 0.3),
              ),
            ),
            child: const Icon(Iconsax.setting_2, color: AppColors.textSecondary, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildDayCard(HomeController home) {
    return Obx(() {
      final day = home.currentDay.value;
      final progress = day / 30;
      return GlassCard(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.3),
            AppColors.primaryDark.withValues(alpha: 0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircularPercentIndicator(
              radius: 40,
              lineWidth: 6,
              percent: progress,
              center: Text(
                '${(progress * 100).toInt()}%',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              progressColor: AppColors.secondary,
              backgroundColor: AppColors.surfaceLight,
              circularStrokeCap: CircularStrokeCap.round,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Day $day of 30',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    day <= 10
                        ? 'Phase 1: Building habits 💪'
                        : day <= 20
                            ? 'Phase 2: Increasing intensity 🔥'
                            : 'Phase 3: Final push! 🏆',
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
      );
    });
  }

  Widget _buildBmiCard(HomeController home) {
    return Obx(() {
      final bmi = home.bmi;
      final bmiLabel = bmi < 18.5
          ? 'Underweight'
          : bmi < 25
              ? 'Normal'
              : bmi < 30
                  ? 'Overweight'
                  : 'Obese';
      final bmiColor = bmi < 18.5
          ? AppColors.water
          : bmi < 25
              ? AppColors.success
              : bmi < 30
                  ? AppColors.warning
                  : AppColors.error;

      return GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Body Stats',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: bmiColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    bmiLabel,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: bmiColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _StatPill(
                  label: 'Weight',
                  value: '${home.currentWeight.value.toStringAsFixed(1)} kg',
                  icon: Iconsax.weight_1,
                ),
                const SizedBox(width: 12),
                _StatPill(
                  label: 'BMI',
                  value: bmi.toStringAsFixed(1),
                  icon: Iconsax.health,
                ),
                const SizedBox(width: 12),
                _StatPill(
                  label: 'Target',
                  value: '${home.profile.targetWeight.toStringAsFixed(0)} kg',
                  icon: Iconsax.flag,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildQuickStats(WaterController water, WorkoutController workout) {
    return Row(
      children: [
        Expanded(
          child: Obx(() => GlassCard(
                onTap: null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.water.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Iconsax.drop, color: AppColors.water, size: 18),
                        ),
                        const Spacer(),
                        Text(
                          '${water.glasses.value}/${water.targetGlasses.value}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: water.progress,
                        backgroundColor: AppColors.surfaceLight,
                        valueColor: const AlwaysStoppedAnimation(AppColors.water),
                        minHeight: 4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Water (${water.totalMl}ml)',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              )),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Obx(() => GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:
                              const Icon(Iconsax.flash_1, color: AppColors.secondary, size: 18),
                        ),
                        const Spacer(),
                        Icon(
                          workout.isWorkoutDone.value
                              ? Icons.check_circle_rounded
                              : Icons.circle_outlined,
                          color: workout.isWorkoutDone.value
                              ? AppColors.success
                              : AppColors.textSecondary,
                          size: 22,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      workout.isWorkoutDone.value ? 'Done! 🔥' : 'Pending',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Streak: ${workout.streak.value} days',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ],
    );
  }

  Widget _buildTargetCard(HomeController home) {
    return Obx(() {
      final lost = home.profile.weight - home.currentWeight.value;
      final remaining = home.currentWeight.value - home.profile.targetWeight;
      return GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🎯 30-Day Target',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _TargetItem(
                  label: 'Lost',
                  value: '${lost.toStringAsFixed(1)} kg',
                  color: AppColors.success,
                ),
                Container(width: 1, height: 40, color: AppColors.surfaceLight),
                _TargetItem(
                  label: 'Remaining',
                  value: '${remaining.toStringAsFixed(1)} kg',
                  color: AppColors.warning,
                ),
                Container(width: 1, height: 40, color: AppColors.surfaceLight),
                _TargetItem(
                  label: 'Goal',
                  value: '70-72 kg',
                  color: AppColors.primary,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTipsCard(HomeController home) {
    return Obx(() {
      final day = home.currentDay.value;
      final tips = day <= 10
          ? [
              '💡 No fried snacks at Iftar',
              '💡 Walk 20 min before Iftar',
              '💡 Reduce salt for less face puffiness',
            ]
          : day <= 20
              ? [
                  '💡 Increase to 4 sets from now',
                  '💡 No rice at dinner',
                  '💡 Sleep 6-7 hours minimum',
                ]
              : [
                  '💡 Push through! Results are showing',
                  '💡 Keep water intake at 3L',
                  '💡 Maintain the workout streak!',
                ];

      return GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Tips',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ...tips.map((tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    tip,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                )),
          ],
        ),
      );
    });
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatPill({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 16),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TargetItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _TargetItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
