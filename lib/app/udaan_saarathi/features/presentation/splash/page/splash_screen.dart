import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/splash/providers/splash_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

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
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Wait for both animation and splash checks to complete
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    // Ask controller for the route to navigate to
    final routeName = await ref.read(splashControllerProvider).determineRoute();
    if (!mounted) return;

    // Navigate using named routes
    print("pushing $routeName");

    Navigator.of(context)
      ..popUntil((r) => r.isFirst)
      ..pushReplacementNamed(routeName);
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
                            // Container(
                            //   width: 120,
                            //   height: 120,
                            //   decoration: BoxDecoration(
                            //     gradient: const LinearGradient(
                            //       colors: [
                            //         AppColors.primaryColor,
                            //         AppColors.primaryDarkColor,
                            //       ],
                            //       begin: Alignment.topLeft,
                            //       end: Alignment.bottomRight,
                            //     ),
                            //     borderRadius: BorderRadius.circular(30),
                            //     boxShadow: [
                            //       BoxShadow(
                            //         color: AppColors.primaryColor
                            //             .withValues(alpha: 0.3),
                            //         blurRadius: 20,
                            //         offset: const Offset(0, 10),
                            //       ),
                            //     ],
                            //   ),
                            //   child: const Icon(
                            //     Icons.flight_takeoff_rounded,
                            //     color: Colors.white,
                            //     size: 60,
                            //   ),
                            // ),
                            // SvgPicture.asset(
                            //   'assets/svg/sarathi_logo.svg',
                            //   width: 120,
                            //   height: 120,
                            // ),
                            Image.asset('assets/images/svg_logo.png',
                                width: 150, height: 150),
                            // const SizedBox(height: 40),
                            const Text(
                              'UdaanSarathi',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
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
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.lightBlueColor,
                                          AppColors.primaryColor,
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
                              color: AppColors.primaryColor,
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
