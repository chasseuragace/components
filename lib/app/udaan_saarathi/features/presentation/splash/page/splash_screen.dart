import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/app_home_navigation/app_home_navigation_page.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/onboarding/page/onboarding_screen_1.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/onboarding/providers/onboarding_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
    Timer(const Duration(seconds: 3), () async {
      if (!mounted) return;
      // Decide destination using Riverpod onboarding controller
      final shouldShowOnboarding =
          await ref.read(onboardingControllerProvider.future);
      if (!mounted) return;
      if (!shouldShowOnboarding) {
        // Navigator.pushReplacementNamed(context, RouteConstants.kOnboarding);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const OnboardingScreen1()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => const AppHomeNavigationPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 80),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // App Logo/Icon
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF4F7DF9),
                                    Color(0xFF6C5CE7),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF4F7DF9,
                                    ).withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.flight_takeoff_rounded,
                                color: Colors.white,
                                size: 60,
                              ),
                            ),

                            const SizedBox(height: 40),

                            const Text(
                              'UdaanSarathi',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3748),
                                letterSpacing: 1.2,
                              ),
                            ),

                            const SizedBox(height: 12),

                            const Text(
                              'Your Career Companion',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF718096),
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.5,
                              ),
                            ),

                            const SizedBox(height: 50),

                            // Loading indicator (centered)
                            Center(
                              child: Container(
                                width: 80,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE2E8F0),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: _fadeAnimation.value,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF4F7DF9),
                                          Color(0xFF6C5CE7),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'Powered by',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9CA3AF),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'MASOVISON',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4F7DF9),
                              letterSpacing: 2.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
