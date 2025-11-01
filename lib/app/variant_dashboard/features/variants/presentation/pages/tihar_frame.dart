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
        child: TiharMobileFrame(
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

class TiharMobileFrame extends StatefulWidget {
  final Widget child;
  final double frameWidth;
  final double frameHeight;
  final Color frameColor;
  final double cornerRadius;
  final bool enableAnimation;

  const TiharMobileFrame({
    super.key,
    required this.child,
    this.frameWidth = 300,
    this.frameHeight = 600,
    this.frameColor = Colors.black,
    this.cornerRadius = 35,
    this.enableAnimation = true,
  });

  @override
  State<TiharMobileFrame> createState() => _TiharMobileFrameState();
}

class _TiharMobileFrameState extends State<TiharMobileFrame>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // Glow animation for border colors
    _glowController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    if (widget.enableAnimation) {
      _glowController.repeat();
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  List<Color> _getGlowColors(double animationValue) {
    // Cycle through a beautiful color palette
    final colors = [
      [Colors.blue.shade400, Colors.purple.shade400],
      [Colors.purple.shade400, Colors.pink.shade400],
      [Colors.pink.shade400, Colors.orange.shade400],
      [Colors.orange.shade400, Colors.amber.shade400],
      [Colors.amber.shade400, Colors.green.shade400],
      [Colors.green.shade400, Colors.teal.shade400],
      [Colors.teal.shade400, Colors.blue.shade400],
    ];

    final index = (animationValue * colors.length) % colors.length;
    final currentIndex = index.floor();
    final nextIndex = (currentIndex + 1) % colors.length;
    final t = index - currentIndex;

    return [
      Color.lerp(colors[currentIndex][0], colors[nextIndex][0], t)!,
      Color.lerp(colors[currentIndex][1], colors[nextIndex][1], t)!,
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enableAnimation) {
      return _buildStaticFrame();
    }

    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        final glowColors = _getGlowColors(_glowAnimation.value);

        return Container(
          width: widget.frameWidth + 3,
          height: widget.frameHeight + 3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.cornerRadius + 1.5),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: glowColors,
            ),
            boxShadow: [
              BoxShadow(
                color: glowColors[0].withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 2,
                offset: Offset(-2, -2),
              ),
              BoxShadow(
                color: glowColors[1].withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 2,
                offset: Offset(2, 2),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 30,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(1.5),
            child: _buildPhoneFrame(),
          ),
        );
      },
    );
  }

  Widget _buildStaticFrame() {
    return Container(
      width: widget.frameWidth,
      height: widget.frameHeight,
      decoration: BoxDecoration(
        color: widget.frameColor,
        borderRadius: BorderRadius.circular(widget.cornerRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: _buildPhoneContent(),
    );
  }

  Widget _buildPhoneFrame() {
    final glowColors = _getGlowColors(_glowAnimation.value);
    final frameColor = widget.enableAnimation
        ? Color.lerp(glowColors[0], glowColors[1], 0.5)!.withOpacity(0.9)
        : widget.frameColor;

    return Container(
      width: widget.frameWidth,
      height: widget.frameHeight,
      decoration: BoxDecoration(
        color: frameColor,
        borderRadius: BorderRadius.circular(widget.cornerRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: _buildPhoneContent(),
    );
  }

  Widget _buildPhoneContent() {
    return Stack(
      children: [
        // Main screen area
        Positioned(
          top: 8,
          left: 8,
          right: 8,
          bottom: 8,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.cornerRadius - 8),
            child: widget.child,
          ),
        ),
        // Notch
        Positioned(
          top: 0,
          left: widget.frameWidth * 0.3,
          child: Container(
            width: widget.frameWidth * 0.4,
            height: 30,
            decoration: BoxDecoration(
              color: widget.frameColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
          ),
        ),
        // Speaker with subtle glow
        Positioned(
          top: 8,
          left: widget.frameWidth * 0.35,
          child: Container(
            width: widget.frameWidth * 0.3,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(3),
              boxShadow: widget.enableAnimation
                  ? [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.1),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
          ),
        ),
        // Front camera with glow
        Positioned(
          top: 6,
          right: widget.frameWidth * 0.35,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(6),
              boxShadow: widget.enableAnimation
                  ? [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.2),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
          ),
        ),
        // Home indicator with enhanced glow
        Positioned(
          bottom: 8,
          left: widget.frameWidth * 0.4,
          child: Container(
            width: widget.frameWidth * 0.2,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
              boxShadow: widget.enableAnimation
                  ? [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}

// Enhanced Android-style frame with animation
class AndroidMobileFrame extends StatefulWidget {
  final Widget child;
  final double frameWidth;
  final double frameHeight;
  final Color frameColor;
  final bool enableAnimation;

  const AndroidMobileFrame({
    super.key,
    required this.child,
    this.frameWidth = 300,
    this.frameHeight = 600,
    this.frameColor = Colors.black,
    this.enableAnimation = true,
  });

  @override
  State<AndroidMobileFrame> createState() => _AndroidMobileFrameState();
}

class _AndroidMobileFrameState extends State<AndroidMobileFrame>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    if (widget.enableAnimation) {
      _animationController.repeat();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enableAnimation) {
      return _buildStaticFrame();
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final glowColor = HSVColor.fromAHSV(
          1.0,
          _animation.value * 360,
          0.6,
          0.8,
        ).toColor();

        return Container(
          width: widget.frameWidth + 6,
          height: widget.frameHeight + 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: RadialGradient(
              colors: [
                glowColor.withOpacity(0.3),
                glowColor.withOpacity(0.1),
                Colors.transparent,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: glowColor.withOpacity(0.4),
                blurRadius: 15,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Center(child: _buildPhoneFrame()),
        );
      },
    );
  }

  Widget _buildStaticFrame() {
    return _buildPhoneFrame();
  }

  Widget _buildPhoneFrame() {
    return Container(
      width: widget.frameWidth,
      height: widget.frameHeight,
      decoration: BoxDecoration(
        color: widget.frameColor,
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
              child: widget.child,
            ),
          ),
          // Top speaker/sensor bar
          Positioned(
            top: 5,
            left: widget.frameWidth * 0.25,
            child: Container(
              width: widget.frameWidth * 0.5,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          // Navigation buttons area
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 15,
              decoration: BoxDecoration(
                color: widget.frameColor,
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
