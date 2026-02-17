import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../core/constants/app_constants.dart';
import '../../di/injection.dart';
import '../controllers/water_controller.dart';
import '../widgets/glass_card.dart';

class WaterPage extends StatelessWidget {
  const WaterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = getIt<WaterController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '💧 Water Tracker',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Target: 2.5-3L between Iftar & Suhoor',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // Big Progress Circle
              Center(
                child: Obx(() => CircularPercentIndicator(
                      radius: 100,
                      lineWidth: 14,
                      percent: ctrl.progress,
                      center: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${ctrl.totalMl}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'ml / 3000ml',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          if (ctrl.targetReached)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                '🎉 Goal!',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.success,
                                ),
                              ),
                            ),
                        ],
                      ),
                      progressColor: AppColors.water,
                      backgroundColor: AppColors.surfaceLight,
                      circularStrokeCap: CircularStrokeCap.round,
                      animation: true,
                      animationDuration: 500,
                    )),
              ),
              const SizedBox(height: 32),

              // Add/Remove Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _CircleButton(
                    icon: Iconsax.minus,
                    onTap: ctrl.removeGlass,
                    color: AppColors.accent,
                  ),
                  const SizedBox(width: 24),
                  Obx(() => Column(
                        children: [
                          Text(
                            '${ctrl.glasses.value}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 48,
                              fontWeight: FontWeight.w800,
                              color: AppColors.water,
                            ),
                          ),
                          Text(
                            'glasses',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(width: 24),
                  _CircleButton(
                    icon: Iconsax.add,
                    onTap: ctrl.addGlass,
                    color: AppColors.water,
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Glass Visualization
              Obx(() => _buildGlassGrid(ctrl.glasses.value, ctrl.targetGlasses.value)),
              const SizedBox(height: 24),

              // Weekly History
              Obx(() {
                ctrl.refreshHistory();
                final history = ctrl.history;
                if (history.isEmpty) return const SizedBox.shrink();

                return GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '📊 Last 7 Days',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: history.entries.toList().reversed.map((entry) {
                            final glasses = entry.value;
                            final height = (glasses / 12 * 60).clamp(4.0, 60.0);
                            final parts = entry.key.split('-');
                            final label = parts.length >= 3 ? '${parts[2]}/${parts[1]}' : '';
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '$glasses',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  width: 28,
                                  height: height,
                                  decoration: BoxDecoration(
                                    color: glasses >= 12
                                        ? AppColors.success
                                        : AppColors.water.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  label,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 9,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassGrid(int filled, int total) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: List.generate(total, (i) {
        final isFilled = i < filled;
        return AnimatedContainer(
          duration: Duration(milliseconds: 200 + i * 30),
          width: 44,
          height: 52,
          decoration: BoxDecoration(
            color: isFilled
                ? AppColors.water.withValues(alpha: 0.2)
                : AppColors.surfaceLight.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isFilled
                  ? AppColors.water.withValues(alpha: 0.5)
                  : AppColors.surfaceLight,
            ),
          ),
          child: Center(
            child: Text(
              isFilled ? '💧' : '○',
              style: TextStyle(
                fontSize: isFilled ? 20 : 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _CircleButton({
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.4), width: 2),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}
