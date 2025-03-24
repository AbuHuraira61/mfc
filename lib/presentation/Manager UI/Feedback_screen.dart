import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final List<Map<String, dynamic>> feedbackList = [
    {
      "name": "Jacob Clark",
      "location": "San Francisco, CA",
      "rating": 4.0,
      "review": "Great burgers! Delivery was fast and efficient.",
      "date": "20-02-2016",
      "orderId": "ORD001"
    },
    {
      "name": "Emily Davis",
      "location": "New York, NY",
      "rating": 5.0,
      "review": "Best pizza in town! Highly recommend their service. 🍕🔥",
      "date": "12-05-2023",
      "orderId": "ORD002"
    },
    {
      "name": "Michael Smith",
      "location": "Los Angeles, CA",
      "rating": 4.5,
      "review": "Loved the taste, but the fries could have been hotter.",
      "date": "08-10-2023",
      "orderId": "ORD003"
    },
    {
      "name": "Jacob Clark",
      "location": "San Francisco, CA",
      "rating": 4.0,
      "review": "Great burgers! Delivery was fast and efficient.",
      "date": "20-02-2016",
      "orderId": "ORD001"
    },
    {
      "name": "Emily Davis",
      "location": "New York, NY",
      "rating": 5.0,
      "review": "Best pizza in town! Highly recommend their service. 🍕🔥",
      "date": "12-05-2023",
      "orderId": "ORD002"
    },
    {
      "name": "Michael Smith",
      "location": "Los Angeles, CA",
      "rating": 4.5,
      "review": "Loved the taste, but the fries could have been hotter.",
      "date": "08-10-2023",
      "orderId": "ORD003"
    },
    {
      "name": "Sophia Brown",
      "location": "Chicago, IL",
      "rating": 5.0,
      "review": "Amazing food! Will definitely order again.",
      "date": "05-09-2022",
      "orderId": "ORD004"
    },
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // SliverAppBar replaces AppBar
          SliverAppBar(
            title: Text(
              "Feedback Screen",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.05,
              ),
            ),
            centerTitle: true,
            floating: true, // AppBar disappears when scrolling up
            snap: true, // AppBar reappears when scrolling down
            backgroundColor: Colors.white,
            elevation: 2,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),

          // List of feedback cards inside a SliverList
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                var data = feedbackList[index];
                return FeedbackCard(
                  name: data['name'],
                  location: data['location'],
                  rating: data['rating'],
                  review: data['review'],
                  date: data['date'],
                  orderId: data['orderId'],
                  screenWidth: screenWidth,
                );
              },
              childCount: feedbackList.length,
            ),
          ),
        ],
      ),
    );
  }
}

class FeedbackCard extends StatefulWidget {
  final String name;
  final String location;
  final double rating;
  final String review;
  final String date;
  final String orderId;
  final double screenWidth;

  FeedbackCard({
    required this.name,
    required this.location,
    required this.rating,
    required this.review,
    required this.date,
    required this.orderId,
    required this.screenWidth,
  });

  @override
  State<FeedbackCard> createState() => _FeedbackCardState();
}

class _FeedbackCardState extends State<FeedbackCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.screenWidth * 0.9,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xff570101),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(3, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage("assets/gentle.png"),
                radius: widget.screenWidth * 0.08, // Responsive Image
              ),
              SizedBox(width: widget.screenWidth * 0.04),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: widget.screenWidth * 0.045,
                    ),
                  ),
                  Text(
                    widget.location,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: widget.screenWidth * 0.035,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          RatingBarIndicator(
            rating: widget.rating,
            unratedColor: Colors.white,
            itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
            itemCount: 5,
            itemSize: widget.screenWidth * 0.05,
          ),
          SizedBox(height: 8),
          Text(
            widget.review,
            style: TextStyle(
              color: Colors.white,
              fontSize: widget.screenWidth * 0.038,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order ID: ${widget.orderId}",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: widget.screenWidth * 0.035,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.date,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: widget.screenWidth * 0.035,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
