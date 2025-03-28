import 'package:flutter/material.dart';

class OrderStatusScreen extends StatefulWidget {
  const OrderStatusScreen({super.key});

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Column(
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
              "Order No: 1234",
              style: TextStyle(color: Colors.grey[700], fontSize: 16),
            ),
            SizedBox(height: 20),
            OrderStatusStep(
              icon: Icons.check_circle,
              title: "Order Received",
              time: "9:10 am, 10 November 2025",
              isCompleted: true,
            ),
            OrderStatusStep(
              icon: Icons.restaurant_menu,
              title: "Preparing Order",
              time: "9:10 am, 10 November 2025",
              isCompleted: true,
            ),
            OrderStatusStep(
              icon: Icons.delivery_dining,
              title: "On the way",
              time: "9:10 am, 10 November 2025",
              isCompleted: false,
              showTracking: true,
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Future Delivery Confirmation Screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff570101),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                "Confirm Delivery",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderStatusStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final String time;
  final bool isCompleted;
  final bool showTracking;

  const OrderStatusStep({
    super.key,
    required this.icon,
    required this.title,
    required this.time,
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
          subtitle: Text(
            time,
            style: TextStyle(color: Colors.grey),
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
