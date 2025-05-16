import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mfc/Constants/colors.dart';
import 'package:mfc/auth/SplashScreen/splashscreen.dart';
import 'package:mfc/presentation/Rider%20UI/Common%20Widgets/accept_order_button.dart';
import 'package:mfc/presentation/Rider%20UI/Common%20Widgets/check_address_button.dart';
import 'package:mfc/presentation/Rider%20UI/Common%20Widgets/mark_as_complete_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mfc/Services/notification_service.dart';
import 'package:mfc/presentation/Rider%20UI/Screens/assigned_orders_screen.dart';
import 'package:mfc/presentation/Rider%20UI/Screens/dispatched_orders_screen.dart';
import 'package:mfc/presentation/Rider%20UI/Screens/completed_orders_screen.dart';
import 'package:mfc/presentation/Rider%20UI/Screens/rider_statistics_screen.dart';

class RiderHome extends StatefulWidget {
  const RiderHome({super.key});

  @override
  State<RiderHome> createState() => _RiderHomeState();
}

class _RiderHomeState extends State<RiderHome> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Rider Dashboard', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SplashScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Statistics Panel
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('AssignedOrders')
                .where('assignedToId', isEqualTo: user?.uid)
                .snapshots(),
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
              int assignedOrders = 0;
              int completedOrders = 0;
              double totalEarnings = 0.0;

              if (snapshot.hasData) {
                for (var doc in snapshot.data!.docs) {
                  var data = doc.data() as Map<String, dynamic>;
                  if (data['status'] == 'Assigned') {
                    assignedOrders++;
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
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildDetailItem(Icons.pending_actions, "Assigned", assignedOrders.toString()),
                        _buildDetailItem(Icons.check_circle, "Completed", completedOrders.toString()),
                        _buildDetailItem(Icons.attach_money, "Earnings", "\$${totalEarnings.toStringAsFixed(2)}"),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),

          // Grid Buttons
          Expanded(
            child: GridView.count(
              padding: EdgeInsets.all(10),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AssignedOrdersScreen()),
                    );
                  },
                  splashColor: Colors.white.withOpacity(0.3),
                  highlightColor: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  child: _buildButton(Icons.assignment, "Assigned Orders"),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DispatchedOrdersScreen()),
                    );
                  },
                  splashColor: Colors.white.withOpacity(0.3),
                  highlightColor: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  child: _buildButton(Icons.delivery_dining, "Dispatched Orders"),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CompletedOrdersScreen()),
                    );
                  },
                  splashColor: Colors.white.withOpacity(0.3),
                  highlightColor: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  child: _buildButton(Icons.check_circle_outline, "Completed Orders"),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RiderStatisticsScreen()),
                    );
                  },
                  splashColor: Colors.white.withOpacity(0.3),
                  highlightColor: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  child: _buildButton(Icons.analytics, "Statistics"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(height: 5),
        Text(title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Text(value, style: TextStyle(color: Colors.white, fontSize: 18)),
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
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      ),
    );
  }

  Future<void> acceptOrder(String orderId) async {
    try {
      // Get order details
      final orderDoc = await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .get();
      
      final userId = orderDoc.data()?['userId'] ?? '';
      
      // Get customer's token
      final customerDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      final customerToken = customerDoc.data()?['deviceToken'] ?? '';

      // Update order status
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({'status': 'Dispatched'});

      // Send notification to customer
      if (customerToken.isNotEmpty) {
        final notificationServices = NotificationServices();
        await notificationServices.sendNotification(
          token: customerToken,
          title: 'Order Update',
          body: 'Your order is on the way!',
          data: {
            'type': 'order',
            'orderId': orderId,
          },
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order accepted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to accept order: $e')),
      );
    }
  }

  Future<void> completeOrder(String orderId) async {
    try {
      // Get order details
      final orderDoc = await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .get();
      
      // Get admin's token
      final adminDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'admin')
          .get();
      final adminToken = adminDoc.docs.isNotEmpty ? adminDoc.docs.first['deviceToken'] ?? '' : '';

      // Update order status
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({'status': 'Complete'});

      // Send notification to admin
      if (adminToken.isNotEmpty) {
        final notificationServices = NotificationServices();
        await notificationServices.sendNotification(
          token: adminToken,
          title: 'Order Completed',
          body: 'Order #${orderId.substring(0, 8)} has been delivered successfully',
          data: {
            'type': 'order',
            'orderId': orderId,
          },
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order completed successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to complete order: $e')),
      );
    }
  }
}




