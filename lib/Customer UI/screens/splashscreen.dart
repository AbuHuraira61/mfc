import 'package:flutter/material.dart';
import 'package:mfc/Customer%20UI/screens/Sanan/choicescreen.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(
        const Duration(seconds: 5),
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OrderScreen()),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFF570101),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform(
                    transform:
                        Matrix4.rotationY(_controller.value * 2 * 3.1416),
                    alignment: Alignment.center,
                    child: child,
                  );
                },
                child: FadeTransition(
                  opacity: _fadeInAnimation,
                  child: SizedBox(
                    width: screenWidth * 0.5,
                    height: screenHeight * 0.3,
                    child: const Image(
                      image: AssetImage("assets/splash-screen.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // SizedBox(height: screenHeight * 0.05),
              // const Text(
              //   'MFC',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     fontWeight: FontWeight.bold,
              //     fontSize: 60,
              //     color: Colors.yellow,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
