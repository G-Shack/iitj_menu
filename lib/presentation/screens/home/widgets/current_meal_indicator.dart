import 'package:flutter/material.dart';
import 'dart:async';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../data/models/meal_model.dart';

class CurrentMealIndicator extends StatefulWidget {
  final Meal? currentMeal;
  final Meal? nextMeal;

  const CurrentMealIndicator({
    super.key,
    this.currentMeal,
    this.nextMeal,
  });

  @override
  State<CurrentMealIndicator> createState() => _CurrentMealIndicatorState();
}

class _CurrentMealIndicatorState extends State<CurrentMealIndicator> {
  Timer? _timer;
  String _timeRemaining = '';

  @override
  void initState() {
    super.initState();
    _updateTimeRemaining();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      _updateTimeRemaining();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTimeRemaining() {
    if (!mounted) return;

    final meal = widget.currentMeal ?? widget.nextMeal;
    if (meal == null) {
      setState(() => _timeRemaining = '');
      return;
    }

    final now = DateTime.now();
    final targetTime =
        widget.currentMeal != null ? meal.endTime : meal.startTime;

    // Calculate time difference
    final target = DateTime(
      now.year,
      now.month,
      now.day,
      targetTime.hour,
      targetTime.minute,
    );

    final diff = target.difference(now);

    if (diff.isNegative) {
      setState(() => _timeRemaining = '');
      return;
    }

    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;

    setState(() {
      if (widget.currentMeal != null) {
        if (hours > 0) {
          _timeRemaining =
              'Ends in $hours hour${hours > 1 ? 's' : ''} $minutes min';
        } else {
          _timeRemaining = 'Ends in $minutes minute${minutes != 1 ? 's' : ''}';
        }
      } else {
        if (hours > 0) {
          _timeRemaining =
              'Starts in $hours hour${hours > 1 ? 's' : ''} $minutes min';
        } else {
          _timeRemaining =
              'Starts in $minutes minute${minutes != 1 ? 's' : ''}';
        }
      }
    });
  }

  Color _getMealColor(Meal meal) {
    switch (meal.name.toLowerCase()) {
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

  IconData _getMealIcon(Meal meal) {
    switch (meal.name.toLowerCase()) {
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
    final meal = widget.currentMeal ?? widget.nextMeal;
    if (meal == null) return const SizedBox.shrink();

    final isActive = widget.currentMeal != null;
    final mealColor = _getMealColor(meal);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm,
      ),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : AppColors.primary.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: isDark ? Border.all(color: AppColors.darkBorder) : null,
      ),
      child: Stack(
        children: [
          // Left colored strip
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 4,
            child: Container(color: mealColor),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.md + 4, // Add strip width to padding
              AppDimensions.md,
              AppDimensions.md,
              AppDimensions.md,
            ),
            child: Row(
              children: [
                // Icon with animation for active meal
                if (isActive)
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: 0.8 + (value * 0.2),
                        child: child,
                      );
                    },
                    child: Icon(
                      _getMealIcon(meal),
                      size: AppDimensions.iconLarge,
                      color: mealColor,
                    ),
                  )
                else
                  Icon(
                    _getMealIcon(meal),
                    size: AppDimensions.iconLarge,
                    color: mealColor,
                  ),

                const SizedBox(width: 12),

                // Meal info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            meal.name.toUpperCase(),
                            style: AppTextStyles.label.copyWith(
                              color: mealColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (isActive) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: mealColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusSmall),
                              ),
                              child: Text(
                                'ACTIVE',
                                style: AppTextStyles.caption.copyWith(
                                  color: mealColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${meal.startTime.format(context)} - ${meal.endTime.format(context)}',
                        style: AppTextStyles.body.copyWith(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                ),

                // Time remaining
                if (_timeRemaining.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: AppDimensions.iconSmall,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _timeRemaining,
                        style: AppTextStyles.caption.copyWith(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
