import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constants.dart';
import '../widgets/glass_card.dart';

class MealPlanPage extends StatelessWidget {
  const MealPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🍽 Meal Plan',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Your daily nutrition guide for fat loss',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // Suhoor
              _MealSection(
                title: '🌙 Suhoor',
                subtitle: 'Pre-dawn meal',
                color: const Color(0xFF6C63FF),
                items: MealData.suhoorMeals,
                note: '👉 1 chapati is enough, not 2',
              ),
              const SizedBox(height: 16),

              // Iftar Step 1
              _MealSection(
                title: '🌇 Iftar - Step 1',
                subtitle: 'Break your fast',
                color: AppColors.secondary,
                items: MealData.iftarStep1,
                note: null,
              ),
              const SizedBox(height: 16),

              // Iftar Step 2
              _MealSection(
                title: '🥗 Iftar - Step 2',
                subtitle: 'After 10 minutes',
                color: AppColors.primary,
                items: MealData.iftarStep2,
                note: '🚫 No fried snacks daily',
              ),
              const SizedBox(height: 16),

              // Dinner
              _MealSection(
                title: '🍽 Dinner',
                subtitle: 'Most important meal',
                color: AppColors.accent,
                items: MealData.dinnerMeals,
                note: '🚫 No rice at night for faster fat loss\n'
                    '💡 If very hungry → 2 chapati max (workout days only)',
              ),
              const SizedBox(height: 16),

              // Face Fat Tips
              GlassCard(
                gradient: LinearGradient(
                  colors: [
                    AppColors.water.withValues(alpha: 0.15),
                    AppColors.primary.withValues(alpha: 0.1),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💧 Face Fat Reduction',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _tipRow('Drink 2.5-3L water daily'),
                    _tipRow('Reduce salt intake'),
                    _tipRow('No sugary juice'),
                    _tipRow('Sleep 6-7 hours'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tipRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.water,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MealSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final List<Map<String, dynamic>> items;
  final String? note;

  const _MealSection({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.items,
    this.note,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map((item) => _MealItemTile(item: item, color: color)),
          if (note != null) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                note!,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MealItemTile extends StatefulWidget {
  final Map<String, dynamic> item;
  final Color color;

  const _MealItemTile({required this.item, required this.color});

  @override
  State<_MealItemTile> createState() => _MealItemTileState();
}

class _MealItemTileState extends State<_MealItemTile> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () => setState(() => _checked = !_checked),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _checked
                ? widget.color.withValues(alpha: 0.1)
                : AppColors.surfaceLight.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: _checked
                ? Border.all(color: widget.color.withValues(alpha: 0.3))
                : null,
          ),
          child: Row(
            children: [
              Text(
                widget.item['icon'] as String,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item['name'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _checked
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                        decoration:
                            _checked ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    Text(
                      '${widget.item['calories']} cal • ${widget.item['protein']} protein',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _checked ? widget.color : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _checked ? widget.color : AppColors.textSecondary,
                    width: 2,
                  ),
                ),
                child: _checked
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
