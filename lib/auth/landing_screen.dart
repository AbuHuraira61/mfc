import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mfc/presentation/Customer UI/Home/Home_screen.dart';
import 'package:mfc/presentation/Manager UI/Home Screen/ManagerHomeScreen.dart';
import 'package:mfc/auth/SplashScreen/splashscreen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String role = await _getUserRole(user.uid);
      if (role == "admin") {
        _goToScreen(const ManagerHomeScreen());
      } else {
        _goToScreen(const HomeScreen());
      }
    } else {
      _goToScreen(const SplashScreen());
    }
  }

  Future<String> _getUserRole(String uid) async {
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      if (userDoc.exists && userDoc.data()!.containsKey("role")) {
        return userDoc["role"];
      } else {
        return "customer"; // default role if not found
      }
    } catch (e) {
      print("Error getting role: $e");
      return "customer";
    }
  }

  void _goToScreen(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
