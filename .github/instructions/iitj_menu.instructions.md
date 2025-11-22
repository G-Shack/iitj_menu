---
applyTo: '**'
---
# AI INSTRUCTION PROMPT: IITJ Menu App Development

## 🎯 ROLE & CONTEXT

You are an expert Flutter developer with specialization in:
- Modern UI/UX design implementation
- State management (Provider/Riverpod)
- Firebase integration (Remote Config, Analytics, Crashlytics)
- Complex animations and micro-interactions
- Performance optimization
- Cross-platform mobile development (Android/iOS)

## 📋 PROJECT BRIEF

**Project Name:** IITJ Menu  
**Objective:** Develop a production-ready Flutter mobile application for IIT Jodhpur's mess menu display  
**Target Users:** IIT Jodhpur students, faculty, and staff  
**Developer Credit:** Om Tathed  
**Platform:** iOS & Android  
**Timeline:** Systematic implementation across 7 development phases

## 🎨 DESIGN PHILOSOPHY

Create an app that is:
- **Delightful:** Every interaction should feel smooth and satisfying
- **Informative:** Information should be instantly accessible and clear
- **Modern:** Following latest Material Design 3 principles
- **Performant:** Fast load times, smooth animations, minimal battery drain
- **Intuitive:** Zero learning curve, natural user flows

## 📐 DESIGN SYSTEM SPECIFICATIONS

### Color Palette Implementation

```dart
// Create: lib/core/constants/app_colors.dart

class AppColors {
  // Primary Colors
  static const primary = Color(0xFF6366F1);        // Indigo-500
  static const primaryDark = Color(0xFF4F46E5);    // Indigo-600
  static const primaryLight = Color(0xFF818CF8);   // Indigo-400
  static const primarySubtle = Color(0xFFE0E7FF);  // Indigo-100
  
  // Secondary Colors
  static const secondary = Color(0xFFF59E0B);      // Amber-500
  static const secondaryDark = Color(0xFFD97706);  // Amber-600
  static const secondaryLight = Color(0xFFFCD34D); // Amber-300
  
  // Meal Type Colors
  static const breakfast = Color(0xFFFCD34D);      // Warm Yellow
  static const lunch = Color(0xFF10B981);          // Emerald Green
  static const snacks = Color(0xFFF59E0B);         // Amber
  static const dinner = Color(0xFF6366F1);         // Indigo
  
  // Light Theme
  static const lightBackground = Color(0xFFFFFFFF);
  static const lightBackgroundSecondary = Color(0xFFF9FAFB);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightTextPrimary = Color(0xFF111827);
  static const lightTextSecondary = Color(0xFF6B7280);
  static const lightBorder = Color(0xFFE5E7EB);
  
  // Dark Theme
  static const darkBackground = Color(0xFF0F172A);
  static const darkBackgroundSecondary = Color(0xFF1E293B);
  static const darkSurface = Color(0xFF1E293B);
  static const darkTextPrimary = Color(0xFFF1F5F9);
  static const darkTextSecondary = Color(0xFF94A3B8);
  static const darkBorder = Color(0xFF334155);
  
  // Status Colors
  static const success = Color(0xFF10B981);
  static const error = Color(0xFFEF4444);
  static const warning = Color(0xFFF59E0B);
  static const info = Color(0xFF3B82F6);
  
  // Dietary Type Colors
  static const veg = Color(0xFF10B981);        // Green
  static const nonVeg = Color(0xFFEF4444);     // Red
  static const vegan = Color(0xFFFCD34D);      // Yellow
  static const eggetarian = Color(0xFF92400E); // Brown
}
```

### Typography System

```dart
// Create: lib/core/constants/app_text_styles.dart

import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static final displayLarge = GoogleFonts.inter(
    fontSize: 32,
    height: 38 / 32,
    fontWeight: FontWeight.w800,
  );
  
  static final display = GoogleFonts.inter(
    fontSize: 28,
    height: 34 / 28,
    fontWeight: FontWeight.w700,
  );
  
  static final headlineLarge = GoogleFonts.inter(
    fontSize: 24,
    height: 30 / 24,
    fontWeight: FontWeight.w600,
  );
  
  static final headline = GoogleFonts.inter(
    fontSize: 20,
    height: 26 / 20,
    fontWeight: FontWeight.w600,
  );
  
  static final title = GoogleFonts.inter(
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w600,
  );
  
  static final bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
  );
  
  static final body = GoogleFonts.inter(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
  );
  
  static final bodySmall = GoogleFonts.inter(
    fontSize: 12,
    height: 18 / 12,
    fontWeight: FontWeight.w400,
  );
  
  static final label = GoogleFonts.inter(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w500,
  );
  
  static final caption = GoogleFonts.inter(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
  );
}
```

### Spacing & Dimensions

```dart
// Create: lib/core/constants/app_dimensions.dart

class AppDimensions {
  // Spacing
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
  
  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  static const double radiusRound = 999.0;
  
  // Card Heights
  static const double mealCardMinHeight = 120.0;
  static const double headerHeight = 180.0;
  static const double currentMealIndicatorHeight = 80.0;
  
  // Icon Sizes
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconXLarge = 48.0;
}
```

## 🏗️ PROJECT STRUCTURE

**INSTRUCTION:** Create the following folder structure exactly as specified:

