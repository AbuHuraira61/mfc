// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mfc/Constants/colors.dart';
import 'package:mfc/auth/SplashScreen/splashscreen.dart';
import 'package:mfc/presentation/Manager%20UI/AddItemsScreen/AddItem_screen.dart';
import 'package:mfc/presentation/Manager%20UI/AddNewRider/AddNewRider_screen.dart';
import 'package:mfc/presentation/Manager%20UI/All%20Items/AllAddedItemScreen.dart';
import 'package:mfc/presentation/Manager%20UI/Feedback/Feedback_screen.dart';
import 'package:mfc/presentation/Manager%20UI/Manage%20Deals/AddDeals_screen.dart';
import 'package:mfc/presentation/Manager%20UI/Orders/orders_status_screen.dart';
import 'package:mfc/presentation/Manager UI/Statistics/StatisticsScreen.dart';
import 'package:mfc/presentation/Manager%20UI/Rider%20Profile%20Management/RiderProfileManagementScreen.dart';

class ManagerHomeScreen extends StatefulWidget {
  const ManagerHomeScreen({super.key});

  @override
  State<ManagerHomeScreen> createState() => _ManagerHomeScreenState();
}

class _ManagerHomeScreenState extends State<ManagerHomeScreen> {
  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    if (context.mounted) {
      // ✅ Ensure context is still valid
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SplashScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'MFC Admin Panel',
          style: TextStyle(color: secondaryColor),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          // Details Panel
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('orders').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Error loading data',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }

              // Calculate statistics
              int pendingOrders = 0;
              int completedOrders = 0;
              double totalEarnings = 0.0;

              if (snapshot.hasData) {
                for (var doc in snapshot.data!.docs) {
                  var data = doc.data() as Map<String, dynamic>;
                  if (data['status'] == 'pending') {
                    pendingOrders++;
                  } else if (data['status'] == 'Complete') {
                    completedOrders++;
                    if (data['totalPrice'] != null) {
                      totalEarnings += double.parse(data['totalPrice'].toString());
                    }
                  }
                }
              }

              return Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StatisticsScreen()),
                    );
                  },
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildDetailItem(Icons.info, "Pending", pendingOrders.toString()),
                          _buildDetailItem(Icons.check_box, "Completed", completedOrders.toString()),
                          _buildDetailItem(Icons.attach_money, "Earning", "\Rs.${totalEarnings.toStringAsFixed(2)}"),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Buttons Panel
          Expanded(
            child: GridView.count(
              padding: EdgeInsets.all(10),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return AddItemScreen();
                        },
                      ));
                    },
                    splashColor: Colors.white.withOpacity(0.3),
                    highlightColor: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    child: _buildButton(Icons.add, "Add Menu")),
                InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllAddedItemScreen()),
                      );
                    },
                    splashColor: Colors.white.withOpacity(0.3),
                    highlightColor: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    child: _buildButton(Icons.menu_book, "All Item Menu")),
                InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddDealsScreen()),
                      );
                    },
                    splashColor: Colors.white.withOpacity(0.3),
                    highlightColor: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    child: _buildButton(Icons.discount_sharp, "Manage Deals")),
                InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddNewRiderScreen()),
                      );
                    },
                    splashColor: Colors.white.withOpacity(0.3),
                    highlightColor: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    child: _buildButton(Icons.person_add, "Add New Rider")),
                InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PendingOrderScreen()),
                      );
                    },
                    splashColor: Colors.white.withOpacity(0.3),
                    highlightColor: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    child: _buildButton(Icons.local_shipping, "Order Status")),
                InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FeedbackScreen()),
                      );
                    },
                    splashColor: Colors.white.withOpacity(0.3),
                    highlightColor: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    child: _buildButton(Icons.feedback_outlined, "Feedback")),
                InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RiderProfileManagementScreen()),
                      );
                    },
                    splashColor: Colors.white.withOpacity(0.3),
                    highlightColor: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    child: _buildButton(Icons.manage_accounts, "Profile Management")),
                InkWell(
                    onTap: () {
                      _logout(context);
                    },
                    splashColor: Colors.white.withOpacity(0.3),
                    highlightColor: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    child: _buildButton(Icons.logout, "Log Out")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildDetailItem(IconData icon, String title, String value) {
  return Column(
    children: [
      Icon(icon, color: Colors.white),
      SizedBox(height: 5),
      Text(title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      Text(value, style: TextStyle(color: Colors.white, fontSize: 14)),
    ],
  );
}

Widget _buildButton(IconData icon, String label) {
  return Ink(
    decoration: BoxDecoration(
      color: Color(0xffEFEEEA),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 40, color: Colors.black87),
        SizedBox(height: 10),
        Text(label,
            textAlign: TextAlign.center,
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
      ],
    ),
  );
}
