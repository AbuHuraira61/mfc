import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PendingOrderScreen(),
    );
  }
}

class PendingOrderScreen extends StatelessWidget {
  const PendingOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Pending Orders', style: TextStyle(color: Colors.black)),
          centerTitle: true,
          bottom: TabBar(
            labelColor: Colors.black,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(text: "Pending"),
              Tab(text: "Preparing"),
              Tab(text: "Dispatched"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            OrdersList(orderStatus: 'Pending'),
            OrdersList(orderStatus: 'Preparing'),
            OrdersList(orderStatus: 'On The Way'),
          ],
        ),
      ),
    );
  }
}

class OrdersList extends StatelessWidget {
  final String orderStatus;
  const OrdersList({super.key, required this.orderStatus});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: 5, // Sample data
      itemBuilder: (context, index) {
        return OrderCard(orderStatus: orderStatus);
      },
    );
  }
}

class OrderCard extends StatelessWidget {
  final String orderStatus;
  const OrderCard({super.key, required this.orderStatus});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/largepizza.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Order ID: #12345",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Customer: John Doe"),
                  Text("Amount: RS 500",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  Text("Status: $orderStatus",
                      style: TextStyle(color: Colors.blue)),
                ],
              ),
            ),
            if (orderStatus != "On The Way")
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff570101),
                ),
                child: Text(
                  orderStatus == "Pending" ? "Accept" : "Dispatch",
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
