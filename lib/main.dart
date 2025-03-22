import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mfc/Customer%20UI/screens/home_screen.dart';
import 'package:mfc/Manager%20UI/Home%20Screen/ManagerHomeScreen.dart';
// import 'package:mfc/Manager%20UI/AddItem_screen.dart';
import 'package:mfc/auth/LoginSignUpScreen/LoginSignUpScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Loading state
          }
          if (snapshot.hasData) {
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection("users").doc(snapshot.data!.uid).get(),
              builder: (context, roleSnapshot) {
                if (roleSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (roleSnapshot.hasData && roleSnapshot.data!.exists) {
                  String role = roleSnapshot.data!["role"];
                  return role == "admin" ? ManagerHommeScreen() : HomeScreen();
                }
                return LoginSignUpScreen();
              },
            );
          }
          return LoginSignUpScreen();
        },
      ),
    );
  }
}

