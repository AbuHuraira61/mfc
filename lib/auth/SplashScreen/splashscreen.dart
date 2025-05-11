import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:mfc/Constants/colors.dart';
import 'package:mfc/Services/notification_service.dart';
import 'package:mfc/auth/LoginSignUpScreen/Commons/LoginScreen.dart';
import 'package:mfc/auth/LoginSignUpScreen/Commons/SignUpScreen.dart';
import 'package:mfc/auth/SplashScreen/CustomElevatedButton.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    NotificationService().requestNotificarionPermission();
  }

  // Future<void> _checkUserStatus() async {

  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     String role = await _getUserRole(user.uid);
  //     _navigateTo(role);
  //   } else {
  //     _navigateTo(null);
  //   }
  // }

  // Future<String> _getUserRole(String uid) async {
  //   final userDoc =
  //       await FirebaseFirestore.instance.collection("users").doc(uid).get();
  //   return userDoc.exists ? userDoc["role"] : "customer";
  // }

  // void _navigateTo(String? role) {
  //   Widget nextScreen;
  //   if (role == "admin") {
  //     nextScreen = ManagerHomeScreen();
  //   } else if (role == "customer") {
  //     nextScreen = HomeScreen();
  //   } else {
  //     nextScreen = LoginSignUpScreen();
  //   }

  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => nextScreen),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: Get.height * 1,
            width: Get.width * 1,
            color: secondaryColor,
          ),
          Transform.translate(
            offset: Offset(0, -40),
            child: Center(
              child: Image(image: AssetImage('assets/logo.png')),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomelEvatedButton(
                  onPressed: () {}, buttonName: 'Login with Google'),
              SizedBox(
                height: 10,
              ),
              CustomelEvatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(),
                        ));
                  },
                  buttonName: 'Create a new account'),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                      'Already have an account?'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ));
                    },
                    child: Text(
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 17),
                        'Login'),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
