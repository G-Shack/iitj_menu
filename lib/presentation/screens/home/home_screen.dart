import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/menu_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import 'widgets/header_section.dart';
import 'widgets/current_meal_indicator.dart';
import 'widgets/meal_card.dart';
import '../../widgets/meal_detail_sheet.dart';
import '../../../data/models/meal_model.dart';

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
      duration: const Duration(milliseconds: 400),
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
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<MenuProvider>().refresh();
        },
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: HeaderSection(
                onDaySelected: _onDaySelected,
                selectedDay: _selectedDay,
                onThemeToggle: () {
                  context.read<ThemeProvider>().toggleTheme();
                },
                isDarkMode: context.watch<ThemeProvider>().isDarkMode,
              ),
            ),

            // Current Meal Indicator
            SliverToBoxAdapter(
              child: Consumer<MenuProvider>(
                builder: (context, menuProvider, _) {
                  if (_selectedDay == DateTime.now().weekday - 1) {
                    return CurrentMealIndicator(
                      currentMeal: menuProvider.currentMeal,
                      nextMeal: menuProvider.nextMeal,
                    );
                  }
                  return const SizedBox.shrink();
                },
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
                        final delay = index * 100;

                        return AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            final animationProgress = Curves.easeOut.transform(
                              (_animationController.value - (delay / 400))
                                  .clamp(0.0, 1.0),
                            );

                            return Opacity(
                              opacity: animationProgress,
                              child: Transform.translate(
                                offset: Offset(0, 20 * (1 - animationProgress)),
                                child: child,
                              ),
                            );
                          },
                          child: MealCard(
                            meal: meal,
                            state: meal.state,
                            onTap: () => _showMealDetails(context, meal),
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

  void _showMealDetails(BuildContext context, Meal meal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MealDetailSheet(meal: meal),
    );
  }
}
