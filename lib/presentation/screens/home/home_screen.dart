import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/menu_provider.dart';
import '../../../providers/dietary_preference_provider.dart';
import '../../../data/models/meal_model.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../widgets/banner_ad_widget.dart';
import 'widgets/header_section.dart';
import 'widgets/meal_card.dart';
import 'widgets/contact_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedDay = DateTime.now().weekday - 1;
  late AnimationController _animationController;
  final ScrollController _scrollController = ScrollController();
  bool _hasScrolledToMeal = false;

  // Approximate height per meal card for scroll calculation
  static const double _mealCardHeight = 180.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animationController.forward();

    // Schedule scroll after first frame renders completely
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduleScrollToCurrentMeal();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scheduleScrollToCurrentMeal() {
    if (_hasScrolledToMeal) return;
    _hasScrolledToMeal = true;

    // Wait for animations to settle before scrolling
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      _scrollToCurrentMeal();
    });
  }

  void _scrollToCurrentMeal() {
    // Only auto-scroll on today's view
    if (_selectedDay != DateTime.now().weekday - 1) return;

    final menuProvider = context.read<MenuProvider>();
    final dayMenu = menuProvider.getDayMenu(_selectedDay);
    if (dayMenu == null) return;

    final meals = dayMenu.allMeals;
    int targetIndex = -1;

    // Find active meal first
    for (int i = 0; i < meals.length; i++) {
      if (meals[i].state == MealState.active) {
        targetIndex = i;
        break;
      }
    }

    // If no active meal, find next upcoming
    if (targetIndex == -1) {
      for (int i = 0; i < meals.length; i++) {
        if (meals[i].state == MealState.upcoming) {
          targetIndex = i;
          break;
        }
      }
    }

    // If all meals are past (late night), don't scroll - show from top
    // User can see the full day's menu
    if (targetIndex <= 0) return;

    // Calculate scroll offset
    final scrollOffset =
        (targetIndex * _mealCardHeight).clamp(0.0, double.infinity);

    // Smooth scroll with elegant curve
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        scrollOffset,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutQuart,
      );
    }
  }

  void _onDaySelected(int day) {
    setState(() {
      _selectedDay = day;
      _animationController.reset();
      _animationController.forward();
    });
  }

  MealState _getMealState(Meal meal) {
    final currentDay = DateTime.now().weekday - 1;

    if (_selectedDay < currentDay) {
      return MealState.past;
    } else if (_selectedDay > currentDay) {
      return MealState.upcoming;
    } else {
      return meal.state;
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Column(
        children: [
          // Main scrollable content
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await context.read<MenuProvider>().refresh();
              },
              edgeOffset: 160 + topPadding, // Offset for the header height
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // Sticky Header & Indicator
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: HomeStickyHeaderDelegate(
                      onDaySelected: _onDaySelected,
                      selectedDay: _selectedDay,
                      onDietaryToggle: () {
                        context
                            .read<DietaryPreferenceProvider>()
                            .togglePreference();
                      },
                      isVeg: context.watch<DietaryPreferenceProvider>().isVeg,
                      topPadding: topPadding,
                      currentMeal: context.watch<MenuProvider>().currentMeal,
                      nextMeal: context.watch<MenuProvider>().nextMeal,
                      showIndicator: (_selectedDay ==
                              DateTime.now().weekday - 1) &&
                          (context.watch<MenuProvider>().currentMeal != null ||
                              context.watch<MenuProvider>().nextMeal != null),
                    ),
                  ),

                  // Meal Cards
                  Consumer<MenuProvider>(
                    builder: (context, menuProvider, _) {
                      if (menuProvider.isLoading &&
                          menuProvider.weeklyMenu.isEmpty) {
                        return const SliverFillRemaining(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (menuProvider.error != null &&
                          menuProvider.weeklyMenu.isEmpty) {
                        return SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error_outline,
                                    size: 64, color: Colors.grey),
                                const SizedBox(height: 16),
                                Text(
                                  menuProvider.error!,
                                  style: AppTextStyles.body,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () => menuProvider.refresh(),
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final dayMenu = menuProvider.getDayMenu(_selectedDay);
                      if (dayMenu == null) {
                        return const SliverFillRemaining(
                          child: Center(
                            child: Text('No menu available'),
                          ),
                        );
                      }

                      return SliverPadding(
                        padding: const EdgeInsets.all(AppDimensions.md),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final meal = dayMenu.allMeals[index];

                              return AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) {
                                  final double start =
                                      (index * 0.1).clamp(0.0, 1.0);
                                  final double end =
                                      (start + 0.4).clamp(0.0, 1.0);

                                  final animationProgress = Interval(
                                    start,
                                    end,
                                    curve: Curves.easeOut,
                                  ).transform(_animationController.value);

                                  return Opacity(
                                    opacity: animationProgress,
                                    child: Transform.translate(
                                      offset: Offset(
                                          0, 20 * (1 - animationProgress)),
                                      child: child,
                                    ),
                                  );
                                },
                                child: Consumer<DietaryPreferenceProvider>(
                                  builder: (context, dietaryProvider, _) {
                                    return MealCard(
                                      meal: meal,
                                      state: _getMealState(meal),
                                      isVeg: dietaryProvider.isVeg,
                                    );
                                  },
                                ),
                              );
                            },
                            childCount: dayMenu.allMeals.length,
                          ),
                        ),
                      );
                    },
                  ),

                  // Contact Section
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: AppDimensions.lg),
                      child: ContactSection(),
                    ),
                  ),

                  // Bottom spacing (account for fixed ad banner)
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 10),
                  ),
                ],
              ),
            ),
          ),

          // Fixed Banner Ad at bottom
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Padding(
                padding: EdgeInsetsGeometry.only(bottom: 12),
                child: const BannerAdWidget()),
          ),
        ],
      ),
    );
  }
}
