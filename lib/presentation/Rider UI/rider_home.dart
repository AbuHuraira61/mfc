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

class RiderHome extends StatefulWidget {
  const RiderHome({super.key});

  @override
  State<RiderHome> createState() => _RiderHomeState();
}

class _RiderHomeState extends State<RiderHome> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              )),
          backgroundColor: primaryColor,
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert,
                  color: Colors.white), // White 3-dots icon
              onSelected: (value) async {
                if (value == 'Logout') {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SplashScreen()),
                      (route) => false,
                    );
                  }
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'Logout',
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text('Logout'),
                  ),
                ),
              ],
            ),
          ],
          title: Center(
            child: Text(
              'Rider Home',
              style: TextStyle(color: Colors.white),
            ),
          ),
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Assigned'),
              Tab(text: 'Dispatched'),
              Tab(text: 'Complete'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Dispatched Orders Tab
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('AssignedOrders')
                  .where('assignedToId', isEqualTo: user?.uid)
                  .where('status', isEqualTo: 'Assigned')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final dispatchedOrders = snapshot.data?.docs ?? [];

                if (dispatchedOrders.isEmpty) {
                  return Center(child: Text("No assigned orders."));
                }

                return ListView.builder(
                  itemCount: dispatchedOrders.length,
                  itemBuilder: (context, index) {
                    final data =
                        dispatchedOrders[index].data() as Map<String, dynamic>;
                    final orderId = dispatchedOrders[index].id;

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('orders')
                          .doc(orderId)
                          .get(),
                      builder: (context, orderSnapshot) {
                        if (!orderSnapshot.hasData) {
                          return Padding(
                            padding: EdgeInsets.all(16),
                            child: LinearProgressIndicator(),
                          );
                        }

                        final orderData =
                            orderSnapshot.data?.data() as Map<String, dynamic>?;
                        final customerName = data['customerName'] ?? 'Unknown';
                        final address =
                            orderData?['address'] ?? 'No address found';
                        final phone =
                            orderData?['phone'] ?? 'No Contact Number';
                        final amount = orderData?['totalPrice'] ?? '';

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Card(
                            color: primaryColor,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.person,
                                          color: primaryColor),
                                    ),
                                    title: Text(
                                      customerName,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on,
                                          color: Colors.white),
                                      SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          address,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(Icons.money, color: Colors.white),
                                      SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          amount,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(Icons.phone, color: Colors.white),
                                      SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          phone,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    children: [
                                      CheckAdressButton(address: address),
                                      SizedBox(width: 12),
                                      AcceptOrderButton(orderId: orderId),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('AssignedOrders')
                  .where('assignedToId', isEqualTo: user?.uid)
                  .where('status', isEqualTo: 'Dispatched')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final dispatchedOrders = snapshot.data?.docs ?? [];

                if (dispatchedOrders.isEmpty) {
                  return Center(child: Text("No completed orders."));
                }

                return ListView.builder(
                  itemCount: dispatchedOrders.length,
                  itemBuilder: (context, index) {
                    final data =
                        dispatchedOrders[index].data() as Map<String, dynamic>;
                    final orderId = dispatchedOrders[index].id;

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('orders')
                          .doc(orderId)
                          .get(),
                      builder: (context, orderSnapshot) {
                        if (!orderSnapshot.hasData) {
                          return Padding(
                            padding: EdgeInsets.all(16),
                            child: LinearProgressIndicator(),
                          );
                        }

                        final orderData =
                            orderSnapshot.data?.data() as Map<String, dynamic>?;
                        final customerName = data['customerName'] ?? 'Unknown';
                        final address =
                            orderData?['address'] ?? 'No address found';

                        // Return your existing Card widget
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Card(
                            color: primaryColor,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.person,
                                          color: primaryColor),
                                    ),
                                    title: Text(
                                      customerName,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on,
                                          color: Colors.white),
                                      SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          address,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                   children: [
                                    Icon(Icons.money,
                                          color: Colors.white),
                                      SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          orderData?['totalPrice'] ?? 'No amount',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                      ),
                                
                                    
                                   ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                      
                                      children: [
                                        CheckAdressButton(address: address),
                                        SizedBox(width: 12),
                                        MarkAsCompleteButton(orderId: orderId),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('AssignedOrders')
                  .where('assignedToId', isEqualTo: user?.uid)
                  .where('status', isEqualTo: 'Complete')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final dispatchedOrders = snapshot.data?.docs ?? [];

                if (dispatchedOrders.isEmpty) {
                  return Center(child: Text("No completed orders."));
                }

                return ListView.builder(
                  itemCount: dispatchedOrders.length,
                  itemBuilder: (context, index) {
                    final data =
                        dispatchedOrders[index].data() as Map<String, dynamic>;
                    final orderId = dispatchedOrders[index].id;

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('orders')
                          .doc(orderId)
                          .get(),
                      builder: (context, orderSnapshot) {
                        if (!orderSnapshot.hasData) {
                          return Padding(
                            padding: EdgeInsets.all(16),
                            child: LinearProgressIndicator(),
                          );
                        }

                        final orderData =
                            orderSnapshot.data?.data() as Map<String, dynamic>?;
                        final customerName = data['customerName'] ?? 'Unknown';
                        final address =
                            orderData?['address'] ?? 'No address found';

                        // Return your existing Card widget
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Card(
                            color: primaryColor,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.person,
                                          color: primaryColor),
                                    ),
                                    title: Text(
                                      customerName,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on,
                                          color: Colors.white),
                                      SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          address,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(Icons.money,
                                          color: Colors.white),
                                      SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          orderData?['totalPrice'] ?? 'No amount',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}




