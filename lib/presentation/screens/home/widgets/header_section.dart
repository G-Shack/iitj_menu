import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_dimensions.dart';

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
                                  decoration: BoxDecoration(
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
                                  decoration: BoxDecoration(
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

class WeekDaySelector extends StatelessWidget {
  final int selectedDay;
  final Function(int) onDaySelected;

  const WeekDaySelector({
    super.key,
    required this.selectedDay,
    required this.onDaySelected,
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

    return Stack(
      children: [
        // Scrollable day selector
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
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
                    children: [
                      Text(
                        days[index]['short']!,
                        style: AppTextStyles.label.copyWith(
                          color: isSelected ? AppColors.primary : Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isToday && !isSelected) ...[
                        const SizedBox(height: 2),
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
