import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mfc/Constants/colors.dart';
import 'package:mfc/presentation/Customer%20UI/Orders/Order%20Status/order_status_detail.dart';

class OrderStatusScreen extends StatefulWidget {
  const OrderStatusScreen({super.key});

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  List<Map<String, dynamic>> ordersList = [];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _deleteOrder(String orderId) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) return;

  // // Remove order from "orders" collection
  // await FirebaseFirestore.instance.collection("orders").doc(orderId).delete();

  // Remove orderId from user's document
  await FirebaseFirestore.instance.collection("users").doc(currentUser.uid).update({
    "orderId": FieldValue.arrayRemove([orderId]),
  });

  // Refresh list
  _fetchOrders();
}


  Future<void> _fetchOrders() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .get();

    if (userDoc.exists) {
      final orderIds = List<String>.from(userDoc.data()?['orderId'] ?? []);

      List<Map<String, dynamic>> fetchedOrders = [];
      for (String orderId in orderIds) {
        final orderDoc = await FirebaseFirestore.instance
            .collection("orders")
            .doc(orderId)
            .get();

        if (orderDoc.exists) {
          final orderData = orderDoc.data()!;
          orderData['orderId'] = orderId; // Attach orderId for display
          fetchedOrders.add(orderData);
        }
      }

      setState(() {
        ordersList = fetchedOrders;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Order Status",
          style: TextStyle(
            color: secondaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ordersList.isEmpty
          ? Center(child: Center(child: Text('No order in this list!'),))
          : ListView.builder(
              itemCount: ordersList.length,
              itemBuilder: (context, index) {
                final order = ordersList[index];
                final id = order['orderId'];
                final timestamp = order['timestamp'] as Timestamp?;
                // final date = timestamp?.toDate().toString() ?? 'N/A';
                final dateTime = timestamp?.toDate();
                final formattedDate = dateTime != null
                    ? "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} - ${dateTime.day}/${dateTime.month}"
                    : 'N/A';
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                     return OrderStatusDetail(id: id,);
                    },));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: primaryColor, width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Order: #${index + 1 ?? 'N/A'}",
                                style: TextStyle(
                                    color: primaryColor, fontSize: 14)),
                            RichText(
                              text: TextSpan(
                                text: "Status: ",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: order['status'] ?? 'N/A',
                                    style: TextStyle(
                                      color: (order['status']?.toLowerCase() ==
                                              'pending')
                                          ? primaryColor
                                          : Colors.green,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(formattedDate,
                                style: TextStyle(
                                    color: primaryColor, fontSize: 12)),
                                    if (order['status']?.toLowerCase() == 'completed' ||
        order['status']?.toLowerCase() == 'canceled')
      IconButton(
        icon: Icon(Icons.delete, color: Colors.red),
        onPressed: () async {
           await _deleteOrder(order['orderId']);
          setState(() {
           
          });
          
        },
      ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
