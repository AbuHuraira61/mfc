import 'package:flutter/material.dart';
import 'package:mfc/presentation/Customer%20UI/screens/Sanan/OrderConfirmationScreen.dart';

class CustomCard extends StatefulWidget {
  final String name;
  final String price;
  final String image;

  const CustomCard(
      {super.key,
      required this.name,
      required this.price,
      required this.image,
      required int imageHeight,
      required int imageWidth});

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF570101), // Dark Red
                  Color(0xFF750202), // Slightly lighter redzz
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Image.asset(widget.image, fit: BoxFit.cover),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.price,
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      OrderConfirmationScreen()));
                        },
                        child: Icon(Icons.shopping_cart_outlined,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          // Heart icon positioned at the top-right corner
          Positioned(
            top: 8,
            right: 8,
            child: Icon(Icons.favorite_border, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
