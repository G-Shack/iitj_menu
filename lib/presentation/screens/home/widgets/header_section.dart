import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_dimensions.dart';

class HeaderSection extends StatelessWidget {
  final Function(int) onDaySelected;
  final int selectedDay;
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const HeaderSection({
    Key? key,
    required this.onDaySelected,
    required this.selectedDay,
    required this.onThemeToggle,
    required this.isDarkMode,
  }) : super(key: key);

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
              // Title and Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mess Menu',
                        style: AppTextStyles.display.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('EEEE, d MMMM').format(DateTime.now()),
                        style: AppTextStyles.body.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          isDarkMode ? Icons.light_mode : Icons.dark_mode,
                          color: Colors.white,
                        ),
                        onPressed: onThemeToggle,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // Settings navigation can be added later
                        },
                      ),
                    ],
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
    Key? key,
    required this.selectedDay,
    required this.onDaySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final currentDay = DateTime.now().weekday - 1;

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
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
                color:
                    isSelected ? Colors.white : Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
                border: Border.all(
                  color: isToday && !isSelected
                      ? Colors.white
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  days[index],
                  style: AppTextStyles.label.copyWith(
                    color: isSelected ? AppColors.primary : Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
