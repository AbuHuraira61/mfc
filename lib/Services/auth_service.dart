import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mfc/Constants/custom_snackbar.dart';
import 'package:mfc/presentation/Customer%20UI/Home/Home_screen.dart';
import 'package:mfc/presentation/Manager%20UI/Home%20Screen/ManagerHomeScreen.dart';
import 'package:mfc/presentation/Rider%20UI/rider_home.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signUpUser(
      String email, String password, String name, BuildContext context) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Determine role based on email or password
      String role = (email == "admin@example.com" || password == "Admin@123")
          ? "admin"
          : "customer";

      // Save user data in Firestore
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        "email": email,
        "role": role,
        "name":name,
      });

      // Navigate to the correct screen
      if (context.mounted) {
        // ✅ Safe check before using context
        _navigateUser(role, context);
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> loginUser(String email, String password, BuildContext context) async {
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    CustomSnackbar().showSnackbar('Success!', 'Login successful!');

    DocumentSnapshot userDoc = await _firestore
        .collection("users")
        .doc(userCredential.user!.uid)
        .get();

    if (userDoc.exists) {
      String role = userDoc["role"];
      if (context.mounted) {
        _navigateUser(role, context);
      }
    }
  } on FirebaseAuthException catch (e) {
    CustomSnackbar().showSnackbar('Error', 'Login failed: ${e.message}');
  } catch (e) {
    print("Error: $e");
    CustomSnackbar().showSnackbar('Error', 'Unexpected error occurred.');
  }
}


  // Future<void> loginUser(String email, String password, BuildContext context) async {
  //   try {
  //     Null userCredential = await _auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     ).then((value) async {
  //       CustomSnackbar().showSnackbar('Success!', 'Login successful!');
  //       DocumentSnapshot userDoc = await _firestore
  //         .collection("users")
  //         .doc(userCredential.user!.uid)
  //         .get();

  //     if (userDoc.exists) {
  //       String role = userDoc["role"];
  //       if (context.mounted) {
  //         // ✅ Safe check before using context
  //         _navigateUser(role, context);
  //       }
  //     }
  //     },).onError((error, stackTrace) {
  //       CustomSnackbar().showSnackbar('Error', 'Login failed: $error');
        
  //     },);

      
  //   } catch (e) {
  //     print("Error: $e");
  //   }
  // }

  void _navigateUser(String role, BuildContext context) {
    switch (role){
      case 'admin':
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  ManagerHomeScreen(),));
      case 'customer':
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  HomeScreen(),));
      case 'rider':
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  RiderHome(),));       
    }
  }
}



//  // Convert image to binary (base64 encoding)
//         String photoBase64 = '';

//         if (_selectedImage != null) {
//           // Convert selected image to base64
//           final bytes = await _selectedImage!.readAsBytes();
//           photoBase64 = base64Encode(bytes);
//         } else {
//           // Load default image from assets and convert it to base64
//           final ByteData assetImageData = await rootBundle.load('assets/user_profile.jpg');
//           final bytes = assetImageData.buffer.asUint8List();
//           photoBase64 = base64Encode(bytes);
          
//         }


// For decofing

// backgroundImage: MemoryImage(base64Decode(image get from firestore)),