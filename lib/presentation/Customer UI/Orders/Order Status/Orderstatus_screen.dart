import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mfc/Constants/colors.dart';
import 'package:mfc/presentation/Customer%20UI/Orders/Order%20Status/order_status_detail.dart';

class OrderStatusScreen extends StatefulWidget {
  const OrderStatusScreen({super.key});

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  bool _isDeleting = false;

  Future<void> _deleteOrder(String orderId) async {
    if (_isDeleting) return;
    
    setState(() {
      _isDeleting = true;
    });

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      // Only remove orderId from user's document
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.uid)
          .update({
        "orderId": FieldValue.arrayRemove([orderId]),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order removed from your list')),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove order: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

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
      body: currentUser == null 
          ? Center(child: Text('Please login to view orders'))
          : StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser.uid)
                  .snapshots(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                  return Center(child: Text('No orders found'));
                }

                final orderIds = List<String>.from(userSnapshot.data!.get('orderId') ?? []);

                if (orderIds.isEmpty) {
                  return Center(child: Text('No orders in this list!'));
                }

                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('orders')
                      .where(FieldPath.documentId, whereIn: orderIds)
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, ordersSnapshot) {
                    if (ordersSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!ordersSnapshot.hasData || ordersSnapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No orders found'));
                    }

                    final orders = ordersSnapshot.data!.docs;

                    return ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index].data() as Map<String, dynamic>;
                        final id = orders[index].id;
                        final timestamp = order['timestamp'] as Timestamp?;
                        // final dateTime = timestamp?.toDate();
                        // final formattedDate = dateTime != null
                        //     ? "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} - ${dateTime.day}/${dateTime.month}"
                        //     : 'N/A';
                         final formattedDate = timestamp != null
                  ? DateFormat('MMM dd, hh:mm a').format(timestamp.toDate())
                  : 'N/A';

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderStatusDetail(id: id),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: primaryColor, width: 2),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Order: #${index + 1}",
                                      style: TextStyle(color: secondaryColor, fontSize: 14),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: "Status: ",
                                        style: TextStyle(
                                          color: secondaryColor,
                                          fontSize: 14,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: order['status'] ?? 'N/A',
                                            style: TextStyle(
                                              color: (order['status']?.toLowerCase() == 'pending')
                                                  ? Colors.amber
                                                  : Colors.lightBlueAccent,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      formattedDate,
                                      style: TextStyle(color: secondaryColor, fontSize: 12),
                                    ),
                                    if (order['status']?.toLowerCase() == 'complete' ||
                                        order['status']?.toLowerCase() == 'cancelled')
                                      _isDeleting
                                          ? SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                color: secondaryColor,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : IconButton(
                                              icon: Icon(Icons.delete, color: secondaryColor),
                                              onPressed: () => _deleteOrder(id),
                                            ),
                                  ],
                                ),
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
    );
  }
}
