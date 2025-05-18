import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mfc/Constants/colors.dart';
import 'package:mfc/presentation/Rider%20UI/Common%20Widgets/check_address_button.dart';
import 'package:mfc/presentation/Rider%20UI/Common%20Widgets/mark_as_complete_button.dart';
import 'package:url_launcher/url_launcher.dart';

class DispatchedOrdersScreen extends StatelessWidget {
  const DispatchedOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Dispatched Orders', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('AssignedOrders')
            .where('riderId', isEqualTo: user?.uid)
            .where('status', isEqualTo: 'Dispatched')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final orders = snapshot.data?.docs ?? [];

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_shipping_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No dispatched orders',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>;
              final orderId = orders[index].id;
              final List<Map<String, dynamic>> items = 
                  List<Map<String, dynamic>>.from(order['items'] ?? []);

              return Card(
                margin: EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${orderId.substring(0, 8)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Customer: ${order['customerName'] ?? 'N/A'}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Phone: ${order['phone'] ?? 'N/A'}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Total Amount: \Rs.${order['totalPrice'] ?? '0.00'}',
                        style: TextStyle(
                          fontSize: 16,
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Items:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      ...items.map((item) => Padding(
                            padding: EdgeInsets.only(left: 16, top: 4),
                            child: Text(
                              '• ${item['name']} x${item['quantity']}',
                              style: TextStyle(fontSize: 14),
                            ),
                          )),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (order['phone'] != null) ...[
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  final Uri url = Uri(
                                    scheme: 'tel',
                                    path: order['phone'], 
                                  );
                              
                                 await launchUrl(
                                      url,
                                      mode: LaunchMode.externalApplication,
                                    );
                                  
                                },
                                icon: Icon(Icons.phone),
                                label: Text('Call'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                          ],
                          CheckAdressButton(address: order['address']),
                          SizedBox(width: 8),
                          MarkAsCompleteButton(orderId: orderId),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
} 