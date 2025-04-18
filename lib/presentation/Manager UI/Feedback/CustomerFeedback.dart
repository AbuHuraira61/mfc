import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class SubmitFeedbackScreen extends StatefulWidget {
  final String orderId; // Pass Order ID to the screen

  SubmitFeedbackScreen({required this.orderId});

  @override
  _SubmitFeedbackScreenState createState() => _SubmitFeedbackScreenState();
}

class _SubmitFeedbackScreenState extends State<SubmitFeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController reviewController = TextEditingController();
  double rating = 0.0;

  void submitFeedback() async {
    final review = reviewController.text.trim();

    if (_formKey.currentState!.validate() && rating > 0) {
      try {
        DocumentReference orderRef = FirebaseFirestore.instance.collection('orders').doc(widget.orderId);

        // Check if the order exists
        DocumentSnapshot orderSnapshot = await orderRef.get();
        if (!orderSnapshot.exists) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Order not found')),
          );
          return;
        }

        // Update feedback inside the order
        await orderRef.update({
          'feedback': {
            'review': review,
            'rating': rating,
            'date': Timestamp.now(),
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Feedback submitted successfully!')),
        );

        // Clear fields
        reviewController.clear();
        setState(() {
          rating = 0.0;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting feedback: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and give a rating')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Submit Feedback", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff570101),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildTextField(reviewController, "Review", maxLines: 3),
              SizedBox(height: 16),
              Text("Rating", style: TextStyle(fontSize: 16)),
              RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 35,
                itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (value) {
                  setState(() {
                    rating = value;
                  });
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: submitFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff570101),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text("Submit Feedback",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "$label is required";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
