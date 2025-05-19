import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mfc/Constants/colors.dart';
import 'package:mfc/presentation/Customer UI/Orders/Order Status/order_status_detail.dart';
import 'package:mfc/presentation/Customer%20UI/Home/Home_screen.dart';

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

      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.uid)
          .update({
        "orderId": FieldValue.arrayRemove([orderId]),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order removed from your list')),
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
        leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false,
              );
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Order Status",
          style: TextStyle(
            color: secondaryColor,
            fontSize: 22,
          ),
        ),
      ),
      body: currentUser == null
          ? const Center(child: Text('Please login to view orders'))
          : StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser.uid)
                  .snapshots(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                  return const Center(child: Text('No orders found'));
                }

                final orderIds =
                    List<String>.from(userSnapshot.data!.get('orderId') ?? []);

                if (orderIds.isEmpty) {
                  return const Center(child: Text('No orders in this list!'));
                }

                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('orders')
                      .where(FieldPath.documentId, whereIn: orderIds)
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, ordersSnapshot) {
                    if (ordersSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!ordersSnapshot.hasData ||
                        ordersSnapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No orders found'));
                    }

                    final orders = ordersSnapshot.data!.docs;

                    return ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order =
                            orders[index].data() as Map<String, dynamic>;
                        final id = orders[index].id;
                        final timestamp = order['timestamp'] as Timestamp?;
                        final dateTime = timestamp?.toDate();
                        final formattedDate = dateTime != null
                            ? DateFormat('dd MMM, yyyy hh:mm a')
                                .format(dateTime)
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                leading: CircleAvatar(
                                  radius: 26,
                                  backgroundColor:
                                      secondaryColor.withOpacity(0.1),
                                  child: Icon(
                                    Icons.receipt_long,
                                    color: secondaryColor,
                                    size: 28,
                                  ),
                                ),
                                title: Text(
                                  'Order ID # ${index + 1}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: secondaryColor,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(Icons.access_time,
                                            size: 16, color: Colors.white70),
                                        const SizedBox(width: 4),
                                        Flexible(
                                          child: Text(
                                            formattedDate,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 13,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.info_outline,
                                            size: 16, color: Colors.white70),
                                        const SizedBox(width: 4),
                                        const Text(
                                          "Status: ",
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 13),
                                        ),
                                        Flexible(
                                          child: Text(
                                            order['status'] ?? 'N/A',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color: (order['status']
                                                          ?.toLowerCase() ==
                                                      'pending')
                                                  ? Colors.amber[200]
                                                  : Colors.greenAccent,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: (order['status']?.toLowerCase() ==
                                            'complete' ||
                                        order['status']?.toLowerCase() ==
                                            'cancelled')
                                    ? _isDeleting
                                        ? const SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                            onPressed: () => _deleteOrder(id),
                                          )
                                    : null,
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
