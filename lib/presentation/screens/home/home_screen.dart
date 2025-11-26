import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/menu_provider.dart';
import '../../../providers/dietary_preference_provider.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import 'widgets/header_section.dart';
import 'widgets/meal_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedDay = DateTime.now().weekday - 1;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onDaySelected(int day) {
    setState(() {
      _selectedDay = day;
      _animationController.reset();
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<MenuProvider>().refresh();
        },
        edgeOffset: 160 + topPadding, // Offset for the header height
        child: CustomScrollView(
          slivers: [
            // Sticky Header & Indicator
            SliverPersistentHeader(
              pinned: true,
              delegate: HomeStickyHeaderDelegate(
                onDaySelected: _onDaySelected,
                selectedDay: _selectedDay,
                onDietaryToggle: () {
                  context.read<DietaryPreferenceProvider>().togglePreference();
                },
                isVeg: context.watch<DietaryPreferenceProvider>().isVeg,
                topPadding: topPadding,
                currentMeal: context.watch<MenuProvider>().currentMeal,
                nextMeal: context.watch<MenuProvider>().nextMeal,
                showIndicator: (_selectedDay == DateTime.now().weekday - 1) &&
                    (context.watch<MenuProvider>().currentMeal != null ||
                        context.watch<MenuProvider>().nextMeal != null),
              ),
            ),

            // Meal Cards
            Consumer<MenuProvider>(
              builder: (context, menuProvider, _) {
                if (menuProvider.isLoading && menuProvider.weeklyMenu.isEmpty) {
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
                            final double start = (index * 0.1).clamp(0.0, 1.0);
                            final double end = (start + 0.4).clamp(0.0, 1.0);

                            final animationProgress = Interval(
                              start,
                              end,
                              curve: Curves.easeOut,
                            ).transform(_animationController.value);

                            return Opacity(
                              opacity: animationProgress,
                              child: Transform.translate(
                                offset: Offset(0, 20 * (1 - animationProgress)),
                                child: child,
                              ),
                            );
                          },
                          child: Consumer<DietaryPreferenceProvider>(
                            builder: (context, dietaryProvider, _) {
                              return MealCard(
                                meal: meal,
                                state: meal.state,
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

            // Bottom spacing
            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),
          ],
        ),
      ),
    );
  }
}
