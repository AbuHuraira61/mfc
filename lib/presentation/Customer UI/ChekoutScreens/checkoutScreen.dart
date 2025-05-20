import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mfc/Constants/colors.dart';
import 'package:mfc/Helper/cart_provider.dart';
import 'package:mfc/Helper/db_helper.dart';
import 'package:mfc/Models/cart_model.dart';
import 'package:mfc/Services/notification_service.dart';
import 'package:mfc/presentation/Customer%20UI/ChekoutScreens/common/checkoutCustomTextField.dart';
import 'package:mfc/presentation/Customer%20UI/Home/Home_screen.dart';
import 'package:provider/provider.dart';

// New imports for location
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';

class checkoutScreen extends StatefulWidget {
  final double totalPrice;
  const checkoutScreen({super.key, required this.totalPrice});

  @override
  State<checkoutScreen> createState() => _checkoutScreenState();
}
bool _isprocessing = false;
final TextEditingController nameController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController addressController = TextEditingController();

String? getCurrentUserId() {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  if (user != null) {
    String uid = user.uid;
    print("Current User ID: $uid");
    return uid;
  } else {
    print("No user is currently signed in.");
    return null;
  }
}

final _checkoutFormKey = GlobalKey<FormState>();

class _checkoutScreenState extends State<checkoutScreen> {
  bool _isGettingLocation = false;

  // Function to get and set current location
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar('Location Error', 'Location services are disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Permission Denied', 'Location permission denied.');
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
            'Permission Denied', 'Location permissions are permanently denied.');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Optionally open in Google Maps

    final googleMapUrl = Uri.parse(
  'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}',
);

if (await canLaunchUrl(googleMapUrl)) {
  await launchUrl(
    googleMapUrl,
    mode: LaunchMode.externalApplication,
  );
}



      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final address = [
          place.street,
          place.subLocality,
          place.locality,
          place.postalCode,
          place.country
        ].where((s) => s != null && s.isNotEmpty).join(', ');

        setState(() {
          addressController.text = address;
        });
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to get location: $e');
    } finally {
      setState(() {
        _isGettingLocation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Checkout Screen', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Color(0xff570101),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _checkoutFormKey,
            child: Column(
              children: [
                const SizedBox(height: 30),
                // Customer Details Card
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  color: secondaryColor,
                  shape: const ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: primaryColor,
                                size: 30,
                              ),
                              SizedBox(width: 15),
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
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SizedBox(
                            height: 50,
                            child: checkoutCustomTextField(
                              validatorText: 'Please enter your name',
                              labletext: 'Full Name',
                              TextController: nameController,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SizedBox(
                            height: 50,
                            child: checkoutCustomTextField(
                              validatorText: 'Please enter your phone number',
                              labletext: 'Phone Number',
                              TextController: phoneController,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SizedBox(
                            height: 50,
                            child: checkoutCustomTextField(
                              validatorText: 'Please enter your address',
                              labletext: 'Delivery Address',
                              TextController: addressController,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // ** Replaced Payment Method with Add Current Location **
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  color: secondaryColor,
                  shape: const ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: primaryColor,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Add Current Location',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: ElevatedButton(
                            onPressed: _isGettingLocation ? null : _getCurrentLocation,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                minimumSize: Size(double.infinity, 50),
                            ),
                            child: _isGettingLocation
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Getting Location...',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  )
                                : Text(
                                    'Use Current Location',
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 200),
                SizedBox(
                  width: 270,
                  height: 45,
                  child:  ElevatedButton(
                    onPressed: _isprocessing ? null : () async {
                      if (_checkoutFormKey.currentState!.validate()) {
                        setState(() {
                          _isprocessing = true;
                        });
                        _confirmOrder();
                       
                        
                      } 
                      // else {
                      //   Get.snackbar('Error', 'Unknown error has occurred!');
                      //   setState(() {
                      //     _isprocessing = false;
                      //   });
                      // }
                    },
                    child: _isprocessing ?  const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ) : Text(
                      'Confirm Order',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                ),
                const Card(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmOrder() async {
    if (kDebugMode) {
      print("Name: ${nameController.text}");
    }
    if (kDebugMode) {
      print("Phone: ${phoneController.text}");
    }
    if (kDebugMode) {
      print("Address: ${addressController.text}");
    }

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
    }).toList();

    DocumentReference orderRef =
        FirebaseFirestore.instance.collection("orders").doc();

    String orderId = orderRef.id;

    await orderRef.set({
      "orderId": orderRef.id,
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

    // Send notification to admin
    final adminDoc = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'admin')
        .get();
    final adminToken = adminDoc.docs.isNotEmpty ? adminDoc.docs.first['deviceToken'] ?? '' : '';

    if (adminToken.isNotEmpty) {
      final notificationServices = NotificationServices();
      await notificationServices.sendNotification(
        token: adminToken,
        title: 'New Order Placed',
        body: 'A new order has been placed by ${nameController.text}',
        data: {
          'type': 'order',
          'orderId': orderRef.id,
        },
      );
    }

    for (var item in cartItems) {
      await dbHelper.delete(item.id.toString());
    }

    DocumentReference userRef =
        FirebaseFirestore.instance.collection("users").doc(getCurrentUserId());
    await userRef.set({
      "orderId": FieldValue.arrayUnion([orderRef.id]),
    }, SetOptions(merge: true));

    Provider.of<CartProvider>(context, listen: false).clearCartData();
    Get.snackbar('Success', 'Your order is placed!');


     // Navigate to the feedback screen and pass the orderId
     Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => HomeScreen(),  // Pass the orderId
    ),

    
  );
  _isprocessing = false;
  nameController.clear();
  phoneController.clear();
  addressController.clear();
    if (kDebugMode) {
      print("Name: ${nameController.text}");
    }

    print("Phone: ${phoneController.text}");
    if (kDebugMode) {
      print("Address: ${addressController.text}");
    }
  }
}