```
lib/
├── main.dart
├── app/
│   ├── app.dart
│   └── routes.dart
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   ├── app_dimensions.dart
│   │   └── app_strings.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── light_theme.dart
│   │   └── dark_theme.dart
│   └── utils/
│       ├── date_utils.dart
│       ├── time_utils.dart
│       └── storage_utils.dart
├── data/
│   ├── models/
│   │   ├── meal_model.dart
│   │   ├── menu_item_model.dart
│   │   └── day_menu_model.dart
│   ├── repositories/
│   │   └── menu_repository.dart
│   └── services/
│       ├── remote_config_service.dart
│       ├── cache_service.dart
│       └── notification_service.dart
├── presentation/
│   ├── screens/
│   │   ├── splash/
│   │   │   ├── splash_screen.dart
│   │   │   └── splash_controller.dart
│   │   ├── home/
│   │   │   ├── home_screen.dart
│   │   │   ├── home_controller.dart
│   │   │   └── widgets/
│   │   │       ├── meal_card.dart
│   │   │       ├── current_meal_indicator.dart
│   │   │       ├── header_section.dart
│   │   │       └── week_day_selector.dart
│   │   ├── weekly/
│   │   │   ├── weekly_screen.dart
│   │   │   └── weekly_controller.dart
│   │   └── settings/
│   │       ├── settings_screen.dart
│   │       └── settings_controller.dart
│   └── widgets/
│       ├── custom_button.dart
│       ├── loading_indicator.dart
│       ├── empty_state.dart
│       └── meal_detail_sheet.dart
└── providers/
    ├── theme_provider.dart
    └── menu_provider.dart
```

## 📦 DEPENDENCIES

**INSTRUCTION:** Add these exact dependencies to pubspec.yaml:

```yaml
name: iitj_menu
description: Mess Menu App for IIT Jodhpur Community
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.1.1
  
  # Firebase
  firebase_core: ^2.24.2
  firebase_remote_config: ^4.3.8
  firebase_analytics: ^10.8.0
  firebase_crashlytics: ^3.4.8
  
  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  shared_preferences: ^2.2.2
  
  # Networking
  connectivity_plus: ^5.0.2
  
  # Notifications
  flutter_local_notifications: ^16.3.0
  
  # UI
  animations: ^2.0.11
  shimmer: ^3.0.0
  lottie: ^3.0.0
  flutter_slidable: ^3.0.1
  
  # Utilities
  intl: ^0.19.0
  google_fonts: ^6.1.0
  url_launcher: ^6.2.2
  share_plus: ^7.2.1
  equatable: ^2.0.5
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  hive_generator: ^2.0.1
  build_runner: ^2.4.7

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
    - assets/icons/
    - assets/animations/
```

## 🎬 SCREEN 1: SPLASH SCREEN

### Requirements

**Visual Design:**
- Full-screen gradient background: Primary (#6366F1) to Primary Dark (#4F46E5)
- Diagonal gradient direction: top-left to bottom-right
- Center logo/icon: 120×120px
- Tagline below logo: "Made with love for IITJ Community"
- Developer credit: "- Om Tathed"
- Display duration: 2-3 seconds

**Animation Sequence:**
1. Logo: Fade in (300ms) + Scale from 0.95 to 1.0 (400ms, ease-out curve)
2. Tagline: Fade in after 500ms delay (400ms duration)
3. Credit: Fade in after 700ms delay (400ms duration)

### Implementation Code

```dart
// Create: lib/presentation/screens/splash/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _taglineFadeAnimation;
  late Animation<double> _creditFadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _navigateToHome();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Logo animations
    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.2, curve: Curves.easeIn),
      ),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.27, curve: Curves.easeOut),
      ),
    );

    // Tagline animation
    _taglineFadeAnimation = Tween<double>(begin: 0.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.33, 0.6, curve: Curves.easeIn),
      ),
    );

    // Credit animation
    _creditFadeAnimation = Tween<double>(begin: 0.0, end: 0.8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.47, 0.73, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _logoFadeAnimation.value,
                    child: Transform.scale(
                      scale: _logoScaleAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.restaurant_menu,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Tagline
              AnimatedBuilder(
                animation: _taglineFadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _taglineFadeAnimation.value,
                    child: child,
                  );
                },
                child: Text(
                  'Made with love for IITJ Community',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Developer Credit
              AnimatedBuilder(
                animation: _creditFadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _creditFadeAnimation.value,
                    child: child,
                  );
                },
                child: Text(
                  '- Om Tathed',
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## 🏠 SCREEN 2: HOME SCREEN

### Layout Structure

```
┌─────────────────────────────────────┐
│ HEADER (Gradient, 180px)            │
│  - App Title                         │
│  - Current Date                      │
│  - Week Day Selector (horizontal)    │
│  - Theme Toggle (top-right)          │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│ CURRENT MEAL INDICATOR (overlapping) │
│  - Shows active/next meal            │
│  - Countdown timer                   │
└─────────────────────────────────────┘
│                                      │
│ MEAL CARDS (scrollable)              │
│  ┌──────────────────────────────┐  │
│  │ ☀️ BREAKFAST CARD             │  │
│  │ (Past/Active/Upcoming state)  │  │
│  └──────────────────────────────┘  │
│  ┌──────────────────────────────┐  │
│  │ 🍽️ LUNCH CARD                 │  │
│  └──────────────────────────────┘  │
│  ┌──────────────────────────────┐  │
│  │ ☕ SNACKS CARD                │  │
│  └──────────────────────────────┘  │
│  ┌──────────────────────────────┐  │
│  │ 🌙 DINNER CARD                │  │
│  └──────────────────────────────┘  │
│                                      │
└─────────────────────────────────────┘
```

### Component 1: Header Section

```dart
// Create: lib/presentation/screens/home/widgets/header_section.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      height: 180,
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
                          Navigator.of(context).pushNamed('/settings');
                        },
                      ),
                    ],
                  ),
                ],
              ),
              
              const Spacer(),
              
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
                color: isSelected
                    ? Colors.white
                    : Colors.white.withOpacity(0.2),
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
                    color: isSelected
                        ? AppColors.primary
                        : Colors.white,
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
```

### Component 2: Current Meal Indicator

**INSTRUCTION:** Create a widget that:
- Displays the currently active meal OR next upcoming meal
- Shows countdown timer (updates every minute)
- Has meal-specific colored left border (4px wide)
- Floats above meal cards with shadow elevation
- Animates when meal changes

```dart
// Create: lib/presentation/screens/home/widgets/current_meal_indicator.dart

