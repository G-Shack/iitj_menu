import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../data/models/meal_model.dart';
import 'current_meal_indicator.dart';

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
    return SafeArea(
      bottom: false,
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
                                  color:
                                      isVeg ? AppColors.primary : Colors.white,
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
                                  color:
                                      !isVeg ? AppColors.primary : Colors.white,
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
    );
  }
}

class WeekDaySelector extends StatefulWidget {
  final int selectedDay;
  final Function(int) onDaySelected;

  const WeekDaySelector({
    super.key,
    required this.selectedDay,
    required this.onDaySelected,
  });

  @override
  State<WeekDaySelector> createState() => _WeekDaySelectorState();
}

class _WeekDaySelectorState extends State<WeekDaySelector> {
  final ScrollController _scrollController = ScrollController();
  bool _canScroll = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkScrollability();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _checkScrollability() {
    if (!_scrollController.hasClients) return;
    final canScroll = _scrollController.position.maxScrollExtent > 0;
    if (canScroll != _canScroll) {
      setState(() {
        _canScroll = canScroll;
      });
    }
  }

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return NotificationListener<ScrollMetricsNotification>(
      onNotification: (notification) {
        _checkScrollability();
        return false;
      },
      child: Stack(
        children: [
          // Scrollable day selector
          SizedBox(
            height: 50,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              itemCount: days.length,
              itemBuilder: (context, index) {
                final isSelected = index == widget.selectedDay;
                final isToday = index == currentDay;

                return GestureDetector(
                  onTap: () => widget.onDaySelected(index),
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          days[index]['short']!,
                          style: AppTextStyles.label.copyWith(
                            color:
                                isSelected ? AppColors.primary : Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Fade gradient on right to indicate more content
          if (_canScroll)
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
                        (isDark
                            ? AppColors.primary.withOpacity(0)
                            : AppColors.primaryLight.withOpacity(0)),
                        (isDark
                            ? AppColors.primary.withOpacity(0)
                            : AppColors.primaryLight.withOpacity(0)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          // Scroll indicator icon
          if (_canScroll)
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
      ),
    );
  }
}

class HomeStickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Function(int) onDaySelected;
  final int selectedDay;
  final VoidCallback onDietaryToggle;
  final bool isVeg;
  final double topPadding;
  final Meal? currentMeal;
  final Meal? nextMeal;
  final bool showIndicator;

  HomeStickyHeaderDelegate({
    required this.onDaySelected,
    required this.selectedDay,
    required this.onDietaryToggle,
    required this.isVeg,
    required this.topPadding,
    this.currentMeal,
    this.nextMeal,
    required this.showIndicator,
  });

  // Calculated heights based on content
  static const double _headerContentHeight = 150.0;
  static const double _indicatorHeight = 120.0;

  @override
  double get maxExtent => (topPadding +
          _headerContentHeight +
          (showIndicator ? _indicatorHeight : 0))
      .ceilToDouble();

  @override
  double get minExtent => maxExtent; // No shrinking

  @override
  bool shouldRebuild(covariant HomeStickyHeaderDelegate oldDelegate) {
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
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withOpacity(0.85),
                  AppColors.primaryLight.withOpacity(0.85),
                ],
              ),
            ),
            child: Column(
              children: [
                // Header Section
                SizedBox(
                  height: topPadding + _headerContentHeight - 10,
                  child: HeaderSection(
                    onDaySelected: onDaySelected,
                    selectedDay: selectedDay,
                    onDietaryToggle: onDietaryToggle,
                    isVeg: isVeg,
                  ),
                ),
                // Indicator Section
                if (showIndicator)
                  SizedBox(
                    height: _indicatorHeight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: CurrentMealIndicator(
                        currentMeal: currentMeal,
                        nextMeal: nextMeal,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
