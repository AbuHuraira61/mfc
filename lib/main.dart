import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:mfc/Constants/colors.dart';
import 'package:mfc/Helper/cart_provider.dart';
import 'package:mfc/Helper/order_status_provider.dart';
import 'package:mfc/Services/notification_service.dart';
import 'package:mfc/auth/SplashScreen/splashscreen.dart';
import 'package:mfc/presentation/Customer UI/Home/Home_screen.dart';
import 'package:mfc/presentation/Manager UI/Home Screen/ManagerHomeScreen.dart';
import 'package:mfc/presentation/Rider%20UI/rider_home.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  runApp(const MyApp());
}

// Determine initial screen logic
Future<Widget> determineInitialScreen() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return const SplashScreen(); // Not logged in
  }

  final userDoc =
      await FirebaseFirestore.instance.collection("users").doc(user.uid).get();

  if (userDoc.exists) {
    final role = userDoc['role'] ?? 'customer';
    switch (role) {
      case 'admin':
        return const ManagerHomeScreen();
      case 'customer':
        return const HomeScreen();
      case 'rider':
        return const RiderHome();
      default:
        return const SplashScreen();
    }
  } else {
    return const HomeScreen(); // Fallback in case role is missing
  }
}

// Main App
class MyApp extends StatelessWidget {
  
  const MyApp({super.key,});

  @override
  Widget build(BuildContext context) {
      // Initialize notifications
    final notificationServices = NotificationServices();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CartProvider()),
          // Add other providers here if needed
          ChangeNotifierProvider(create: (_) => OrderStatusProvider()),
        ],
        child: GetMaterialApp(
          theme: ThemeData(
            fontFamily: 'Poppins', // Default font family set to Poppins
            textTheme: TextTheme(
              displayLarge: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold, // Bold for headings
                fontSize: 32, // Adjust size as per requirement
              ),
              displayMedium: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500, // Medium for subheadings
                fontSize: 24, // Adjust size as per requirement
              ),
              bodyLarge: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.normal, // Regular font for normal text
                fontSize: 16, // Adjust size as per requirement
              ),
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: FutureBuilder<Widget>(
          future: determineInitialScreen(),
          builder: (context, snapshot) {
            // **1. Still loading?** show just your logo:
            if (snapshot.connectionState != ConnectionState.done) {
              return Scaffold(
                backgroundColor: secondaryColor,
                body: Center(
                  child: Image.asset('assets/logo.png'),
                ),
              );
            }
            // **2. Done?** show whatever screen we resolved to:
            return snapshot.data!;
          },
        ),
        ));
  }
}
