import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mfc/Constants/colors.dart';
import 'package:mfc/Services/notification_service.dart';

class AdminOrderDetails extends StatefulWidget {
  final String totalAmount;
  final String customerName;
  final List<Map<String, dynamic>> orderDetailsList;
  final String id;

  const AdminOrderDetails(
      {super.key,
      required this.id,
      required this.totalAmount,
      required this.customerName,
      required this.orderDetailsList});

  @override
  State<AdminOrderDetails> createState() => _AdminOrderDetailsState();
}

class _AdminOrderDetailsState extends State<AdminOrderDetails> {
  bool _isLoading =false;
  bool _isLoading2 =false;
  void _acceptOrder() async {
    try {
      setState(() {
        _isLoading = true;
      });
      // Get customer's FCM token
      final orderDoc = await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.id)
          .get();
      
      final userId = orderDoc.data()?['userId'] ?? '';
      
      // Get customer's token
      final customerDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      final customerToken = customerDoc.data()?['deviceToken'] ?? '';

      await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.id)
          .update({'status': 'Preparing'}); 

      // Send notification to customer
      if (customerToken.isNotEmpty) {
       
        await NotificationService.sendNotification(
          token: customerToken,
          title: 'Order Update',
          body: 'We are working on your order. Stay with us!',
          data: {
            'type': 'order',
            'orderId': widget.id,
          },
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order status updated to Preparing')),
      );

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
      Navigator.pop(context);
    }
    } catch (e) {
       setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update order: $e')),
      );
    }

    
  }

  void _cancelOrder() async {
    try {
       setState(() {
        _isLoading2 = true;
      });
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.id)
          .update({'status': 'cancelled'});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order has been cancelled')),
      );
       setState(() {
        _isLoading2 = false;
      });

      if (mounted) {
      Navigator.pop(context);
    }
    } catch (e) {
       setState(() {
        _isLoading2 = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel order: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'Order Details',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Center(child: Text('${widget.customerName}')),
          Expanded(
            child: ListView.builder(
              itemCount: widget.orderDetailsList.length,
              itemBuilder: (context, index) {
                final data = widget.orderDetailsList[index];
                return OrderDetailsCard(
                  data: data,
                );
              },
            ),
          ),
          Text(
            "Total amount: ${widget.totalAmount}",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: Get.height * 0.06,
                width: Get.width * 0.4,
                child: ElevatedButton(
                  onPressed: _acceptOrder,
                  child: _isLoading ? CircularProgressIndicator(color: secondaryColor,) : Text(
                    'Accept Order',
                    style: TextStyle(color: secondaryColor, fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      )),
                ),
              ),
              SizedBox(
                height: Get.height * 0.06,
                width: Get.width * 0.4,
                child: ElevatedButton(
                  onPressed: _cancelOrder,
                  child: _isLoading2 ? CircularProgressIndicator(color: secondaryColor,)   : Text(
                    'Cancel Order',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      )),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class OrderDetailsCard extends StatelessWidget {
  const OrderDetailsCard({super.key, required this.data});
  final Map<String, dynamic> data;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              child: ClipOval(
                child:
                    Image.memory(fit: BoxFit.fill, base64Decode(data['image'])),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text("Order ID: #12345",
                  //     style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("${data['name']}"),
                  Text("Total Price: ${data['product_price']} ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  Text("Quantity: ${data['quantity']}",
                      style: TextStyle(color: primaryColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
