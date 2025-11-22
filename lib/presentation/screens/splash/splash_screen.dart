import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

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
