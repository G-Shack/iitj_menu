import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../data/models/meal_model.dart';

class MealCard extends StatefulWidget {
  final Meal meal;
  final MealState state;
  final bool isVeg;

  const MealCard({
    super.key,
    required this.meal,
    required this.state,
    required this.isVeg,
  });

  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.state == MealState.active) {
      _setupPulseAnimation();
    }
  }

  void _setupPulseAnimation() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    if (widget.state == MealState.active) {
      _pulseController.dispose();
    }
    super.dispose();
  }

  Color _getMealColor() {
    switch (widget.meal.name.toLowerCase()) {
      case 'breakfast':
        return AppColors.breakfast;
      case 'lunch':
        return AppColors.lunch;
      case 'snacks':
        return AppColors.snacks;
      case 'dinner':
        return AppColors.dinner;
      default:
        return AppColors.primary;
    }
  }

  IconData _getMealIcon() {
    switch (widget.meal.name.toLowerCase()) {
      case 'breakfast':
        return Icons.wb_sunny;
      case 'lunch':
        return Icons.restaurant;
      case 'snacks':
        return Icons.local_cafe;
      case 'dinner':
        return Icons.dinner_dining;
      default:
        return Icons.restaurant_menu;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mealColor = _getMealColor();
    final isPast = widget.state == MealState.past;
    final isActive = widget.state == MealState.active;
    final items = widget.meal.getItems(widget.isVeg);
    final specialNote = widget.meal.getSpecialNote(widget.isVeg);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget card = Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: isActive
            ? Border.all(color: mealColor, width: 2)
            : Border.all(
                color: Theme.of(context).dividerColor.withOpacity(0.5),
                width: 1,
              ),
        boxShadow: [
          BoxShadow(
            color: isActive
                ? mealColor.withOpacity(isDark ? 0.15 : 0.25)
                : (isDark
                    ? Colors.black.withOpacity(0.2)
                    : AppColors.primary.withOpacity(0.05)),
            blurRadius: isActive ? 16 : 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  _getMealIcon(),
                  color: mealColor,
                  size: AppDimensions.iconLarge,
                ),
                const SizedBox(width: 12),
                Text(
                  widget.meal.name.toUpperCase(),
                  style: AppTextStyles.title.copyWith(
                    color: Theme.of(context).textTheme.titleLarge?.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: mealColor.withOpacity(0.2),
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusRound),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: mealColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.meal.startTime.format(context)} - ${widget.meal.endTime.format(context)}',
                        style: AppTextStyles.caption.copyWith(
                          color: mealColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (items.isNotEmpty ||
                widget.meal.vegItems.isNotEmpty ||
                widget.meal.jainItems.isNotEmpty ||
                widget.meal.nonVegItems.isNotEmpty) ...[
              const SizedBox(height: 16),

              // Menu Items
              // Text(
              //   'Menu Items:',
              //   style: AppTextStyles.label.copyWith(
              //     color: Theme.of(context).textTheme.bodyMedium?.color,
              //   ),
              // ),

              // const SizedBox(height: 8),

              // For veg mode: show veg items (green) and jain items (black/white)
              if (widget.isVeg) ...[
                if (widget.meal.vegItems.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• Veg: ',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.veg,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            widget.meal.vegItems
                                .map((item) => item.name)
                                .join(', '),
                            style: AppTextStyles.body.copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (widget.meal.jainItems.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• Jain: ',
                          style: AppTextStyles.body.copyWith(
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            widget.meal.jainItems
                                .map((item) => item.name)
                                .join(', '),
                            style: AppTextStyles.body.copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ] else ...[
                // For non-veg mode: show only non-veg items (red)
                if (widget.meal.nonVegItems.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.nonVeg,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            widget.meal.nonVegItems
                                .map((item) => item.name)
                                .join(', '),
                            style: AppTextStyles.body.copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ],

            if (specialNote != null && specialNote.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.2),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusSmall),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 16,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        specialNote,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.warning,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );

    // Apply opacity for past meals
    if (isPast) {
      card = Opacity(
        opacity: 0.7,
        child: card,
      );
    }

    // Apply pulse animation for active meal
    if (isActive) {
      card = AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: child,
          );
        },
        child: card,
      );
    }

    return card;
  }
}
