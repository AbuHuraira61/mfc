import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class FeedbackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              "Feedback Screen",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.05,
              ),
            ),
            centerTitle: true,
            floating: true,
            snap: true,
            backgroundColor: Colors.white,
            elevation: 2,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .where('feedback', isNotEqualTo: null)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading feedbacks'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                return Column(
                  children: docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final feedback = data['feedback'] is Map
                        ? Map<String, dynamic>.from(data['feedback'])
                        : null;
                    final orderId = data['orderId'] as String? ?? doc.id;

                    // Safely parse items list
                    final rawItems = data['items'];
                    final List<Map<String, dynamic>> items = [];
                    if (rawItems is List) {
                      for (var e in rawItems) {
                        if (e is Map<String, dynamic>) {
                          items.add(e);
                        } else if (e is Map) {
                          items.add(Map<String, dynamic>.from(e));
                        }
                      }
                    }

                    if (feedback == null) return SizedBox.shrink();

                    String formattedDate = '';
                    if (feedback['date'] != null &&
                        feedback['date'] is Timestamp) {
                      formattedDate = DateFormat('dd-MM-yyyy')
                          .format((feedback['date'] as Timestamp).toDate());
                    }

                    return FeedbackCard(
                      orderId: orderId,
                      items: items,
                      rating: (feedback['rating'] ?? 0).toDouble(),
                      review: feedback['review'] ?? '',
                      name: data['name'] as String? ?? 'Anonymous',
                      date: formattedDate,
                      screenWidth: screenWidth,
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FeedbackCard extends StatelessWidget {
  final String orderId;
  final List<Map<String, dynamic>> items;
  final double rating;
  final String review;
  final String date;
  final double screenWidth;
  final String? name;

  FeedbackCard({
    required this.orderId,
    required this.items,
    required this.rating,
    required this.review,
    required this.date,
    required this.screenWidth,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * 0.9,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff570101),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order ID
          Text(
            "Order ID: $orderId",
            style: TextStyle(
              color: Colors.white70,
              fontSize: screenWidth * 0.036,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          // Ordered Items List
          if (items.isNotEmpty) ...[
            SizedBox(
              height: screenWidth * 0.15,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final itemName = item['name'] as String? ?? '';
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        itemName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.032,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Name
          Text(
            name != null ? "Name: $name" : "Name: N/A",
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.038,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),

          // Rating Bar
          RatingBarIndicator(
            rating: rating,
            unratedColor: Colors.white30,
            itemBuilder: (context, _) =>
                const Icon(Icons.star, color: Colors.amber),
            itemCount: 5,
            itemSize: screenWidth * 0.05,
            direction: Axis.horizontal,
          ),
          const SizedBox(height: 10),

          // Review Text
          Text(
            review,
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.038,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),

          // Date
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              date,
              style: TextStyle(
                color: Colors.white60,
                fontSize: screenWidth * 0.032,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class FeedbackScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             title: Text(
//               "Feedback Screen",
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: screenWidth * 0.05,
//               ),
//             ),
//             centerTitle: true,
//             floating: true,
//             snap: true,
//             backgroundColor: Colors.white,
//             elevation: 2,
//             leading: IconButton(
//               icon: Icon(Icons.arrow_back, color: Colors.black),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//           ),

//           // Dynamic Feedback from Firestore (from "orders" collection)
//           SliverToBoxAdapter(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('orders')
//                   .where('feedback', isNotEqualTo: null)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return Center(child: Text('Error loading feedbacks'));
//                 }
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 final feedbackDocs = snapshot.data!.docs;

//                 return Column(
//                   children: feedbackDocs.map((doc) {
//                     final data = doc.data() as Map<String, dynamic>;
//                     final feedback = data['feedback'] as Map<String, dynamic>?;

//                     if (feedback == null) return SizedBox();

//                     String formattedDate = '';
//                     if (data['timestamp'] != null && data['timestamp'] is Timestamp) {
//                       formattedDate = DateFormat('dd-MM-yyyy')
//                           .format((data['timestamp'] as Timestamp).toDate());
//                     }

//                     return FeedbackCard(
//                       rating: (feedback['rating'] ?? 0).toDouble(),
//                       review: feedback['review'] ?? '',
//                       date: formattedDate,
//                       screenWidth: screenWidth,
//                     );
//                   }).toList(),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class FeedbackCard extends StatelessWidget {
//   final double rating;
//   final String review;
//   final String date;
//   final double screenWidth;

//   FeedbackCard({
//     required this.rating,
//     required this.review,
//     required this.date,
//     required this.screenWidth,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: screenWidth * 0.9,
//       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Color(0xff570101),
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black26,
//             blurRadius: 5,
//             offset: Offset(3, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           RatingBarIndicator(
//             rating: rating,
//             unratedColor: Colors.white,
//             itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
//             itemCount: 5,
//             itemSize: screenWidth * 0.05,
//           ),
//           SizedBox(height: 8),
//           Text(
//             review,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: screenWidth * 0.038,
//             ),
//           ),
//           SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Text(
//                 date,
//                 style: TextStyle(
//                   color: Colors.white70,
//                   fontSize: screenWidth * 0.035,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class FeedbackScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             title: Text(
//               "Feedback Screen",
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: screenWidth * 0.05,
//               ),
//             ),
//             centerTitle: true,
//             floating: true,
//             snap: true,
//             backgroundColor: Colors.white,
//             elevation: 2,
//             leading: IconButton(
//               icon: Icon(Icons.arrow_back, color: Colors.black),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//           ),

//           // Dynamic Feedback from Firestore
//           SliverToBoxAdapter(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('feedbacks')
//                   .orderBy('date', descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return Center(child: Text('Error loading feedbacks'));
//                 }
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 final feedbackDocs = snapshot.data!.docs;

//                 return Column(
//                   children: feedbackDocs.map((doc) {
//                     final data = doc.data() as Map<String, dynamic>;

//                     // Format timestamp to date string
//                     String formattedDate = '';
//                     if (data['date'] != null && data['date'] is Timestamp) {
//                       formattedDate = DateFormat('dd-MM-yyyy')
//                           .format((data['date'] as Timestamp).toDate());
//                     }

//                     return FeedbackCard(
//                       //name: data['name'] ?? '',
//                       //location: data['location'] ?? '',
//                       rating: (data['rating'] ?? 0).toDouble(),
//                       review: data['review'] ?? '',
//                       date: formattedDate,
//                       //orderId: data['orderId'] ?? '',
//                       screenWidth: screenWidth,
//                     );
//                   }).toList(),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class FeedbackCard extends StatelessWidget {
//   //final String name;
//   //final String location;
//   final double rating;
//   final String review;
//   final String date;
//   //final String orderId;
//   final double screenWidth;

//   FeedbackCard({
//     //required this.name,
//     //required this.location,
//     required this.rating,
//     required this.review,
//     required this.date,
//     //required this.orderId,
//     required this.screenWidth,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: screenWidth * 0.9,
//       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Color(0xff570101),
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black26,
//             blurRadius: 5,
//             offset: Offset(3, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               // CircleAvatar(
//               //   backgroundImage: AssetImage("assets/gentle.png"),
//               //   radius: screenWidth * 0.08,
//               // ),
//               SizedBox(width: screenWidth * 0.04),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Text(
//                   //   name,
//                   //   style: TextStyle(
//                   //     color: Colors.white,
//                   //     fontWeight: FontWeight.bold,
//                   //     fontSize: screenWidth * 0.045,
//                   //   ),
//                   // ),
//                   // Text(
//                   //   location,
//                   //   style: TextStyle(
//                   //     color: Colors.white70,
//                   //     fontSize: screenWidth * 0.035,
//                   //   ),
//                   // ),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(height: 8),
//           RatingBarIndicator(
//             rating: rating,
//             unratedColor: Colors.white,
//             itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
//             itemCount: 5,
//             itemSize: screenWidth * 0.05,
//           ),
//           SizedBox(height: 8),
//           Text(
//             review,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: screenWidth * 0.038,
//             ),
//           ),
//           SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Text(
//               //   "Order ID: $orderId",
//               //   style: TextStyle(
//               //     color: Colors.white70,
//               //     fontSize: screenWidth * 0.035,
//               //     fontWeight: FontWeight.bold,
//               //   ),
//               // ),
//               Text(
//                 date,
//                 style: TextStyle(
//                   color: Colors.white70,
//                   fontSize: screenWidth * 0.035,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class FeedbackScreen extends StatefulWidget {
//   @override
//   _FeedbackScreenState createState() => _FeedbackScreenState();
// }

// class _FeedbackScreenState extends State<FeedbackScreen> {
//   final List<Map<String, dynamic>> feedbackList = [
//     {
//       "name": "Jacob Clark",
//       "location": "San Francisco, CA",
//       "rating": 4.0,
//       "review": "Great burgers! Delivery was fast and efficient.",
//       "date": "20-02-2016",
//       "orderId": "ORD001"
//     },
//     {
//       "name": "Emily Davis",
//       "location": "New York, NY",
//       "rating": 5.0,
//       "review": "Best pizza in town! Highly recommend their service. 🍕🔥",
//       "date": "12-05-2023",
//       "orderId": "ORD002"
//     },
//     {
//       "name": "Michael Smith",
//       "location": "Los Angeles, CA",
//       "rating": 4.5,
//       "review": "Loved the taste, but the fries could have been hotter.",
//       "date": "08-10-2023",
//       "orderId": "ORD003"
//     },
//     {
//       "name": "Jacob Clark",
//       "location": "San Francisco, CA",
//       "rating": 4.0,
//       "review": "Great burgers! Delivery was fast and efficient.",
//       "date": "20-02-2016",
//       "orderId": "ORD001"
//     },
//     {
//       "name": "Emily Davis",
//       "location": "New York, NY",
//       "rating": 5.0,
//       "review": "Best pizza in town! Highly recommend their service. 🍕🔥",
//       "date": "12-05-2023",
//       "orderId": "ORD002"
//     },
//     {
//       "name": "Michael Smith",
//       "location": "Los Angeles, CA",
//       "rating": 4.5,
//       "review": "Loved the taste, but the fries could have been hotter.",
//       "date": "08-10-2023",
//       "orderId": "ORD003"
//     },
//     {
//       "name": "Sophia Brown",
//       "location": "Chicago, IL",
//       "rating": 5.0,
//       "review": "Amazing food! Will definitely order again.",
//       "date": "05-09-2022",
//       "orderId": "ORD004"
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: CustomScrollView(
//         slivers: [
//           // SliverAppBar replaces AppBar
//           SliverAppBar(
//             title: Text(
//               "Feedback Screen",
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: screenWidth * 0.05,
//               ),
//             ),
//             centerTitle: true,
//             floating: true, // AppBar disappears when scrolling up
//             snap: true, // AppBar reappears when scrolling down
//             backgroundColor: Colors.white,
//             elevation: 2,
//             leading: IconButton(
//               icon: Icon(Icons.arrow_back, color: Colors.black),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//           ),

//           // List of feedback cards inside a SliverList
//           SliverList(
//             delegate: SliverChildBuilderDelegate(
//               (context, index) {
//                 var data = feedbackList[index];
//                 return FeedbackCard(
//                   name: data['name'],
//                   location: data['location'],
//                   rating: data['rating'],
//                   review: data['review'],
//                   date: data['date'],
//                   orderId: data['orderId'],
//                   screenWidth: screenWidth,
//                 );
//               },
//               childCount: feedbackList.length,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class FeedbackCard extends StatefulWidget {
//   final String name;
//   final String location;
//   final double rating;
//   final String review;
//   final String date;
//   final String orderId;
//   final double screenWidth;

//   FeedbackCard({
//     required this.name,
//     required this.location,
//     required this.rating,
//     required this.review,
//     required this.date,
//     required this.orderId,
//     required this.screenWidth,
//   });

//   @override
//   State<FeedbackCard> createState() => _FeedbackCardState();
// }

// class _FeedbackCardState extends State<FeedbackCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: widget.screenWidth * 0.9,
//       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Color(0xff570101),
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black26,
//             blurRadius: 5,
//             offset: Offset(3, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 backgroundImage: AssetImage("assets/gentle.png"),
//                 radius: widget.screenWidth * 0.08, // Responsive Image
//               ),
//               SizedBox(width: widget.screenWidth * 0.04),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.name,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: widget.screenWidth * 0.045,
//                     ),
//                   ),
//                   Text(
//                     widget.location,
//                     style: TextStyle(
//                       color: Colors.white70,
//                       fontSize: widget.screenWidth * 0.035,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(height: 8),
//           RatingBarIndicator(
//             rating: widget.rating,
//             unratedColor: Colors.white,
//             itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
//             itemCount: 5,
//             itemSize: widget.screenWidth * 0.05,
//           ),
//           SizedBox(height: 8),
//           Text(
//             widget.review,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: widget.screenWidth * 0.038,
//             ),
//           ),
//           SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Order ID: ${widget.orderId}",
//                 style: TextStyle(
//                   color: Colors.white70,
//                   fontSize: widget.screenWidth * 0.035,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 widget.date,
//                 style: TextStyle(
//                   color: Colors.white70,
//                   fontSize: widget.screenWidth * 0.035,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