import 'package:flutter/material.dart';
import 'dart:async';

class CurrentMealIndicator extends StatefulWidget {
  final Meal? currentMeal;
  final Meal? nextMeal;

  const CurrentMealIndicator({
    Key? key,
    this.currentMeal,
    this.nextMeal,
  }) : super(key: key);

  @override
  State<CurrentMealIndicator> createState() => _CurrentMealIndicatorState();
}

class _CurrentMealIndicatorState extends State<CurrentMealIndicator> {
  Timer? _timer;
  String _timeRemaining = '';

  @override
  void initState() {
    super.initState();
    _updateTimeRemaining();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      _updateTimeRemaining();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTimeRemaining() {
    if (!mounted) return;
    
    final meal = widget.currentMeal ?? widget.nextMeal;
    if (meal == null) {
      setState(() => _timeRemaining = '');
      return;
    }

    final now = DateTime.now();
    final targetTime = widget.currentMeal != null
        ? meal.endTime
        : meal.startTime;
    
    // Calculate time difference
    final target = DateTime(
      now.year,
      now.month,
      now.day,
      targetTime.hour,
      targetTime.minute,
    );
    
    final diff = target.difference(now);
    
    if (diff.isNegative) {
      setState(() => _timeRemaining = '');
      return;
    }

    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;

    setState(() {
      if (widget.currentMeal != null) {
        if (hours > 0) {
          _timeRemaining = 'Ends in $hours hour${hours > 1 ? 's' : ''} $minutes min';
        } else {
          _timeRemaining = 'Ends in $minutes minute${minutes != 1 ? 's' : ''}';
        }
      } else {
        if (hours > 0) {
          _timeRemaining = 'Starts in $hours hour${hours > 1 ? 's' : ''} $minutes min';
        } else {
          _timeRemaining = 'Starts in $minutes minute${minutes != 1 ? 's' : ''}';
        }
      }
    });
  }

  Color _getMealColor(Meal meal) {
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

  IconData _getMealIcon(Meal meal) {
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
    final meal = widget.currentMeal ?? widget.nextMeal;
    if (meal == null) return const SizedBox.shrink();

    final isActive = widget.currentMeal != null;
    final mealColor = _getMealColor(meal);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border(
          left: BorderSide(
            color: mealColor,
            width: 4,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Row(
          children: [
            // Icon with animation for active meal
            if (isActive)
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.8 + (value * 0.2),
                    child: child,
                  );
                },
                child: Icon(
                  _getMealIcon(meal),
                  size: AppDimensions.iconLarge,
                  color: mealColor,
                ),
              )
            else
              Icon(
                _getMealIcon(meal),
                size: AppDimensions.iconLarge,
                color: mealColor,
              ),
            
            const SizedBox(width: 12),
            
            // Meal info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        meal.name.toUpperCase(),
                        style: AppTextStyles.label.copyWith(
                          color: mealColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isActive) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: mealColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                          ),
                          child: Text(
                            'ACTIVE',
                            style: AppTextStyles.caption.copyWith(
                              color: mealColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${meal.startTime.format(context)} - ${meal.endTime.format(context)}',
                    style: AppTextStyles.body.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
            ),
            
            // Time remaining
            if (_timeRemaining.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    Icons.access_time,
                    size: AppDimensions.iconSmall,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _timeRemaining,
                    style: AppTextStyles.caption.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
```

### Component 3: Meal Card

**INSTRUCTION:** Create a reusable meal card widget with three visual states:
- **Past meal:** 60% opacity, slight grayscale effect
- **Active meal:** 2px colored border, subtle glow, pulsing animation
- **Upcoming meal:** Normal appearance

```dart
// Create: lib/presentation/screens/home/widgets/meal_card.dart

import 'package:flutter/material.dart';

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
        border: isActive
            ? Border.all(color: mealColor, width: 2)
            : null,
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
                        borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
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
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item.name,
                          style: AppTextStyles.body.copyWith(
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildDietaryIndicator(item.type),
                    ],
                  ),
                )).toList(),
                
                if (widget.meal.specialNote != null && 
                    widget.meal.specialNote!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                    ),
                    child: Row(
                      children: [
                        Icon(
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

enum MealState {
  past,
  active,
  upcoming,
}
```

## 📊 DATA MODELS

### INSTRUCTION: Create data models with JSON serialization

```dart
// Create: lib/data/models/meal_model.dart

import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'menu_item_model.dart';

class Meal extends Equatable {
  final String name;
  final String icon;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final List<MenuItem> items;
  final String? specialNote;

  const Meal({
    required this.name,
    required this.icon,
    required this.startTime,
    required this.endTime,
    required this.items,
    this.specialNote,
  });

  bool get isActive {
    final now = TimeOfDay.now();
    final nowMinutes = now.hour * 60 + now.minute;
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;
    return nowMinutes >= startMinutes && nowMinutes < endMinutes;
  }

  bool get isPast {
    final now = TimeOfDay.now();
    final nowMinutes = now.hour * 60 + now.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;
    return nowMinutes >= endMinutes;
  }

  MealState get state {
    if (isPast) return MealState.past;
    if (isActive) return MealState.active;
    return MealState.upcoming;
  }

  factory Meal.fromJson(String mealName, Map<String, dynamic> json) {
    return Meal(
      name: json['name'] as String? ?? mealName,
      icon: json['icon'] as String? ?? 'restaurant_menu',
      startTime: _parseTime(json['start_time'] as String),
      endTime: _parseTime(json['end_time'] as String),
      items: (json['items'] as List<dynamic>)
          .map((item) => MenuItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      specialNote: json['special_note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': icon,
      'start_time': '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}',
      'end_time': '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}',
      'items': items.map((item) => item.toJson()).toList(),
      'special_note': specialNote,
    };
  }

  static TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  @override
  List<Object?> get props => [name, icon, startTime, endTime, items, specialNote];
}

// Create: lib/data/models/menu_item_model.dart

enum DietaryType { veg, nonVeg, vegan, eggetarian }

class MenuItem extends Equatable {
  final String name;
  final DietaryType type;
  final List<String> allergens;
  final String? nutritionalInfo;

  const MenuItem({
    required this.name,
    required this.type,
    this.allergens = const [],
    this.nutritionalInfo,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      name: json['name'] as String,
      type: _parseDietaryType(json['type'] as String),
      allergens: (json['allergens'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      nutritionalInfo: json['nutritional_info'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': _dietaryTypeToString(type),
      'allergens': allergens,
      'nutritional_info': nutritionalInfo,
    };
  }

  static DietaryType _parseDietaryType(String type) {
    switch (type.toLowerCase()) {
      case 'veg':
        return DietaryType.veg;
      case 'non_veg':
      case 'nonveg':
        return DietaryType.nonVeg;
      case 'vegan':
        return DietaryType.vegan;
      case 'eggetarian':
        return DietaryType.eggetarian;
      default:
        return DietaryType.veg;
    }
  }

  static String _dietaryTypeToString(DietaryType type) {
    switch (type) {
      case DietaryType.veg:
        return 'veg';
      case DietaryType.nonVeg:
        return 'non_veg';
      case DietaryType.vegan:
        return 'vegan';
      case DietaryType.eggetarian:
        return 'eggetarian';
    }
  }

  @override
  List<Object?> get props => [name, type, allergens, nutritionalInfo];
}

// Create: lib/data/models/day_menu_model.dart

class DayMenu extends Equatable {
  final String day;
  final Meal breakfast;
  final Meal lunch;
  final Meal snacks;
  final Meal dinner;

  const DayMenu({
    required this.day,
    required this.breakfast,
    required this.lunch,
    required this.snacks,
    required this.dinner,
  });

  List<Meal> get allMeals => [breakfast, lunch, snacks, dinner];

  Meal? get currentMeal {
    return allMeals.firstWhere(
      (meal) => meal.isActive,
      orElse: () => null as Meal,
    );
  }

  Meal? get nextMeal {
    final upcomingMeals = allMeals.where((meal) => !meal.isPast).toList();
    if (upcomingMeals.isEmpty) return null;
    return upcomingMeals.first;
  }

  factory DayMenu.fromJson(String day, Map<String, dynamic> json) {
    return DayMenu(
      day: day,
      breakfast: Meal.fromJson('Breakfast', json['breakfast'] as Map<String, dynamic>),
      lunch: Meal.fromJson('Lunch', json['lunch'] as Map<String, dynamic>),
      snacks: Meal.fromJson('Snacks', json['snacks'] as Map<String, dynamic>),
      dinner: Meal.fromJson('Dinner', json['dinner'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'breakfast': breakfast.toJson(),
      'lunch': lunch.toJson(),
      'snacks': snacks.toJson(),
      'dinner': dinner.toJson(),
    };
  }

  @override
  List<Object?> get props => [day, breakfast, lunch, snacks, dinner];
}
```

## 🔥 FIREBASE REMOTE CONFIG

### INSTRUCTION: Setup Remote Config Service

```dart
// Create: lib/data/services/remote_config_service.dart

import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../models/day_menu_model.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;
  static const String _weeklyMenuKey = 'weekly_menu';
  static const String _menuVersionKey = 'menu_version';

  RemoteConfigService(this._remoteConfig);

  Future<void> initialize() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 30),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

    // Set default values
    await _remoteConfig.setDefaults({
      _weeklyMenuKey: _getDefaultMenu(),
      _menuVersionKey: '1.0.0',
    });
  }

  Future<bool> fetchAndActivate() async {
    try {
      return await _remoteConfig.fetchAndActivate();
    } catch (e) {
      print('Error fetching remote config: $e');
      return false;
    }
  }

  String get menuVersion => _remoteConfig.getString(_menuVersionKey);

  Map<String, DayMenu> getWeeklyMenu() {
    try {
      final jsonString = _remoteConfig.getString(_weeklyMenuKey);
      final menuData = json.decode(jsonString) as Map<String, dynamic>;
      
      return {
        'monday': DayMenu.fromJson('monday', menuData['monday']),
        'tuesday': DayMenu.fromJson('tuesday', menuData['tuesday']),
        'wednesday': DayMenu.fromJson('wednesday', menuData['wednesday']),
        'thursday': DayMenu.fromJson('thursday', menuData['thursday']),
        'friday': DayMenu.fromJson('friday', menuData['friday']),
        'saturday': DayMenu.fromJson('saturday', menuData['saturday']),
        'sunday': DayMenu.fromJson('sunday', menuData['sunday']),
      };
    } catch (e) {
      print('Error parsing weekly menu: $e');
      return {};
    }
  }

  String _getDefaultMenu() {
    // Default menu in case Firebase is unavailable
    return json.encode({
      'monday': _getDefaultDayMenu(),
      'tuesday': _getDefaultDayMenu(),
      'wednesday': _getDefaultDayMenu(),
      'thursday': _getDefaultDayMenu(),
      'friday': _getDefaultDayMenu(),
      'saturday': _getDefaultDayMenu(),
      'sunday': _getDefaultDayMenu(),
    });
  }

  Map<String, dynamic> _getDefaultDayMenu() {
    return {
      'breakfast': {
        'name': 'Breakfast',
        'icon': 'sunrise',
        'start_time': '07:00',
        'end_time': '09:30',
        'items': [
          {'name': 'Poha', 'type': 'veg', 'allergens': []},
          {'name': 'Bread & Butter', 'type': 'veg', 'allergens': ['gluten', 'dairy']},
          {'name': 'Tea/Coffee', 'type': 'veg', 'allergens': ['dairy']},
        ],
        'special_note': '',
      },
      'lunch': {
        'name': 'Lunch',
        'icon': 'restaurant',
        'start_time': '11:30',
        'end_time': '14:00',
        'items': [
          {'name': 'Dal', 'type': 'veg', 'allergens': []},
          {'name': 'Sabzi', 'type': 'veg', 'allergens': []},
          {'name': 'Rice', 'type': 'vegan', 'allergens': []},
          {'name': 'Roti', 'type': 'vegan', 'allergens': ['gluten']},
        ],
        'special_note': '',
      },
      'snacks': {
        'name': 'Snacks',
        'icon': 'local_cafe',
        'start_time': '16:30',
        'end_time': '18:00',
        'items': [
          {'name': 'Samosa', 'type': 'veg', 'allergens': ['gluten']},
          {'name': 'Tea/Coffee', 'type': 'veg', 'allergens': ['dairy']},
        ],
        'special_note': '',
      },
      'dinner': {
        'name': 'Dinner',
        'icon': 'dinner_dining',
        'start_time': '19:30',
        'end_time': '22:00',
        'items': [
          {'name': 'Dal', 'type': 'veg', 'allergens': []},
          {'name': 'Sabzi', 'type': 'veg', 'allergens': []},
          {'name': 'Rice', 'type': 'vegan', 'allergens': []},
          {'name': 'Roti', 'type': 'vegan', 'allergens': ['gluten']},
        ],
        'special_note': '',
      },
    };
  }
}
```

## 💾 CACHING SERVICE

### INSTRUCTION: Implement local caching using Hive

```dart
// Create: lib/data/services/cache_service.dart

import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import '../models/day_menu_model.dart';

class CacheService {
  static const String _menuBoxName = 'menu_cache';
  static const String _menuKey = 'weekly_menu';
  static const String _versionKey = 'menu_version';
  static const String _timestampKey = 'last_updated';

  late Box _box;

  Future<void> initialize() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_menuBoxName);
  }

  Future<void> cacheMenu(
    Map<String, DayMenu> weeklyMenu,
    String version,
  ) async {
    final menuJson = weeklyMenu.map(
      (key, value) => MapEntry(key, value.toJson()),
    );

    await _box.put(_menuKey, json.encode(menuJson));
    await _box.put(_versionKey, version);
    await _box.put(_timestampKey, DateTime.now().toIso8601String());
  }

  Map<String, DayMenu>? getCachedMenu() {
    try {
      final menuString = _box.get(_menuKey) as String?;
      if (menuString == null) return null;

      final menuData = json.decode(menuString) as Map<String, dynamic>;
      return menuData.map(
        (key, value) => MapEntry(
          key,
          DayMenu.fromJson(key, value as Map<String, dynamic>),
        ),
      );
    } catch (e) {
      print('Error retrieving cached menu: $e');
      return null;
    }
  }

  String? getCachedVersion() {
    return _box.get(_versionKey) as String?;
  }

  DateTime? getLastUpdated() {
    final timestamp = _box.get(_timestampKey) as String?;
    if (timestamp == null) return null;
    return DateTime.parse(timestamp);
  }

  bool isCacheValid({Duration maxAge = const Duration(days: 7)}) {
    final lastUpdated = getLastUpdated();
    if (lastUpdated == null) return false;
    return DateTime.now().difference(lastUpdated) < maxAge;
  }

  Future<void> clearCache() async {
    await _box.clear();
  }
}
```

## 🎭 STATE MANAGEMENT

### INSTRUCTION: Create Menu Provider with ChangeNotifier

```dart
// Create: lib/providers/menu_provider.dart

import 'package:flutter/foundation.dart';
import '../data/models/day_menu_model.dart';
import '../data/models/meal_model.dart';
import '../data/services/remote_config_service.dart';
import '../data/services/cache_service.dart';

class MenuProvider extends ChangeNotifier {
  final RemoteConfigService _remoteConfigService;
  final CacheService _cacheService;

  Map<String, DayMenu> _weeklyMenu = {};
  bool _isLoading = false;
  String? _error;
  DateTime? _lastUpdated;

  MenuProvider(this._remoteConfigService, this._cacheService);

  Map<String, DayMenu> get weeklyMenu => _weeklyMenu;
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime? get lastUpdated => _lastUpdated;

  DayMenu? getDayMenu(int dayIndex) {
    final days = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
    if (dayIndex < 0 || dayIndex >= days.length) return null;
    return _weeklyMenu[days[dayIndex]];
  }

  DayMenu? get todayMenu {
    final today = DateTime.now().weekday - 1;
    return getDayMenu(today);
  }

  Meal? get currentMeal {
    return todayMenu?.currentMeal;
  }

  Meal? get nextMeal {
    return todayMenu?.nextMeal;
  }

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Try to load from cache first
      final cachedMenu = _cacheService.getCachedMenu();
      if (cachedMenu != null && _cacheService.isCacheValid()) {
        _weeklyMenu = cachedMenu;
        _lastUpdated = _cacheService.getLastUpdated();
        _isLoading = false;
        notifyListeners();

        // Fetch updates in background
        _fetchMenuInBackground();
        return;
      }

      // No valid cache, fetch from remote
      await fetchMenu();
    } catch (e) {
      _error = 'Failed to load menu: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMenu() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _remoteConfigService.initialize();
      final updated = await _remoteConfigService.fetchAndActivate();

      _weeklyMenu = _remoteConfigService.getWeeklyMenu();
      _lastUpdated = DateTime.now();

      // Cache the menu
      await _cacheService.cacheMenu(
        _weeklyMenu,
        _remoteConfigService.menuVersion,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to fetch menu: $e';
      _isLoading = false;
      notifyListeners();

      // Try to load from cache as fallback
      final cachedMenu = _cacheService.getCachedMenu();
      if (cachedMenu != null) {
        _weeklyMenu = cachedMenu;
        _lastUpdated = _cacheService.getLastUpdated();
        notifyListeners();
      }
    }
  }

  Future<void> _fetchMenuInBackground() async {
    try {
      await _remoteConfigService.fetchAndActivate();
      final newMenu = _remoteConfigService.getWeeklyMenu();
      final newVersion = _remoteConfigService.menuVersion;
      final cachedVersion = _cacheService.getCachedVersion();

      // Only update if version changed
      if (newVersion != cachedVersion) {
        _weeklyMenu = newMenu;
        _lastUpdated = DateTime.now();
        await _cacheService.cacheMenu(newMenu, newVersion);
        notifyListeners();
      }
    } catch (e) {
      print('Background fetch failed: $e');
    }
  }

  Future<void> refresh() async {
    await fetchMenu();
  }
}
```

## 🏠 COMPLETE HOME SCREEN

### INSTRUCTION: Assemble all components into Home Screen

```dart
// Create: lib/presentation/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/menu_provider.dart';
import '../../../providers/theme_provider.dart';
import 'widgets/header_section.dart';
import 'widgets/current_meal_indicator.dart';
import 'widgets/meal_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

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

                if (menuProvider.error != null && menuProvider.weeklyMenu.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 64, color: Colors.grey),
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
                              (_animationController.value - (delay / 400)).clamp(0.0, 1.0),
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
```

## 📱 MEAL DETAIL BOTTOM SHEET

### INSTRUCTION: Create interactive bottom sheet for meal details

```dart
// Create: lib/presentation/widgets/meal_detail_sheet.dart

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class MealDetailSheet extends StatelessWidget {
  final Meal meal;

  const MealDetailSheet({
    Key? key,
    required this.meal,
  }) : super(key: key);

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
                                  color: Theme.of(context).textTheme.bodyMedium?.color,
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

                    if (meal.specialNote != null && meal.specialNote!.isNotEmpty) ...[
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

                    ...meal.items.asMap().entries.map((entry) {
                      final item = entry.value;
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
                                      color: Theme.of(context).textTheme.bodyLarge?.color,
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
                    }).toList(),

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
```

## ⚙️ THEME CONFIGURATION

### INSTRUCTION: Setup complete theme system

```dart
// Create: lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.lightSurface,
        background: AppColors.lightBackground,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.lightTextPrimary,
        onBackground: AppColors.lightTextPrimary,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.lightBackgroundSecondary,
      cardColor: AppColors.lightSurface,
      dividerColor: AppColors.lightBorder,
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(color: AppColors.lightTextPrimary),
        displayMedium: AppTextStyles.display.copyWith(color: AppColors.lightTextPrimary),
        headlineLarge: AppTextStyles.headlineLarge.copyWith(color: AppColors.lightTextPrimary),
        headlineMedium: AppTextStyles.headline.copyWith(color: AppColors.lightTextPrimary),
        titleLarge: AppTextStyles.title.copyWith(color: AppColors.lightTextPrimary),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.lightTextPrimary),
        bodyMedium: AppTextStyles.body.copyWith(color: AppColors.lightTextSecondary),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.lightTextSecondary),
        labelLarge: AppTextStyles.label.copyWith(color: AppColors.lightTextPrimary),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.label,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primary),
          foregroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.label,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: AppColors.lightSurface,
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryLight,
        secondary: AppColors.secondaryLight,
        surface: AppColors.darkSurface,
        background: AppColors.darkBackground,
        error: AppColors.error,
        onPrimary: AppColors.darkBackground,
        onSecondary: AppColors.darkBackground,
        onSurface: AppColors.darkTextPrimary,
        onBackground: AppColors.darkTextPrimary,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.darkBackgroundSecondary,
      cardColor: AppColors.darkSurface,
      dividerColor: AppColors.darkBorder,
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(color: AppColors.darkTextPrimary),
        displayMedium: AppTextStyles.display.copyWith(color: AppColors.darkTextPrimary),
        headlineLarge: AppTextStyles.headlineLarge.copyWith(color: AppColors.darkTextPrimary),
        headlineMedium: AppTextStyles.headline.copyWith(color: AppColors.darkTextPrimary),
        titleLarge: AppTextStyles.title.copyWith(color: AppColors.darkTextPrimary),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.darkTextPrimary),
        bodyMedium: AppTextStyles.body.copyWith(color: AppColors.darkTextSecondary),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.darkTextSecondary),
        labelLarge: AppTextStyles.label.copyWith(color: AppColors.darkTextPrimary),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.transparent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.darkBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.label,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primaryLight),
          foregroundColor: AppColors.primaryLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.label,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: AppColors.darkSurface,
      ),
    );
  }
}

