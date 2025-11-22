import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../data/models/meal_model.dart';
import '../../../../data/models/menu_item_model.dart';

class MealCard extends StatefulWidget {
  final Meal meal;
  final MealState state;
  final VoidCallback? onTap;

  const MealCard({
    Key? key,
    required this.meal,
    required this.state,
    this.onTap,
  }) : super(key: key);

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

    Widget card = Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: isActive ? Border.all(color: mealColor, width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: isActive
                ? mealColor.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
            blurRadius: isActive ? 16 : 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
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
                        color: mealColor.withOpacity(0.15),
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

                const SizedBox(height: 16),

                // Menu Items
                Text(
                  'Menu Items:',
                  style: AppTextStyles.label.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),

                const SizedBox(height: 8),

                ...widget.meal.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• ',
                            style: AppTextStyles.body.copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              item.name,
                              style: AppTextStyles.body.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildDietaryIndicator(item.type),
                        ],
                      ),
                    )),

                if (widget.meal.specialNote != null &&
                    widget.meal.specialNote!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
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
                            widget.meal.specialNote!,
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
        ),
      ),
    );

    // Apply opacity for past meals
    if (isPast) {
      card = Opacity(
        opacity: 0.6,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.grey.withOpacity(0.2),
            BlendMode.saturation,
          ),
          child: card,
        ),
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

  Widget _buildDietaryIndicator(DietaryType type) {
    Color color;
    switch (type) {
      case DietaryType.veg:
        color = AppColors.veg;
        break;
      case DietaryType.nonVeg:
        color = AppColors.nonVeg;
        break;
      case DietaryType.vegan:
        color = AppColors.vegan;
        break;
      case DietaryType.eggetarian:
        color = AppColors.eggetarian;
        break;
    }

    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
