import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'package:mfc/presentation/Customer%20UI/Home/Catagories/Others/OtherItems_screen.dart';
import 'package:mfc/presentation/Customer%20UI/Home/Catagories/Pizza%20Screen/Pizza_screen.dart';
import 'package:mfc/presentation/Customer%20UI/Home/Deals%20Screen/StudentsDeals.dart';
import 'package:mfc/presentation/Customer%20UI/Home/Home_screen.dart';

import 'package:mfc/Helper/cart_provider.dart';
import 'package:mfc/auth/SplashScreen/splashscreen.dart';
import 'package:provider/provider.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
   return ChangeNotifierProvider(create: (_) => CartProvider(),
   child: Builder(builder: (BuildContext context) {
     return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
     
   },),);
  }
}
