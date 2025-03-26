import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mfc/presentation/Customer%20UI/screens/Home_screen,.dart';
import 'dart:async';
import 'package:mfc/presentation/Manager%20UI/Home%20Screen/ManagerHomeScreen.dart';
import 'package:mfc/auth/LoginSignUpScreen/LoginSignUpScreen.dart';

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

    // Check user authentication status and role
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    await Future.delayed(
        const Duration(seconds: 3)); // Show splash for 3 seconds

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String role = await _getUserRole(user.uid);
      _navigateTo(role);
    } else {
      _navigateTo(null);
    }
  }

  Future<String> _getUserRole(String uid) async {
    final userDoc =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    return userDoc.exists ? userDoc["role"] : "customer";
  }

  void _navigateTo(String? role) {
    Widget nextScreen;
    if (role == "admin") {
      nextScreen = ManagerHomeScreen();
    } else if (role == "customer") {
      nextScreen = HomeScreen();
    } else {
      nextScreen = LoginSignUpScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
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
      backgroundColor: const Color(0xFF570101),
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
                    height: screenHeight * 0.4,
                    child: const Image(
                      image: AssetImage("assets/splash-screen.png"),
                      fit: BoxFit.cover,
                    ),
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
