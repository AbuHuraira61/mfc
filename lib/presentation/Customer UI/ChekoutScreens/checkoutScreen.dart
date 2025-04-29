// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mfc/Constants/colors.dart';
// import 'package:mfc/Helper/cart_provider.dart';
// import 'package:mfc/Helper/db_helper.dart';
// import 'package:mfc/Models/cart_model.dart';
// import 'package:mfc/presentation/Customer%20UI/ChekoutScreens/common/checkoutCustomTextField.dart';
// import 'package:mfc/presentation/Manager%20UI/Feedback/CustomerFeedback.dart';
// import 'package:provider/provider.dart';

// // New imports for location
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:url_launcher/url_launcher.dart';

// class checkoutScreen extends StatefulWidget {
//   final double totalPrice;
//   const checkoutScreen({super.key, required this.totalPrice});

//   @override
//   State<checkoutScreen> createState() => _checkoutScreenState();
// }

// final TextEditingController nameController = TextEditingController();
// final TextEditingController phoneController = TextEditingController();
// final TextEditingController addressController = TextEditingController();

// String? getCurrentUserId() {
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   final User? user = auth.currentUser;
//   if (user != null) {
//     String uid = user.uid;
//     print("Current User ID: $uid");
//     return uid;
//   } else {
//     print("No user is currently signed in.");
//     return null;
//   }
// }

// final _checkoutFormKey = GlobalKey<FormState>();

// class _checkoutScreenState extends State<checkoutScreen> {
//   // Function to get and set current location
//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       Get.snackbar('Location Error', 'Location services are disabled.');
//       return;
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         Get.snackbar('Permission Denied', 'Location permission denied.');
//         return;
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       Get.snackbar(
//           'Permission Denied', 'Location permissions are permanently denied.');
//       return;
//     }

//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     // Optionally open in Google Maps
//     final googleMapUrl =
//         'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';
//     if (await canLaunchUrl(Uri.parse(googleMapUrl))) {
//       await launchUrl(Uri.parse(googleMapUrl));
//     }

//     List<Placemark> placemarks =
//         await placemarkFromCoordinates(position.latitude, position.longitude);
//     if (placemarks.isNotEmpty) {
//       final place = placemarks.first;
//       final address = [
//         place.street,
//         place.subLocality,
//         place.locality,
//         place.postalCode,
//         place.country
//       ].where((s) => s != null && s.isNotEmpty).join(', ');

//       setState(() {
//         addressController.text = address;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Checkout Screen', style: TextStyle(color: Colors.white)),
//           centerTitle: true,
//           backgroundColor: Color(0xff570101),
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back, color: Colors.white),
//             onPressed: () => Navigator.pop(context),
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Form(
//             key: _checkoutFormKey,
//             child: Column(
//               children: [
//                 const SizedBox(height: 30),
//                 // Customer Details Card
//                 Card(
//                   margin: const EdgeInsets.symmetric(horizontal: 12),
//                   color: secondaryColor,
//                   shape: const ContinuousRectangleBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(20)),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 20),
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 20),
//                           child: Row(
//                             children: [
//                               Icon(
//                                 Icons.person,
//                                 color: primaryColor,
//                                 size: 30,
//                               ),
//                               SizedBox(width: 15),
//                               Text(
//                                 'Customer Details',
//                                 style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: primaryColor),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           child: SizedBox(
//                             height: 50,
//                             child: checkoutCustomTextField(
//                               labletext: 'Full Name',
//                               TextController: nameController,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           child: SizedBox(
//                             height: 50,
//                             child: checkoutCustomTextField(
//                               labletext: 'Phone Number',
//                               TextController: phoneController,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           child: SizedBox(
//                             height: 50,
//                             child: checkoutCustomTextField(
//                               labletext: 'Delivery Address',
//                               TextController: addressController,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 // ** Replaced Payment Method with Add Current Location **
//                 Card(
//                   margin: const EdgeInsets.symmetric(horizontal: 12),
//                   color: secondaryColor,
//                   shape: const ContinuousRectangleBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(20)),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.location_on,
//                               color: primaryColor,
//                             ),
//                             SizedBox(width: 10),
//                             Text(
//                               'Add Current Location',
//                               style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: primaryColor),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         Center(
//                           child: ElevatedButton(
//                             onPressed: _getCurrentLocation,
//                             child: Text(
//                               'Use Current Location',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                             style: ElevatedButton.styleFrom(
//                                 backgroundColor: primaryColor,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(5),
//                                 )),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 200),
//                 SizedBox(
//                   width: 270,
//                   height: 45,
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       if (_checkoutFormKey.currentState!.validate()) {
//                         _confirmOrder();
//                       } else {
//                         Get.snackbar('Error', 'Unknown error has occurred!');
//                       }
//                     },
//                     child: Text(
//                       'Confirm Order',
//                       style: TextStyle(color: Colors.white, fontSize: 18),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: primaryColor,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5))),
//                   ),
//                 ),
//                 const Card(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _confirmOrder() async {
//     if (kDebugMode) {
//       print("Name: ${nameController.text}");
//     }
//     if (kDebugMode) {
//       print("Phone: ${phoneController.text}");
//     }
//     if (kDebugMode) {
//       print("Address: ${addressController.text}");
//     }

//     DBHelper dbHelper = DBHelper();
//     List<Cart> cartItems = await dbHelper.getCartList();
//     List<Map<String, dynamic>> itemsList = cartItems.map((item) {
//       return {
//         "id": item.id,
//         "name": item.productName,
//         "image": item.image,
//         "initial_price": item.initialPrice,
//         "product_price": item.productPrice,
//         "quantity": item.quantity,
//       };
//     }).toList();

//     DocumentReference orderRef =
//         FirebaseFirestore.instance.collection("orders").doc();

//     String orderId = orderRef.id;

//     await orderRef.set({
//       "orderId": orderRef.id,
//       "userId": getCurrentUserId(),
//       "name": nameController.text,
//       "phone": phoneController.text,
//       "address": addressController.text,
//       "status": 'pending',
//       "feedback": '',
//       "totalPrice": widget.totalPrice.toString(),
//       "timestamp": Timestamp.now(),
//       "items": itemsList,
//     });

//     for (var item in cartItems) {
//       await dbHelper.delete(item.id.toString());
//     }

//     DocumentReference userRef =
//         FirebaseFirestore.instance.collection("users").doc(getCurrentUserId());
//     await userRef.set({
//       "orderId": FieldValue.arrayUnion([orderRef.id]),
//     }, SetOptions(merge: true));

//     Provider.of<CartProvider>(context, listen: false).clearCartData();
//     Get.snackbar('Success', 'Your order is placed!');


//      // Navigate to the feedback screen and pass the orderId
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => SubmitFeedbackScreen(orderId: orderId),  // Pass the orderId
//     ),
//   );
//     if (kDebugMode) {
//       print("Name: ${nameController.text}");
//     }

//     print("Phone: ${phoneController.text}");
//     if (kDebugMode) {
//       print("Address: ${addressController.text}");
//     }
//   }
// }








import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mfc/Constants/colors.dart';
import 'package:mfc/Helper/cart_provider.dart';
import 'package:mfc/Helper/db_helper.dart';
import 'package:mfc/Models/cart_model.dart';
import 'package:mfc/Services/auth_service.dart';
import 'package:mfc/presentation/Customer%20UI/ChekoutScreens/common/checkoutCustomTextField.dart';
import 'package:provider/provider.dart';

class checkoutScreen extends StatefulWidget {
  final double totalPrice;
  const checkoutScreen({super.key, required this.totalPrice});

  @override
  State<checkoutScreen> createState() => _checkoutScreenState();
}
 
final TextEditingController nameController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController addressController = TextEditingController();
final AuthService _authService = AuthService();


String? getCurrentUserId() {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final User? user = auth.currentUser;

  if (user != null) {
    String uid = user.uid; // This is the user ID
    print("Current User ID: $uid");
    return uid;
  } else {
    print("No user is currently signed in.");
    return null;
  }
}


final _checkoutFormKey = GlobalKey<FormState>();



class _checkoutScreenState extends State<checkoutScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Checkout Screen',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Color(0xff570101),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Form(
            key: _checkoutFormKey,
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                color: secondaryColor,
                shape: const ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Icon(Icons.person),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Customer Details',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primaryColor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: checkoutCustomTextField(labletext: 'Full Name', TextController: nameController),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: checkoutCustomTextField(labletext: 'Phone Number', TextController: phoneController),
                    ),
                    
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child:
                          checkoutCustomTextField(labletext: 'Delivery Address', TextController: addressController,),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                color: secondaryColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.payments_outlined),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Payment Method'),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.payments_outlined),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text('Select Payment Method'),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                              style: ButtonStyle(),
                              onPressed: () {},
                              child: Text('Choose')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: () async {
                if(_checkoutFormKey.currentState!.validate()){
                  _confirmOrder();
                }
                else{
                  Get.snackbar('Error', 'Unknown error has accoured!');
                }
                   
              }, child: Text('Confirm Order')),
              const Card(),
            ],
          ),
        ),
      ),
    );
  }

