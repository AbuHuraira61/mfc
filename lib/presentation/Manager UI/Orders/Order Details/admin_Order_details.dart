import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminOrderDetails extends StatefulWidget {
  final String totalAmount;
  final String customerName;
  final List<Map<String,dynamic>> orderDetailsList;
  final String id;
  
  const AdminOrderDetails({super.key, required this.id,required this.totalAmount, required this.customerName, required this.orderDetailsList});

  @override
  State<AdminOrderDetails> createState() => _AdminOrderDetailsState();
}



class _AdminOrderDetailsState extends State<AdminOrderDetails> {


  void _acceptOrder() async {
 try {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.id) // Use the order's document ID
        .update({'status': 'Preparing'}); // Update the status field

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order status updated to Preparing')),
    );

    Navigator.pop(context); // Optional: go back after updating
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to update order: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return  Scaffold(appBar: AppBar(title: Text('Order Details'),),
    body: Column(children: [
      Center(child: Text('${widget.customerName}')),
      Expanded(
        child: ListView.builder(
          itemCount:widget.orderDetailsList.length,
          itemBuilder: (context, index) {
            final data = widget.orderDetailsList[index];
          return OrderDetailsCard(
            data: data,
          );
        },),
      ),
      Text("Total ammount: ${widget.totalAmount}"),
      SizedBox(height: 10,),
      ElevatedButton(onPressed: (){
             _acceptOrder();

      }, child: Text('Accept Order')),
      SizedBox(height: 20,),
    ],),

    
    );
  }
}

class OrderDetailsCard extends StatelessWidget {
  const OrderDetailsCard({super.key, required this.data});
  final Map<String, dynamic> data;
  @override
  Widget build(BuildContext context) {
    return  Card(
               margin: EdgeInsets.symmetric(vertical: 8),
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
               child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                height: 50,
                width: 50,
                child: ClipOval(
                   
                  child: Image.memory(
                    fit: BoxFit.fill,
                    base64Decode(data['image'])),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text("Order ID: #12345",
                    //     style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("${data['name']}" ),
                    Text("Total Price: ${data['product_price']} ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                    Text("Quantity: ${data['quantity']}",
                        style: TextStyle(color: Colors.blue)),
                  ],
                ),
              ),
              
            ],
          ),
               ),
             );
  }
}

