import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/usecases/usecase.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/onboarding/entity.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/Onboarding/providers/di.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/onboarding/providers/onboarding_controller.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/page/set_preferences_screen.dart';


class OnboardingScreen1 extends ConsumerStatefulWidget {
  final List<OnboardingEntity> onboardingData;
  const OnboardingScreen1({super.key,this.onboardingData=const[]});

  @override
  ConsumerState<OnboardingScreen1> createState() => _OnboardingScreen1State();
}

class _OnboardingScreen1State extends ConsumerState<OnboardingScreen1> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
   final onboardingData= widget.onboardingData;
    return Scaffold(
        body: Builder(
          builder: (context) {
             Widget _buildOnboardingScreen(OnboardingEntity data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated icon container
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  data.primaryColor.withOpacity(0.2),
                  data.secondaryColor.withOpacity(0.1),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: data.primaryColor.withOpacity(0.2),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(data.image, size: 80, color: data.primaryColor),
          ),

          const SizedBox(height: 50),

          // Title
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 20),

          // Description
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              height: 1.6,
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(height: 50),
        ],
      ),
    );
  }

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    onboardingData[_currentIndex].primaryColor.withOpacity(0.1),
                    onboardingData[_currentIndex].secondaryColor.withOpacity(0.05),
                    Colors.white,
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Skip button
                    // Padding(
                    //   padding: const EdgeInsets.all(20.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       const SizedBox(width: 60),
                    //       Text(
                    //         "udaan sarathi",
                    //         style: TextStyle(
                    //           fontSize: 20,
                    //           fontWeight: FontWeight.bold,
                    //           color: _onboardingData[_currentIndex].primaryColor,
                    //         ),
                    //       ),
                    //       TextButton(
                    //         onPressed: () {
                    //           // Handle skip action
                    //         },
                    //         child: const Text(
                    //           "Skip",
                    //           style: TextStyle(fontSize: 16, color: Colors.grey),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
            
                    // PageView
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        itemCount: onboardingData.length,
                        itemBuilder: (context, index) {
                          return _buildOnboardingScreen(onboardingData[index]);
                        },
                      ),
                    ),
            
                    // Bottom section with indicators and navigation
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: [
                          // Page indicators
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              onboardingData.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                height: 8,
                                width: _currentIndex == index ? 24 : 8,
                                decoration: BoxDecoration(
                                  color: _currentIndex == index
                                      ? onboardingData[_currentIndex].primaryColor
                                      : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
            
                          const SizedBox(height: 30),
            
                          // Navigation buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Previous button
                              _currentIndex > 0
                                  ? TextButton(
                                      onPressed: () {
                                        _pageController.previousPage(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.arrow_back_ios,
                                            size: 16,
                                            color: onboardingData[_currentIndex]
                                                .primaryColor,
                                          ),
                                          Text(
                                            "Previous",
                                            style: TextStyle(
                                              color: onboardingData[_currentIndex]
                                                  .primaryColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(width: 80),
            
                              // Next/Get Started button
                              ElevatedButton(
                                onPressed: () async {
                                  if (_currentIndex < onboardingData.length - 1) {
                                    _pageController.nextPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  } else {
                                    // Mark onboarding complete and go to home
                                    await ref
                                        .read(onboardingControllerProvider.notifier)
                                        .markCompleted();
                                    if (!context.mounted) return;
                                    // Navigator.pushReplacementNamed(
                                    //     context, RouteConstants.kSetPreferences);
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SetPreferenceScreen(),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      onboardingData[_currentIndex].primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  elevation: 4,
                                  shadowColor: onboardingData[_currentIndex]
                                      .primaryColor
                                      .withOpacity(0.3),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _currentIndex < onboardingData.length - 1
                                          ? "Next"
                                          : "Get Started",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      _currentIndex < onboardingData.length - 1
                                          ? Icons.arrow_forward_ios
                                          : Icons.rocket_launch,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      );
   
  }

 }
