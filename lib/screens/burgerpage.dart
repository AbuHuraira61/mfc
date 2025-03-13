import 'package:flutter/material.dart';
import 'package:mfc/screens/confirmorder.dart';

class BurgerScreen extends StatelessWidget {
  final List<Map<String, String>> burgers = List.generate(
    10,
    (index) => {
      "name": "Beef Burger",
      "price": "\$20",
      "image": "assets/pizza-pic.png",
    },
  );

  BurgerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF6A0202),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        title: Text("Burgers",
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: burgers.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            return BurgerCard(
              name: burgers[index]["name"]!,
              price: burgers[index]["price"]!,
              image: burgers[index]["image"]!,
            );
          },
        ),
      ),
    );
  }
}

class BurgerCard extends StatelessWidget {
  final String name;
  final String price;
  final String image;

  const BurgerCard(
      {super.key,
      required this.name,
      required this.price,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              //color: Color(0xFF570101),
              gradient: LinearGradient(
                colors: [
                  Color(0xFF570101), // Dark Red
                  Color(0xFF750202), // Slightly lighter red
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
                  child: Image.asset(image, fit: BoxFit.cover),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
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
                        price,
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