void _confirmOrder() async {

   print("Name: ${nameController.text}");
  print("Phone: ${phoneController.text}");
  print("Address: ${addressController.text}");
  DBHelper dbHelper = DBHelper();
    List<Cart> cartItems = await dbHelper.getCartList();
     List<Map<String, dynamic>> itemsList = cartItems.map((item) {
      return {
        "id": item.id,
        "name": item.productName,
       "image": item.image,
       "initial_price": item.initialPrice,
       "product_price": item.productPrice,
       "quantity": item.quantity,
      };
     },).toList();


        // Create a unique document ID (auto-generated)
    DocumentReference orderRef = FirebaseFirestore.instance.collection("orders").doc();

    await orderRef.set({
      "orderId" : orderRef.id,
      "userId": getCurrentUserId(),
      "name": nameController.text,
      "phone": phoneController.text,
      "address": addressController.text,
      "status": 'pending',
      "feedback": '',
      "totalPrice": widget.totalPrice.toString(),
      "timestamp": Timestamp.now(),
      "items": itemsList,
    });
   
   // Optionally clear the cart
    for (var item in cartItems) {
      await dbHelper.delete(item.id.toString());

     
    }


   
   DocumentReference userRef = FirebaseFirestore.instance.collection("users").doc(getCurrentUserId());
   
   await userRef.set({
    "orderId": FieldValue.arrayUnion([orderRef.id]),
       }, SetOptions(merge: true));

    Provider.of<CartProvider>(context, listen: false).clearCartData();

    Get.snackbar('Success', 'Your order is placed!');
    print("Name: ${nameController.text}");
print("Phone: ${phoneController.text}");
print("Address: ${addressController.text}");

}



}


