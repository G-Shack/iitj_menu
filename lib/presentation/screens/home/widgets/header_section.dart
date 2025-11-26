import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../data/models/meal_model.dart';
import 'current_meal_indicator.dart';

class HomeHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Function(int) onDaySelected;
  final int selectedDay;
  final VoidCallback onDietaryToggle;
  final bool isVeg;
  final double topPadding;
  final Meal? currentMeal;
  final Meal? nextMeal;
  final bool showIndicator;

  HomeHeaderDelegate({
    required this.onDaySelected,
    required this.selectedDay,
    required this.onDietaryToggle,
    required this.isVeg,
    required this.topPadding,
    this.currentMeal,
    this.nextMeal,
    required this.showIndicator,
  });

  static const double _expandedHeaderHeight = 160.0;
  static const double _collapsedHeaderHeight = 100.0;
  static const double _indicatorHeight = 100.0;

  @override
  double get maxExtent => (_expandedHeaderHeight +
          topPadding +
          (showIndicator ? _indicatorHeight : 0))
      .ceilToDouble();

  @override
  double get minExtent => (_collapsedHeaderHeight +
          topPadding +
          (showIndicator ? _indicatorHeight : 0))
      .ceilToDouble();

  @override
  bool shouldRebuild(covariant HomeHeaderDelegate oldDelegate) {
    return oldDelegate.selectedDay != selectedDay ||
        oldDelegate.isVeg != isVeg ||
        oldDelegate.topPadding != topPadding ||
        oldDelegate.currentMeal != currentMeal ||
        oldDelegate.nextMeal != nextMeal ||
        oldDelegate.showIndicator != showIndicator;
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double headerRange = _expandedHeaderHeight - _collapsedHeaderHeight;
    // shrinkOffset goes from 0 to headerRange (60.0)
    final double expandRatio =
        (1.0 - (shrinkOffset / headerRange)).clamp(0.0, 1.0);

    return Column(
      children: [
        // Header Part
        SizedBox(
          height: (_collapsedHeaderHeight + topPadding) +
              (headerRange * expandRatio),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primaryLight],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.only(
                  left: AppDimensions.md,
                  right: AppDimensions.md,
                  top: 8.0 + 8.0 * expandRatio,
                  bottom: 8.0 + 8.0 * expandRatio,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Dietary Toggle Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Title - shrinks but stays visible
                        Opacity(
                          opacity: 0.6 + 0.4 * expandRatio,
                          child: Text(
                            'Mess Menu',
                            style: AppTextStyles.display.copyWith(
                              color: Colors.white,
                              fontSize: 20 + 8 * expandRatio,
                            ),
                          ),
                        ),
                        // Veg/Non-Veg Toggle
                        _buildDietaryToggle(expandRatio),
                      ],
                    ),

                    SizedBox(height: 8.0 + 8.0 * expandRatio),

                    // Week Day Selector - reduces height when collapsed
                    Expanded(
                      child: WeekDaySelector(
                        selectedDay: selectedDay,
                        onDaySelected: onDaySelected,
                        expandRatio: expandRatio,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Indicator Part
        if (showIndicator)
          SizedBox(
            height: _indicatorHeight,
            child: CurrentMealIndicator(
              currentMeal: currentMeal,
              nextMeal: nextMeal,
            ),
          ),
      ],
    );
  }

  Widget _buildDietaryToggle(double expandRatio) {
    return GestureDetector(
      onTap: onDietaryToggle,
      child: Container(
        padding: EdgeInsets.all(3 + 1 * expandRatio),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Veg Option
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(
                horizontal: 8 + 8 * expandRatio,
                vertical: 4 + 4 * expandRatio,
              ),
              decoration: BoxDecoration(
                color: isVeg ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.veg,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (expandRatio > 0.3) ...[
                    SizedBox(width: 4 * expandRatio),
                    Opacity(
                      opacity: ((expandRatio - 0.3) / 0.7).clamp(0.0, 1.0),
                      child: Text(
                        'VEG',
                        style: AppTextStyles.label.copyWith(
                          color: isVeg ? AppColors.primary : Colors.white,
                          fontSize: 11 + expandRatio,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Non-Veg Option
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(
                horizontal: 8 + 8 * expandRatio,
                vertical: 4 + 4 * expandRatio,
              ),
              decoration: BoxDecoration(
                color: !isVeg ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.nonVeg,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (expandRatio > 0.3) ...[
                    SizedBox(width: 4 * expandRatio),
                    Opacity(
                      opacity: ((expandRatio - 0.3) / 0.7).clamp(0.0, 1.0),
                      child: Text(
                        'NON-VEG',
                        style: AppTextStyles.label.copyWith(
                          color: !isVeg ? AppColors.primary : Colors.white,
                          fontSize: 11 + expandRatio,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeekDaySelector extends StatelessWidget {
  final int selectedDay;
  final Function(int) onDaySelected;
  final double expandRatio;

  const WeekDaySelector({
    super.key,
    required this.selectedDay,
    required this.onDaySelected,
    this.expandRatio = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final days = [
      {'short': 'Mon', 'full': 'Monday'},
      {'short': 'Tue', 'full': 'Tuesday'},
      {'short': 'Wed', 'full': 'Wednesday'},
      {'short': 'Thu', 'full': 'Thursday'},
      {'short': 'Fri', 'full': 'Friday'},
      {'short': 'Sat', 'full': 'Saturday'},
      {'short': 'Sun', 'full': 'Sunday'},
    ];
    final currentDay = DateTime.now().weekday - 1;

    final double itemHeight = 36 + 14 * expandRatio;
    final double verticalPadding = 4 + 4 * expandRatio;

    return Stack(
      children: [
        // Scrollable day selector
        SizedBox(
          height: itemHeight + verticalPadding * 2,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding:
                EdgeInsets.symmetric(horizontal: 4, vertical: verticalPadding),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final isSelected = index == selectedDay;
              final isToday = index == currentDay;

              return GestureDetector(
                onTap: () => onDaySelected(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.only(right: 8),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12 + 4 * expandRatio,
                    vertical: 4 + 4 * expandRatio,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.2),
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusRound),
                    border: isToday && !isSelected
                        ? Border.all(color: Colors.white, width: 2)
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        days[index]['short']!,
                        style: AppTextStyles.label.copyWith(
                          color: isSelected ? AppColors.primary : Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12 + 2 * expandRatio,
                        ),
                      ),
                      if (isToday && !isSelected && expandRatio > 0.5) ...[
                        SizedBox(height: 2 * expandRatio),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // Fade gradient on right to indicate more content
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: IgnorePointer(
            child: Container(
              width: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.primaryLight.withOpacity(0),
                    AppColors.primaryLight.withOpacity(0.6),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Scroll indicator icon
        Positioned(
          right: 8,
          top: 0,
          bottom: 0,
          child: Center(
            child: Icon(
              Icons.chevron_right,
              color: Colors.white.withOpacity(0.7),
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}

// Keep original HeaderSection for backward compatibility if needed
class HeaderSection extends StatelessWidget {
  final Function(int) onDaySelected;
  final int selectedDay;
  final VoidCallback onDietaryToggle;
  final bool isVeg;

  const HeaderSection({
    super.key,
    required this.onDaySelected,
    required this.selectedDay,
    required this.onDietaryToggle,
    required this.isVeg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryLight],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Dietary Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mess Menu',
                    style: AppTextStyles.display.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  // Veg/Non-Veg Toggle
                  GestureDetector(
                    onTap: onDietaryToggle,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusRound),
                      ),
                      child: Row(
                        children: [
                          // Veg Option
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isVeg ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusRound),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColors.veg,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'VEG',
                                  style: AppTextStyles.label.copyWith(
                                    color: isVeg
                                        ? AppColors.primary
                                        : Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Non-Veg Option
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: !isVeg ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusRound),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColors.nonVeg,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'NON-VEG',
                                  style: AppTextStyles.label.copyWith(
                                    color: !isVeg
                                        ? AppColors.primary
                                        : Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Week Day Selector
              WeekDaySelector(
                selectedDay: selectedDay,
                onDaySelected: onDaySelected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