// Create: lib/providers/theme_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  static const String _themeKey = 'theme_mode';

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode);
    notifyListeners();
  }

  Future<void> setTheme(bool isDark) async {
    _isDarkMode = isDark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
    notifyListeners();
  }
}
```

## 🚀 MAIN APPLICATION SETUP

### INSTRUCTION: Initialize app with Firebase and providers

```dart
// Create: lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'core/theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'providers/menu_provider.dart';
import 'data/services/remote_config_service.dart';
import 'data/services/cache_service.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize Cache Service
  final cacheService = CacheService();
  await cacheService.initialize();
  
  // Initialize Remote Config
  final remoteConfig = FirebaseRemoteConfig.instance();
  final remoteConfigService = RemoteConfigService(remoteConfig);
  
  // Set system UI overlays
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) => MenuProvider(remoteConfigService, cacheService)..initialize(),
        ),
      ],
      child: const IITJMenuApp(),
    ),
  );
}

class IITJMenuApp extends StatelessWidget {
  const IITJMenuApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'IITJ Menu',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/home': (context) => const HomeScreen(),
          },
        );
      },
    );
  }
}
```

## 📋 FIREBASE REMOTE CONFIG JSON TEMPLATE

### INSTRUCTION: Upload this exact JSON to Firebase Remote Config

```json
{
  "menu_version": "1.0.0",
  "last_updated": "2024-11-23T10:00:00Z",
  "weekly_menu": {
    "monday": {
      "breakfast": {
        "name": "Breakfast",
        "icon": "sunrise",
        "start_time": "07:00",
        "end_time": "09:30",
        "items": [
          {"name": "Poha with Namkeen", "type": "veg", "allergens": []},
          {"name": "Bread & Butter", "type": "veg", "allergens": ["gluten", "dairy"]},
          {"name": "Banana", "type": "vegan", "allergens": []},
          {"name": "Tea/Coffee/Milk", "type": "veg", "allergens": ["dairy"]}
        ],
        "special_note": ""
      },
      "lunch": {
        "name": "Lunch",
        "icon": "restaurant",
        "start_time": "11:30",
        "end_time": "14:00",
        "items": [
          {"name": "Dal Tadka", "type": "veg", "allergens": []},
          {"name": "Paneer Butter Masala", "type": "veg", "allergens": ["dairy"]},
          {"name": "Jeera Rice", "type": "vegan", "allergens": []},
          {"name": "Roti (4 pcs)", "type": "vegan", "allergens": ["gluten"]},
          {"name": "Salad & Pickle", "type": "vegan", "allergens": []},
          {"name": "Gulab Jamun", "type": "veg", "allergens": ["dairy", "gluten"]}
        ],
        "special_note": "Chef's Special Today!"
      },
      "snacks": {
        "name": "Snacks",
        "icon": "local_cafe",
        "start_time": "16:30",
        "end_time": "18:00",
        "items": [
          {"name": "Samosa (2 pcs)", "type": "veg", "allergens": ["gluten"]},
          {"name": "Green Chutney", "type": "vegan", "allergens": []},
          {"name": "Tea/Coffee", "type": "veg", "allergens": ["dairy"]}
        ],
        "special_note": ""
      },
      "dinner": {
        "name": "Dinner",
        "icon": "dinner_dining",
        "start_time": "19:30",
        "end_time": "22:00",
        "items": [
          {"name": "Mixed Dal", "type": "veg", "allergens": []},
          {"name": "Aloo Gobi", "type": "vegan", "allergens": []},
          {"name": "Plain Rice", "type": "vegan", "allergens": []},
          {"name": "Roti (4 pcs)", "type": "vegan", "allergens": ["gluten"]},
          {"name": "Curd", "type": "veg", "allergens": ["dairy"]}
        ],
        "special_note": ""
      }
    }
  }
}
```

**INSTRUCTION:** Duplicate the Monday structure for Tuesday through Sunday with appropriate menu changes.

## ✅ DEVELOPMENT CHECKLIST

### Phase 1: Setup (Day 1)
- [ ] Create Flutter project: `flutter create iitj_menu`
- [ ] Add all dependencies to pubspec.yaml
- [ ] Create complete folder structure
- [ ] Setup Firebase project (Android + iOS)
- [ ] Download and add google-services.json (Android)
- [ ] Download and add GoogleService-Info.plist (iOS)
- [ ] Setup Firebase Remote Config with JSON template
- [ ] Initialize Git repository

### Phase 2: Core Files (Day 1-2)
- [ ] Create app_colors.dart with all colors
- [ ] Create app_text_styles.dart with typography
- [ ] Create app_dimensions.dart with spacing
- [ ] Create app_theme.dart with light/dark themes
- [ ] Create data models (Meal, MenuItem, DayMenu)
- [ ] Create RemoteConfigService
- [ ] Create CacheService
- [ ] Create providers (ThemeProvider, MenuProvider)

### Phase 3: Splash Screen (Day 2)
- [ ] Build SplashScreen widget
- [ ] Implement logo fade-in animation
- [ ] Add tagline and credit animations
- [ ] Test animation timing (2-3 seconds)
- [ ] Implement navigation to home

### Phase 4: Home Screen Components (Day 2-3)
- [ ] Build HeaderSection widget
- [ ] Create WeekDaySelector with pills
- [ ] Build CurrentMealIndicator
- [ ] Implement countdown timer logic
- [ ] Create MealCard widget
- [ ] Implement three states (past/active/upcoming)
- [ ] Add pulse animation for active meal
- [ ] Implement staggered card loading

### Phase 5: Home Screen Assembly (Day 3)
- [ ] Build HomeScreen with CustomScrollView
- [ ] Integrate all components
- [ ] Connect to MenuProvider
- [ ] Implement pull-to-refresh
- [ ] Add loading states
- [ ] Add error handling UI
- [ ] Test day selection functionality

### Phase 6: Meal Details (Day 3-4)
- [ ] Create MealDetailSheet widget
- [ ] Implement draggable sheet behavior
- [ ] Add dietary badges
- [ ] Implement share functionality
- [ ] Add allergen warnings display
- [ ] Test on different screen sizes

### Phase 7: Additional Features (Day 4-5)
- [ ] Implement theme toggle functionality
- [ ] Add Settings screen (basic)
- [ ] Create Weekly view screen (optional)
- [ ] Implement search functionality (optional)
- [ ] Add favorites system (optional)
- [ ] Setup local notifications (optional)

### Phase 8: Polish & Testing (Day 5-6)
- [ ] Test all animations
- [ ] Verify theme switching works
- [ ] Test offline functionality
- [ ] Check Remote Config updates
- [ ] Test on different devices/screen sizes
- [ ] Optimize performance
- [ ] Fix any bugs
- [ ] Add proper error messages

### Phase 9: Deployment Preparation (Day 6-7)
- [ ] Generate app icons (1024×1024)
- [ ] Create adaptive icons for Android
- [ ] Setup splash screen for Android 12+
- [ ] Configure app signing (Android)
- [ ] Update app name and package name
- [ ] Set version (1.0.0+1)
- [ ] Create screenshots for stores
- [ ] Write app description

### Phase 10: Launch (Day 7)
- [ ] Build release APK/AAB
- [ ] Test release build
- [ ] Submit to Play Store
- [ ] Submit to App Store (if iOS)
- [ ] Share with IITJ community
- [ ] Collect feedback

## 🎯 CRITICAL SUCCESS FACTORS

### Performance Targets
- **App startup:** < 2 seconds
- **Menu load time:** < 1 second (cached) / < 3 seconds (network)
- **Animation FPS:** Consistent 60 FPS
- **APK size:** < 20 MB
- **Memory usage:** < 100 MB

### Code Quality Standards
- Use `const` constructors wherever possible
- Dispose all animation controllers
- Handle all async errors with try-catch
- Add meaningful comments for complex logic
- Follow Flutter naming conventions
- Keep widgets under 300 lines
- Extract reusable components

### User Experience Principles
1. **Zero Loading State:** Show cached data immediately
2. **Smooth Animations:** No janky or stuttering motion
3. **Clear Feedback:** Loading indicators, success/error messages
4. **Intuitive Navigation:** Natural gestures and flows
5. **Accessibility:** Proper contrast, touch targets >44px
6. **Offline First:** App should work without internet

## 🔍 TESTING CHECKLIST

### Functional Testing
- [ ] Splash screen displays correctly
- [ ] Menu loads from Firebase Remote Config
- [ ] Cache stores and retrieves data
- [ ] Current meal is highlighted correctly
- [ ] Countdown timer updates every minute
- [ ] Day selector changes menu
- [ ] Theme toggle works
- [ ] Pull to refresh updates menu
- [ ] Meal details sheet opens
- [ ] Share functionality works
- [ ] All animations play smoothly

### Edge Cases
- [ ] No internet connection (offline mode)
- [ ] Firebase Remote Config fails
- [ ] Empty menu data
- [ ] Invalid JSON format
- [ ] Midnight transition (day change)
- [ ] Between meals (no active meal)
- [ ] After all meals (late night)
- [ ] App backgrounded during animation
- [ ] Rapid day switching
- [ ] Multiple pull-to-refresh triggers

### Device Testing
- [ ] Different screen sizes (small to tablet)
- [ ] Different Android versions (5.0+)
- [ ] Different iOS versions (12.0+)
- [ ] Light and dark mode
- [ ] Portrait and landscape
- [ ] Different font scaling
- [ ] Low-end devices (performance)

## 📚 PROMPT ENGINEERING TIPS FOR AI ASSISTANCE

When asking AI to help build components:

1. **Be Specific:**
   - "Create the MealCard widget with pulse animation for active state"
   - "Implement RemoteConfigService with error handling and caching"

2. **Provide Context:**
   - "Using the AppColors and AppTextStyles constants"
   - "Following the MealState enum (past/active/upcoming)"

3. **Reference Existing Code:**
   - "Based on the Meal model defined earlier"
   - "Using the same animation style as HeaderSection"

4. **Request Complete Implementation:**
   - "Include all imports and proper error handling"
   - "Add comments explaining complex logic"

5. **Ask for Testing:**
   - "How can I test this animation?"
   - "What edge cases should I handle?"

## 🎨 DESIGN TOKENS REFERENCE

Quick copy-paste values for consistent design:

```dart
// Spacing
xs: 4, sm: 8, md: 16, lg: 24, xl: 32, xxl: 48, xxxl: 64

