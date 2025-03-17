import 'package:flutter/material.dart';
import 'package:mfc/Constants/colors.dart';
import 'package:mfc/Customer%20UI/screens/splashscreen.dart';
<<<<<<< HEAD
import 'package:firebase_core/firebase_core.dart';
=======
import 'package:mfc/Manager%20UI/Home%20Screen/ManagerHomeScreen.dart';
>>>>>>> ca95b3caad24ddba5edbcdd3cb7aee6d7c65a019

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static MaterialColor generateMaterialColorFromColor(Color color) {
    return MaterialColor(color.a as int, {
      50: Color.fromRGBO(color.r as int, color.g as int, color.b as int, 0.1),
      100: Color.fromRGBO(color.r as int, color.g as int, color.b as int, 0.2),
      200: Color.fromRGBO(color.r as int, color.g as int, color.b as int, 0.3),
      300: Color.fromRGBO(color.r as int, color.g as int, color.b as int, 0.4),
      400: Color.fromRGBO(color.r as int, color.g as int, color.b as int, 0.5),
      500: Color.fromRGBO(color.r as int, color.g as int, color.b as int, 0.6),
      600: Color.fromRGBO(color.r as int, color.g as int, color.b as int, 0.7),
      700: Color.fromRGBO(color.r as int, color.g as int, color.b as int, 0.8),
      800: Color.fromRGBO(color.r as int, color.g as int, color.b as int, 0.9),
      900: Color.fromRGBO(color.r as int, color.g as int, color.b as int, 1.0),
    });
  }
 
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Wrap with MaterialApp
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: secondaryColor,
          appBarTheme: AppBarTheme(
            backgroundColor: primaryColor,
          ),
          iconTheme: IconThemeData(
              color: primaryColor)), // Optional: Hide debug banner
      home: ManagerHommeScreen(), // Set LoginScreen as the home screen
    );
  }
}
