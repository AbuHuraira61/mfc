import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:mfc/Constants/colors.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Customer Feedback",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.05,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('feedback', isNotEqualTo: null)
            .orderBy('feedback.date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error loading feedbacks'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.feedback_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No feedback available yet!',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Customer feedbacks will appear here',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final feedback = data['feedback'] is Map
                  ? Map<String, dynamic>.from(data['feedback'])
                  : null;

              if (feedback == null) return SizedBox.shrink();

              String formattedDate = '';
              if (feedback['date'] != null && feedback['date'] is Timestamp) {
                formattedDate = DateFormat('dd-MM-yyyy')
                    .format((feedback['date'] as Timestamp).toDate());
              }

              return Container(
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order #${doc.id.substring(0, 8)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          'Customer: ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          data['name'] ?? 'Anonymous',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    RatingBarIndicator(
                      rating: (feedback['rating'] ?? 0).toDouble(),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 20.0,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Review:',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      feedback['review'] ?? 'No review provided',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
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

  const FeedbackCard({super.key, 
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
