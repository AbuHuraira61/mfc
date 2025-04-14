import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mfc/presentation/Manager%20UI/Orders/Order%20Details/admin_Order_details.dart';

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

class PendingOrderScreen extends StatefulWidget {
  const PendingOrderScreen({super.key});

  @override
  State<PendingOrderScreen> createState() => _PendingOrderScreenState();
}

class _PendingOrderScreenState extends State<PendingOrderScreen> {
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
            OrdersList(orderStatus: 'pending'),
            OrdersList(orderStatus: 'Preparing'),
            OrdersList(orderStatus: 'Dispatched'),
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
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
      .collection('orders')
      .where('status', isEqualTo: orderStatus )
      .snapshots(),
      builder: (context, snapshot) {
       
       if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
       }

         final docs = snapshot.data?.docs ?? [];

         if(docs.isEmpty){
           return Center(child: Text("No $orderStatus orders."));
         }


        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: docs.length, // Sample data
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final id = docs[index].id;
            final List<Map<String, dynamic>> orderDetailsList = List<Map<String, dynamic>>.from(data['items']);
            return OrderCard(
               id: id,
              orderDetailsList: orderDetailsList,
              ammount: data['totalPrice'],
              customerName:  data['name'] ?? 'Unknown',
              orderStatus: orderStatus);
          },
        );
      }
    );
  }
}

class OrderCard extends StatelessWidget {
  final String customerName;
  final String orderStatus;
  final String ammount;
  final String id;
    final List<Map<String,dynamic>> orderDetailsList;

  const OrderCard({super.key, required this.id,required this.orderStatus, required this.ammount, required this.customerName, required this.orderDetailsList});

  @override
  Widget build(BuildContext context) {
    if(orderStatus == 'pending'){
       return InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AdminOrderDetails(
              id: id,
              totalAmount: ammount, customerName: customerName,orderDetailsList: orderDetailsList,);
          },));
        },
         child: Card(
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
                    // Text("Order ID: #12345",
                    //     style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Customer: $customerName" ),
                    Text("Amount: $ammount",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                    Text("Status: $orderStatus",
                        style: TextStyle(color: Colors.blue)),
                  ],
                ),
              ),
              
            ],
          ),
               ),
             ),
       );
    }
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
                  // Text("Order ID: #12345",
                  //     style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Customer: $customerName" ),
                  Text("Amount: $ammount",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  Text("Status: $orderStatus",
                      style: TextStyle(color: Colors.blue)),
                ],
              ),
            ),
            if (orderStatus != "On The Way")
              ElevatedButton(
                onPressed: () async {
                
 try {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(id) // Use the order's document ID
        .update({'status': 'Dispatched'}); // Update the status field

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order status updated to Preparing')),
    );

   // Optional: go back after updating
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to update order: $e')),
    );
  }

                },
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
