import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_dimensions.dart';
import '../../data/models/meal_model.dart';
import '../../data/models/menu_item_model.dart';

class MealDetailSheet extends StatelessWidget {
  final Meal meal;

  const MealDetailSheet({
    super.key,
    required this.meal,
  });

  Color _getMealColor() {
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

  IconData _getMealIcon() {
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
    final mealColor = _getMealColor();

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(AppDimensions.lg),
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: mealColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getMealIcon(),
                            color: mealColor,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                meal.name,
                                style: AppTextStyles.headlineLarge.copyWith(
                                  color: mealColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${meal.startTime.format(context)} - ${meal.endTime.format(context)}',
                                style: AppTextStyles.body.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),

                    if (meal.specialNote != null &&
                        meal.specialNote!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: AppColors.warning),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                meal.specialNote!,
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.warning,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Menu Items
                    Text(
                      'Menu Items',
                      style: AppTextStyles.headline.copyWith(
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 16),

                    ...meal.items.map((item) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        child: Row(
                          children: [
                            _buildDietaryBadge(item.type),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (item.allergens.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      'Contains: ${item.allergens.join(', ')}',
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.warning,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 24),

                    // Actions
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _shareMeal(context),
                            icon: const Icon(Icons.share),
                            label: const Text('Share'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // TODO: Implement favorites
                            },
                            icon: const Icon(Icons.favorite_border),
                            label: const Text('Favorite'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: mealColor,
                            ),
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
      },
    );
  }

  Widget _buildDietaryBadge(DietaryType type) {
    Color color;
    String label;

    switch (type) {
      case DietaryType.veg:
        color = AppColors.veg;
        label = 'VEG';
        break;
      case DietaryType.nonVeg:
        color = AppColors.nonVeg;
        label = 'NON-VEG';
        break;
      case DietaryType.vegan:
        color = AppColors.vegan;
        label = 'VEGAN';
        break;
      case DietaryType.eggetarian:
        color = AppColors.eggetarian;
        label = 'EGG';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _shareMeal(BuildContext context) {
    final text = '''
🍽️ ${meal.name} Menu
⏰ ${meal.startTime.format(context)} - ${meal.endTime.format(context)}

${meal.items.map((item) => '• ${item.name}').join('\n')}

Made with ❤️ by IITJ Menu App
    ''';

    Share.share(text);
  }
}
