import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';

class OrderStatusDetail extends StatefulWidget {
  final String id;
  const OrderStatusDetail({super.key, required this.id});

  @override
  State<OrderStatusDetail> createState() => _OrderStatusDetailState();
}


class _OrderStatusDetailState extends State<OrderStatusDetail> {

  


  @override
  Widget build(BuildContext context) {
 

    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff570101),
        centerTitle: true,
        elevation: 0,
        title: Text(
          'OrderStatus Screen',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder<DocumentSnapshot>(
          future:  FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.id)
          .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData || !snapshot.data!.exists) {
      return Center(child: Text('Order not found.'));
    }

    final data = snapshot.data!.data() as Map<String, dynamic>;
    final status = data['status']?.toString().toLowerCase() ?? '';

    // Define your custom step logic here
    bool isReceived = true; // always true, order is received
    bool isPreparing = status == 'preparing' ;
    bool isOnTheWay = status == 'dispatched' ;
    bool isCompleted = status == 'completed';
    bool isCanceled = status == 'canceled';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    'assets/platter.png',
                    height: 230,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  "Order Id: ${widget.id}",
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),
                SizedBox(height: 20),
                
                
                OrderStatusStep(
                  icon: Icons.check_circle,
                  title: "Order Received",
                 
                  isCompleted: isReceived,
                ),
                OrderStatusStep(
                  icon: Icons.restaurant_menu,
                  title: "Preparing Order",
                  
                  isCompleted: isPreparing,
                ),
                OrderStatusStep(
                  icon: Icons.delivery_dining,
                  title: "On the way",
                 
                  isCompleted: isOnTheWay,
                  showTracking: true,
                ),
             
                OrderStatusStep(
                  icon: Icons.cancel,
                  title: "This order has been canceled",
                 
                  isCompleted: isOnTheWay,
                  showTracking: true,
                ),

                Spacer(),
                ElevatedButton(
                  onPressed: () async {final orderDoc = await FirebaseFirestore.instance
                  .collection('orders')
                  .doc(widget.id)
                  .get();
            
              if (orderDoc.exists) {
                final data = orderDoc.data();
                final Timestamp? timestamp = data?['timestamp'];
            
                if (timestamp != null) {
                  final orderTime = timestamp.toDate();
                  final currentTime = DateTime.now();
                  final difference = currentTime.difference(orderTime).inMinutes;
            
                  if (difference <= 25) {
            await FirebaseFirestore.instance
                .collection('orders')
                .doc(widget.id)
                .update({'status': 'cancelled'});
            
            Get.snackbar('', 'Order canceled successfully!');
            
            Navigator.pop(context);
                  } else {
            Get.snackbar('', 'Cancelation time expired! you cannot cancel this order!');
                  }
                }
              }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff570101),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    "Cancel Order",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}

class OrderStatusStep extends StatelessWidget {
  final IconData icon;
  final String title;
  
  final bool isCompleted;
  final bool showTracking;

  const OrderStatusStep({
    super.key,
    required this.icon,
    required this.title,
    
    required this.isCompleted,
    this.showTracking = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(
            icon,
            color: Color(0xff570101),
            size: 30,
          ),
          title: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          
        ),
        if (showTracking)
          Padding(
            padding: const EdgeInsets.only(left: 72.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0xff570101),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Tracking",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
      ],
    );
  }
}