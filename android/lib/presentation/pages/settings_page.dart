import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/constants/app_constants.dart';
import '../../di/injection.dart';
import '../controllers/settings_controller.dart';
import '../widgets/glass_card.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = getIt<SettingsController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Iconsax.arrow_left_2, color: AppColors.textPrimary),
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification Settings
            _SectionTitle(title: '🔔 Notifications'),
            const SizedBox(height: 12),

            Obx(() => _NotificationTile(
                  title: 'Suhoor Reminder',
                  subtitle: _formatTime(ctrl.suhoorTime.value),
                  icon: Iconsax.moon,
                  color: const Color(0xFF6C63FF),
                  enabled: ctrl.suhoorEnabled.value,
                  onToggle: ctrl.toggleSuhoor,
                  onTimeTap: () => _pickTime(
                    context,
                    ctrl.suhoorTime.value,
                    ctrl.updateSuhoorTime,
                  ),
                )),
            const SizedBox(height: 8),

            Obx(() => _NotificationTile(
                  title: 'Iftar Reminder',
                  subtitle: _formatTime(ctrl.iftarTime.value),
                  icon: Iconsax.sun_1,
                  color: AppColors.secondary,
                  enabled: ctrl.iftarEnabled.value,
                  onToggle: ctrl.toggleIftar,
                  onTimeTap: () => _pickTime(
                    context,
                    ctrl.iftarTime.value,
                    ctrl.updateIftarTime,
                  ),
                )),
            const SizedBox(height: 8),

            Obx(() => _NotificationTile(
                  title: 'Exercise Reminder',
                  subtitle: _formatTime(ctrl.exerciseTime.value),
                  icon: Iconsax.weight,
                  color: AppColors.accent,
                  enabled: ctrl.exerciseEnabled.value,
                  onToggle: ctrl.toggleExercise,
                  onTimeTap: () => _pickTime(
                    context,
                    ctrl.exerciseTime.value,
                    ctrl.updateExerciseTime,
                  ),
                )),
            const SizedBox(height: 8),

            Obx(() => _NotificationTile(
                  title: 'Water Reminders',
                  subtitle: 'Every ${ctrl.waterInterval.value} min',
                  icon: Iconsax.drop,
                  color: AppColors.water,
                  enabled: ctrl.waterEnabled.value,
                  onToggle: ctrl.toggleWater,
                  onTimeTap: () => _showWaterIntervalPicker(context, ctrl),
                )),
            const SizedBox(height: 24),

            // User Data
            _SectionTitle(title: '📊 Body Data'),
            const SizedBox(height: 12),

            Obx(() => GlassCard(
                  child: Column(
                    children: [
                      _DataRow(
                        label: 'Current Weight',
                        value: '${ctrl.startWeight.value.toStringAsFixed(1)} kg',
                        onTap: () => _showNumberInput(
                          context,
                          title: 'Start Weight (kg)',
                          initial: ctrl.startWeight.value,
                          onSave: (v) => ctrl.updateUserData(weight: v),
                        ),
                      ),
                      const Divider(color: AppColors.surfaceLight, height: 1),
                      _DataRow(
                        label: 'Target Weight',
                        value: '${ctrl.targetWeight.value.toStringAsFixed(1)} kg',
                        onTap: () => _showNumberInput(
                          context,
                          title: 'Target Weight (kg)',
                          initial: ctrl.targetWeight.value,
                          onSave: (v) => ctrl.updateUserData(target: v),
                        ),
                      ),
                      const Divider(color: AppColors.surfaceLight, height: 1),
                      _DataRow(
                        label: 'Height',
                        value: '${ctrl.height.value.toStringAsFixed(0)} cm',
                        onTap: () => _showNumberInput(
                          context,
                          title: 'Height (cm)',
                          initial: ctrl.height.value,
                          onSave: (v) => ctrl.updateUserData(h: v),
                        ),
                      ),
                      const Divider(color: AppColors.surfaceLight, height: 1),
                      _DataRow(
                        label: 'Age',
                        value: '${ctrl.age.value}',
                        onTap: () => _showNumberInput(
                          context,
                          title: 'Age',
                          initial: ctrl.age.value.toDouble(),
                          onSave: (v) => ctrl.updateUserData(a: v.toInt()),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 24),

            // Schedule All Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () async {
                  await ctrl.scheduleAllNotifications();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('All notifications scheduled! ✅'),
                        backgroundColor: AppColors.success,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Schedule All Notifications',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> _pickTime(
    BuildContext context,
    TimeOfDay initial,
    Function(TimeOfDay) onUpdate,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              surface: AppColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) onUpdate(picked);
  }

  void _showWaterIntervalPicker(BuildContext context, SettingsController ctrl) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Water Reminder Interval',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            ...([20, 30, 45, 60].map((mins) => ListTile(
                  onTap: () {
                    ctrl.waterInterval.value = mins;
                    ctrl.storage.setSetting('water_interval', mins);
                    if (ctrl.waterEnabled.value) ctrl.toggleWater(true);
                    Navigator.pop(context);
                  },
                  title: Text(
                    'Every $mins minutes',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  trailing: ctrl.waterInterval.value == mins
                      ? const Icon(Icons.check_circle, color: AppColors.water)
                      : null,
                ))),
          ],
        ),
      ),
    );
  }

  void _showNumberInput(
    BuildContext context, {
    required String title,
    required double initial,
    required Function(double) onSave,
  }) {
    final controller = TextEditingController(text: initial.toStringAsFixed(1));
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary),
        ),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surfaceLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: GoogleFonts.plusJakartaSans(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              final val = double.tryParse(controller.text);
              if (val != null) {
                onSave(val);
                Navigator.pop(context);
              }
            },
            child: Text('Save',
                style: GoogleFonts.plusJakartaSans(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool enabled;
  final Function(bool) onToggle;
  final VoidCallback onTimeTap;

  const _NotificationTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.enabled,
    required this.onToggle,
    required this.onTimeTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: enabled ? onTimeTap : null,
                  child: Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: enabled ? color : AppColors.textSecondary,
                      fontWeight: enabled ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: enabled,
            onChanged: onToggle,
            activeColor: color,
          ),
        ],
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _DataRow({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Iconsax.edit_2, size: 16, color: AppColors.textSecondary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
