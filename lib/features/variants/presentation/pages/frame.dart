import 'package:flutter/material.dart';

class MobileFrameDemo extends StatelessWidget {
  const MobileFrameDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Mobile Frame UI'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: MobileFrame(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue[400]!, Colors.purple[400]!],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone_android, size: 64, color: Colors.white),
                SizedBox(height: 20),
                Text(
                  'Your App Content',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Place your UI here',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MobileFrame extends StatelessWidget {
  final Widget child;
  final double frameWidth;
  final double frameHeight;
  final Color frameColor;
  final double cornerRadius;

  const MobileFrame({
    super.key,
    required this.child,
    this.frameWidth = 300,
    this.frameHeight = 600,
    this.frameColor = Colors.black,
    this.cornerRadius = 35,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: frameWidth,
      height: frameHeight,
      decoration: BoxDecoration(
        color: frameColor,
        borderRadius: BorderRadius.circular(cornerRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Main screen area
          Positioned(
            top: 8,
            left: 8,
            right: 8,
            bottom: 8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(cornerRadius - 8),
              child: child,
            ),
          ),
          // Notch
          Positioned(
            top: 0,
            left: frameWidth * 0.3,
            child: Container(
              width: frameWidth * 0.4,
              height: 30,
              decoration: BoxDecoration(
                color: frameColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
            ),
          ),
          // Speaker
          Positioned(
            top: 8,
            left: frameWidth * 0.35,
            child: Container(
              width: frameWidth * 0.3,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          // Front camera
          Positioned(
            top: 6,
            right: frameWidth * 0.35,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          // Home indicator (for newer iPhones)
          Positioned(
            bottom: 8,
            left: frameWidth * 0.4,
            child: Container(
              width: frameWidth * 0.2,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Alternative Android-style frame
class AndroidMobileFrame extends StatelessWidget {
  final Widget child;
  final double frameWidth;
  final double frameHeight;
  final Color frameColor;

  const AndroidMobileFrame({
    super.key,
    required this.child,
    this.frameWidth = 300,
    this.frameHeight = 600,
    this.frameColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: frameWidth,
      height: frameHeight,
      decoration: BoxDecoration(
        color: frameColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Main screen area
          Positioned(
            top: 15,
            left: 8,
            right: 8,
            bottom: 15,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: child,
            ),
          ),
          // Top speaker/sensor bar
          Positioned(
            top: 5,
            left: frameWidth * 0.25,
            child: Container(
              width: frameWidth * 0.5,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          // Navigation buttons area (traditional Android)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 15,
              decoration: BoxDecoration(
                color: frameColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
