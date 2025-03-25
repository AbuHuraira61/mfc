import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:mfc/presentation/Customer%20UI/screens/Sanan/BurgerScreen.dart';
import 'package:mfc/presentation/Customer%20UI/screens/Sanan/FavouritePage.dart';
import 'package:mfc/presentation/Customer%20UI/screens/Sanan/OrderConfirmationScreen.dart';
import 'package:mfc/presentation/Customer%20UI/screens/Sanan/OrderTypeScreen.dart';
import 'package:mfc/presentation/Customer%20UI/screens/Sanan/PizzaScreen.dart';
import 'package:mfc/presentation/Customer%20UI/screens/Sanan/splashscreen.dart';
import 'package:mfc/presentation/Manager%20UI/AllAddedItemScreen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: AllAddedItemScreen(),
    );

  }
}
