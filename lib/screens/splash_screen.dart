import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart'; // Import for HapticFeedback

import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 4)); // Make splash a bit longer
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => HomeScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => LoginScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Light theme background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_IntenseAnimatedLogo(), SizedBox(height: 20)],
        ),
      ),
    );
  }
}

class _IntenseAnimatedLogo extends StatefulWidget {
  @override
  State<_IntenseAnimatedLogo> createState() => _IntenseAnimatedLogoState();
}

class _IntenseAnimatedLogoState extends State<_IntenseAnimatedLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Predefined shake patterns for more stable movement
  final List<Offset> _shakePattern = [
    Offset(0, 0),
    Offset(40, -40), // diagonal right-up
    Offset(-40, -40), // diagonal left-up
    Offset(40, 40), // diagonal right-down
    Offset(-40, 40), // diagonal left-down
    Offset(0, 0), // center
  ];

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 2000))
          ..addListener(() async {
            // Vibrate at pattern transitions
            if (_controller.value > 0.2 && _controller.value < 0.22 ||
                _controller.value > 0.4 && _controller.value < 0.42 ||
                _controller.value > 0.6 && _controller.value < 0.62 ||
                _controller.value > 0.8 && _controller.value < 0.82 ||
                _controller.value == 1) {
              try {
                await HapticFeedback.heavyImpact();
              } catch (_) {}
            }
          })
          ..forward(); // Just forward once, no repetition
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Offset _getShakeOffset(double progress) {
    final pointCount = _shakePattern.length - 1;
    final segment = (progress * pointCount).floor();
    final segmentProgress = (progress * pointCount) - segment;

    if (segment >= pointCount) return _shakePattern.last;

    // Smooth interpolation between pattern points
    return Offset.lerp(
          _shakePattern[segment],
          _shakePattern[segment + 1],
          segmentProgress,
        ) ??
        Offset.zero;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final offset = _getShakeOffset(_controller.value);
        return Transform.translate(
          offset: offset,
          child: Image.asset('assets/lexichat.png', width: 200, height: 200),
        );
      },
    );
  }
}
