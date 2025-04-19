import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mfc/auth/SplashScreen/splashscreen.dart';
import 'package:mfc/presentation/Rider%20UI/RiderPendingOrders.dart';

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
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SplashScreen()),
                    (route) => false,
                  );
                }
              },
              icon: Icon(Icons.logout))
        ],
        title: Center(child: Text('Rider Home')),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('DispatchedOrders')
            .where('assignedToId', isEqualTo: user?.uid)
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
              final data = dispatchedOrders[index].data() as Map<String, dynamic>;
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

                  final orderData = orderSnapshot.data?.data() as Map<String, dynamic>?;

                  final customerName = data['customerName'] ?? 'Unknown';
                  final address = orderData?['address'] ?? 'No address found';

                  return ListTile(
                    leading: Icon(Icons.local_shipping),
                    title: Text('Customer: $customerName'),
                    subtitle: Text('Address: $address'),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
