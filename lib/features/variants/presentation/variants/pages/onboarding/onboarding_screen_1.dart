import 'package:flutter/material.dart';

class OnboardingScreen1 extends StatefulWidget {
  const OnboardingScreen1({super.key});

  @override
  State<OnboardingScreen1> createState() => _OnboardingScreen1State();
}

class _OnboardingScreen1State extends State<OnboardingScreen1> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingData> _onboardingData = [
    OnboardingData(
      title: "Welcome to Udaan Sarathi",
      description:
          "Your journey companion that helps you soar high and achieve your dreams with confidence and guidance.",
      image: Icons.flight_takeoff,
      primaryColor: const Color(0xFF6366F1),
      secondaryColor: const Color(0xFF8B5CF6),
    ),
    OnboardingData(
      title: "Navigate Your Path",
      description:
          "Discover personalized routes to success with smart recommendations and expert insights tailored just for you.",
      image: Icons.explore,
      primaryColor: const Color(0xFF06B6D4),
      secondaryColor: const Color(0xFF0EA5E9),
    ),
    OnboardingData(
      title: "Achieve Together",
      description:
          "Join a community of achievers and unlock your potential with collaborative tools and shared experiences.",
      image: Icons.groups,
      primaryColor: const Color(0xFF10B981),
      secondaryColor: const Color(0xFF059669),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _onboardingData[_currentIndex].primaryColor.withOpacity(0.1),
              _onboardingData[_currentIndex].secondaryColor.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 60),
                    Text(
                      "udaan sarathi",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _onboardingData[_currentIndex].primaryColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Handle skip action
                      },
                      child: const Text(
                        "Skip",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),

              // PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: _onboardingData.length,
                  itemBuilder: (context, index) {
                    return _buildOnboardingScreen(_onboardingData[index]);
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
                        _onboardingData.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: _currentIndex == index ? 24 : 8,
                          decoration: BoxDecoration(
                            color: _currentIndex == index
                                ? _onboardingData[_currentIndex].primaryColor
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
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.arrow_back_ios,
                                      size: 16,
                                      color: _onboardingData[_currentIndex]
                                          .primaryColor,
                                    ),
                                    Text(
                                      "Previous",
                                      style: TextStyle(
                                        color: _onboardingData[_currentIndex]
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
                          onPressed: () {
                            if (_currentIndex < _onboardingData.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              // Handle get started action
                              print("Get Started pressed");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _onboardingData[_currentIndex].primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 4,
                            shadowColor: _onboardingData[_currentIndex]
                                .primaryColor
                                .withOpacity(0.3),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _currentIndex < _onboardingData.length - 1
                                    ? "Next"
                                    : "Get Started",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                _currentIndex < _onboardingData.length - 1
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
      ),
    );
  }

  Widget _buildOnboardingScreen(OnboardingData data) {
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
}

class OnboardingData {
  final String title;
  final String description;
  final IconData image;
  final Color primaryColor;
  final Color secondaryColor;

  OnboardingData({
    required this.title,
    required this.description,
    required this.image,
    required this.primaryColor,
    required this.secondaryColor,
  });
}
