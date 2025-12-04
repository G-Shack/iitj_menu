import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../providers/app_config_provider.dart';
import '../home/home_screen.dart';
import '../events/events_screen.dart';
import '../timetable/timetable_screen.dart';
import '../more/more_screen.dart';

class HubScreen extends StatefulWidget {
  const HubScreen({super.key});

  @override
  State<HubScreen> createState() => _HubScreenState();
}

class _HubScreenState extends State<HubScreen> with TickerProviderStateMixin {
  int _selectedIndex = -1; // -1 means options screen, 0-3 are the tabs
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late List<AnimationController> _cardControllers;
  late List<Animation<double>> _cardAnimations;

  final List<_HubOption> _options = [
    _HubOption(
      title: 'Menu',
      subtitle: 'Today\'s delicious meals',
      icon: Icons.restaurant_menu_rounded,
      gradient: [AppColors.primary, AppColors.primaryDark],
    ),
    _HubOption(
      title: 'Timetable',
      subtitle: 'Your class schedule',
      icon: Icons.calendar_month_rounded,
      gradient: [const Color(0xFF10B981), const Color(0xFF059669)],
    ),
    _HubOption(
      title: 'Events',
      subtitle: 'Campus happenings',
      icon: Icons.celebration_rounded,
      gradient: [const Color(0xFFF59E0B), const Color(0xFFD97706)],
    ),
    _HubOption(
      title: 'More',
      subtitle: 'Additional features',
      icon: Icons.grid_view_rounded,
      gradient: [const Color(0xFFEC4899), const Color(0xFFDB2777)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // Create staggered animations for each card
    _cardControllers = List.generate(
      4,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      ),
    );

    _cardAnimations = _cardControllers.map((controller) {
      return CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
      );
    }).toList();

    _startEntryAnimation();
  }

  void _startEntryAnimation() async {
    _fadeController.forward();
    for (int i = 0; i < _cardControllers.length; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (mounted) {
        _cardControllers[i].forward();
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    for (var controller in _cardControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onOptionTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onBackToHub() {
    // Reset animations for re-entry
    for (var controller in _cardControllers) {
      controller.reset();
    }
    setState(() {
      _selectedIndex = -1;
    });
    _startEntryAnimation();
  }

  Widget _buildCurrentScreen() {
    switch (_selectedIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const TimetableScreen();
      case 2:
        return const EventsScreen();
      case 3:
        return const MoreScreen();
      default:
        return _buildOptionsScreen();
    }
  }

  Widget _buildOptionsScreen() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [AppColors.darkBackground, AppColors.darkBackgroundSecondary]
                : [
                    AppColors.lightBackground,
                    AppColors.lightBackgroundSecondary
                  ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.xl),

                // Header
                FadeTransition(
                  opacity: _fadeController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryLight],
                        ).createShader(bounds),
                        child: Text(
                          'IITJ Hub',
                          style: AppTextStyles.displayLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your campus companion ✨',
                        style: AppTextStyles.body.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppDimensions.xxl),

                // Grid of options
                Expanded(
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: AppDimensions.md,
                      mainAxisSpacing: AppDimensions.md,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: _options.length,
                    itemBuilder: (context, index) {
                      return ScaleTransition(
                        scale: _cardAnimations[index],
                        child: _buildOptionCard(index),
                      );
                    },
                  ),
                ),

                // Footer
                FadeTransition(
                  opacity: _fadeController,
                  child: Center(
                    child: Text(
                      'Made with ❤️ for IITJ',
                      style: AppTextStyles.caption.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary.withOpacity(0.6)
                            : AppColors.lightTextSecondary.withOpacity(0.6),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.md),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(int index) {
    final option = _options[index];

    return GestureDetector(
      onTap: () => _onOptionTap(index),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: option.gradient,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge),
          boxShadow: [
            BoxShadow(
              color: option.gradient[0].withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(
                option.icon,
                size: 120,
                color: Colors.white.withOpacity(0.15),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(AppDimensions.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusMedium),
                    ),
                    child: Icon(
                      option.icon,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    option.title,
                    style: AppTextStyles.headline.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    option.subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),

            // Ripple effect overlay
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _onOptionTap(index),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusXLarge),
                  splashColor: Colors.white.withOpacity(0.2),
                  highlightColor: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final showOptionsScreen =
        context.watch<AppConfigProvider>().showOptionsScreen;

    // If options screen is disabled via remote config, show menu directly
    if (!showOptionsScreen) {
      return const HomeScreen();
    }

    // If we're on the options screen
    if (_selectedIndex == -1) {
      return _buildOptionsScreen();
    }

    // If we've selected an option, show the screen with navbar
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.05),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              )),
              child: child,
            ),
          );
        },
        child: _buildCurrentScreen(),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.md,
            vertical: AppDimensions.sm,
          ),
          child: Row(
            children: [
              // Back to Hub button
              _buildNavItem(
                icon: Icons.apps_rounded,
                label: 'Hub',
                isSelected: false,
                onTap: _onBackToHub,
                isHub: true,
              ),
              const SizedBox(width: AppDimensions.sm),
              // Navigation items
              ...List.generate(4, (index) {
                return Expanded(
                  child: _buildNavItem(
                    icon: _options[index].icon,
                    label: _options[index].title,
                    isSelected: _selectedIndex == index,
                    onTap: () => _onOptionTap(index),
                    color: _options[index].gradient[0],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    bool isHub = false,
    Color? color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = color ?? AppColors.primary;
    final inactiveColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    if (isHub) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.md,
            vertical: AppDimensions.sm,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? activeColor.withOpacity(0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
              child: Icon(
                icon,
                color: isSelected ? activeColor : inactiveColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: isSelected ? activeColor : inactiveColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HubOption {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;

  const _HubOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  });
}
