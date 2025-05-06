import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderStatusProvider with ChangeNotifier {
  List<Map<String, dynamic>> _ordersList = [];

  List<Map<String, dynamic>> get ordersList => _ordersList;

  Future<void> fetchOrders() async {
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
          orderData['orderId'] = orderId;
          fetchedOrders.add(orderData);
        }
      }

      _ordersList = fetchedOrders;
      notifyListeners();
    }
  }

  Future<void> deleteOrder(String orderId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .update({
      "orderId": FieldValue.arrayRemove([orderId]),
    });

    await fetchOrders();
  }
}