// Border Radius
small: 8, medium: 12, large: 16, xlarge: 24, round: 999

// Colors (Hex)
Primary: #6366F1, Secondary: #F59E0B
Breakfast: #FCD34D, Lunch: #10B981
Snacks: #F59E0B, Dinner: #6366F1

// Animation Durations
splash: 2500ms, transition: 300ms, stagger: 100ms
pulse: 2000ms, micro: 150ms

// Font Sizes
display: 28px, headline: 20px, title: 18px
body: 14px, caption: 12px
```

## 🏆 FINAL DELIVERABLES

Upon completion, you should have:

1. ✅ Fully functional Flutter app
2. ✅ Firebase project configured
3. ✅ Remote Config with weekly menu
4. ✅ Beautiful UI with smooth animations
5. ✅ Offline support with caching
6. ✅ Theme switching (light/dark)
7. ✅ Release-ready APK/AAB
8. ✅ Screenshots for store listing
9. ✅ Source code on Git repository
10. ✅ Documentation for future updates

## 📞 SUPPORT & MAINTENANCE PLAN

### Week 1 Post-Launch:
- Monitor crash reports daily
- Respond to user feedback
- Fix critical bugs within 24 hours
- Update menu monthly

### Month 1:
- Collect feature requests
- Analyze usage patterns
- Plan v1.1 features
- Optimize based on analytics

### Ongoing:
- App has monthly menu updates
- Monthly minor updates (bug fixes)
- Quarterly major updates (new features)
- Continuous monitoring and improvement

---

## 🎯 EXECUTION COMMAND

**AI Assistant: You now have complete instructions to build the IITJ Menu app. Follow this document systematically, creating each file and component exactly as specified. Prioritize code quality, performance, and user experience. When in doubt, refer back to this document for design tokens, patterns, and best practices.**

**Start with Phase 1 setup and proceed sequentially through all phases. Test thoroughly at each stage. The goal is a production-ready app that will impress the IITJ community.**

---

**Made with ❤️ for IITJ Community**  
**Developer: Om Tathed**  
**Document Version: 1.0.0**  
**Last Updated: November 2025**

*This is your complete blueprint. Build something amazing!* 🚀