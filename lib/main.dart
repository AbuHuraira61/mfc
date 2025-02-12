import 'package:flutter/material.dart';
import 'package:mfc/screens/login.dart';
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
    return const MaterialApp(  // Wrap with MaterialApp
      debugShowCheckedModeBanner: false, // Optional: Hide debug banner
      home: SplashScreen(), // Set LoginScreen as the home screen
    );
  }
}
