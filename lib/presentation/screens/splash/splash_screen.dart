import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../providers/app_config_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _bgController;
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

    _bgController = AnimationController(
      duration: const Duration(seconds: 10),
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
    _bgController.repeat();
  }

  Future<void> _navigateToHome() async {
    // Wait for splash animation
    await Future.delayed(const Duration(milliseconds: 2500));

    // Wait for app config to be loaded
    if (mounted) {
      final appConfigProvider = context.read<AppConfigProvider>();
      while (appConfigProvider.isLoading) {
        await Future.delayed(const Duration(milliseconds: 100));
        if (!mounted) return;
      }

      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/hub');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // Calculate width based on 1920x1080 aspect ratio maintaining height
    final bgImageWidth = screenHeight * (1920 / 1080);

    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
            ),
          ),

          // Background Animation
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) {
              // Animate from left to right (showing leftmost part to rightmost part)
              final maxOffset = bgImageWidth - screenWidth;
              // Use a linear motion or curve as preferred.
              // Using linear for continuous panning feel.
              final offset = maxOffset * _bgController.value;

              return Positioned(
                left: -offset,
                top: 0,
                bottom: 0,
                width: bgImageWidth,
                child: Image.asset(
                  'assets/images/bottom_animation.png',
                  fit: BoxFit.fitHeight,
                ),
              );
            },
          ),

          // Content
          Center(
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
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      // color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    // padding: const EdgeInsets.all(16),
                    child: Image.asset(
                      'assets/images/SplashScreenImage.png',
                      fit: BoxFit.contain,
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
                    'Made with ❤️ for IITJ Community',
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
        ],
      ),
    );
  }
}
