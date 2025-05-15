import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mfc/Constants/colors.dart';
import 'package:mfc/presentation/Manager%20UI/Orders/Order%20Details/admin_Order_details.dart';
import 'package:mfc/Services/notification_service.dart';

class PendingOrderScreen extends StatefulWidget {
  const PendingOrderScreen({super.key});

  @override
  State<PendingOrderScreen> createState() => _PendingOrderScreenState();
}

class _PendingOrderScreenState extends State<PendingOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Orders Status', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: "Pending"),
              Tab(text: "Preparing"),
              Tab(text: "Assigned"),
              Tab(text: "Dispatched"),
              Tab(text: "Complete"),
              Tab(text: "Cancelled"),
            ],
          ),
        ),
        body: TabBarView(
          physics: BouncingScrollPhysics(),

          children: [
            OrdersList(orderStatus: 'pending'),
            OrdersList(orderStatus: 'Preparing'),
            OrdersList(orderStatus: 'Assigned'),
            OrdersList(orderStatus: 'Dispatched'),
            OrdersList(orderStatus: 'Complete'),
            OrdersList(orderStatus: 'cancelled'),
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
          .where('status', isEqualTo: orderStatus)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return Center(child: Text("No $orderStatus orders."));
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final id = docs[index].id;
            final List<Map<String, dynamic>> orderDetailsList =
                List<Map<String, dynamic>>.from(data['items']);
            final assignedTo = data['assignedTo'] ?? '';
            return OrderCard(
              id: id,
              orderStatus: orderStatus,
              amount: data['totalPrice'].toString(),
              customerName: data['name'] ?? 'Unknown',
              orderDetailsList: orderDetailsList,
              assignedTo: assignedTo,
              customerPhone: data['phone'],
            );
          },
        );
      },
    );
  }
}

class OrderCard extends StatelessWidget {
  final String customerPhone;
  final String customerName;
  final String orderStatus;
  final String amount;
  final String id;
  final List<Map<String, dynamic>> orderDetailsList;
  final String assignedTo;

  const OrderCard({
    super.key,
    required this.customerPhone,
    required this.id,
    required this.orderStatus,
    required this.amount,
    required this.customerName,
    required this.orderDetailsList,
    this.assignedTo = '',
  });

  void _showAssignRiderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Assign Rider'),
          content: SizedBox(
            width: double.maxFinite,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('role', isEqualTo: 'rider')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final riders = snapshot.data?.docs ?? [];
                if (riders.isEmpty) {
                  return Center(child: Text('No riders available'));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: riders.length,
                  itemBuilder: (context, index) {
                    final rData = riders[index].data() as Map<String, dynamic>;
                    final riderName = rData['name'] ?? 'Unknown';
                    final riderId = riders[index].id;

                    return ListTile(
                      title: Text(riderName),
                      trailing: ElevatedButton(
                        onPressed: () async {
                          // Get rider's FCM token
                          final riderDoc = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(riderId)
                              .get();
                          final riderToken = riderDoc.data()?['deviceToken'] ?? '';

                          // Update order document
                          await FirebaseFirestore.instance
                              .collection('orders')
                              .doc(id)
                              .update({
                            'status': 'Assigned',
                            'assignedTo': riderName,
                            'riderId': riderId,
                          });

                          // Create record in DispatchedOrders collection
                          await FirebaseFirestore.instance
                              .collection('AssignedOrders')
                              .doc(id)
                              .set({
                            'orderId': id,
                            'customerName': customerName,
                            'totalPrice': amount,
                            'items': orderDetailsList,
                            'assignedTo': riderName,
                            'assignedToId': riderId,
                            'riderId': riderId,
                            'status': 'Assigned',
                            'phone': customerPhone,
                            'timestamp': FieldValue.serverTimestamp(),
                          });

                          // Send notification to rider
                          await NotificationService().sendOrderAssignedNotification(
                            riderToken,
                            id,
                          );

                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Order assigned to $riderName')),
                          );
                        },
                        child: Text('Assign'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (orderStatus == 'pending') {
      return InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AdminOrderDetails(
              id: id,
              totalAmount: amount,
              customerName: customerName,
              orderDetailsList: orderDetailsList,
            );
          }));
        },
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/largepizza.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Customer: $customerName"),
                      Text("Amount: $amount",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Text("Status: $orderStatus",
                          style: TextStyle(color: primaryColor)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (orderStatus == 'Preparing') {
      return Card(
        margin: EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/largepizza.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Customer: $customerName"),
                    Text("Amount: $amount",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                    Text("Status: $orderStatus",
                        style: TextStyle(color: primaryColor)),
                    SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: () => _showAssignRiderDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff570101),
                      ),
                      child: Text(
                        'Assign Rider',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else if (orderStatus == 'Assigned') {
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
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Customer: $customerName"),
                    Text("Amount: $amount",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                    Text("Status: $orderStatus",
                        style: TextStyle(color: primaryColor)),
                    if (assignedTo.isNotEmpty)
                      Text("Assigned to: $assignedTo",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else if (orderStatus == 'Dispatched'){
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
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Customer: $customerName"),
                    Text("Amount: $amount",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                    Text("Status: $orderStatus",
                        style: TextStyle(color: primaryColor)),
                    if (assignedTo.isNotEmpty)
                      Text("Assigned to: $assignedTo",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else if (orderStatus == 'Completed'){
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
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Customer: $customerName"),
                    Text("Amount: $amount",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                    Text("Status: $orderStatus",
                        style: TextStyle(color: primaryColor)),
                    if (assignedTo.isNotEmpty)
                      Text("Assigned to: $assignedTo",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    // Fallback for any other status
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
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Customer: $customerName"),
                  Text("Amount: $amount",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  Text("Status: $orderStatus",
                      style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
