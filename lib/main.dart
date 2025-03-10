import 'package:flutter/material.dart';
import 'package:mfc/screens/LoginSignUp.dart';
import 'package:mfc/screens/Sanan/signup_login_page.dart';
import 'package:mfc/screens/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(  // Wrap with MaterialApp
      debugShowCheckedModeBanner: false, // Optional: Hide debug banner
      home: LoginSignUpScreen(), // Set LoginScreen as the home screen
    );
  }
}
