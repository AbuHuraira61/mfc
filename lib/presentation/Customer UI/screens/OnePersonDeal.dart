import 'package:flutter/material.dart';

class OnePersonDeal extends StatefulWidget {
  OnePersonDeal({super.key});

  @override
  _OnePersonDealState createState() => _OnePersonDealState();
}

class _OnePersonDealState extends State<OnePersonDeal> {
  List<Map<String, dynamic>> items = List.generate(
    10,
    (index) => {
      "name": "Deal 1",
      "description":
          "It's includes a juicy burger, salty fries, and a refreshing drink.",
      "price": "RS 1050.00",
      "image": "assets/Deal1.png",
      "quantity": 1,
    },
  );

  void addToCart(Map<String, dynamic> item) {
    setState(() {
      // Handle add to cart logic
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${item["name"]} added to cart")),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(
                "One Person Deals",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: screenWidth * 0.05),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              floating: true,
              snap: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              elevation: 0,
            ),
            SliverPadding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = items[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: screenWidth * 0.03),
                      padding: EdgeInsets.all(screenWidth * 0.03),
                      decoration: BoxDecoration(
                        color: Color(0xff570101),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IntrinsicHeight(
                        child: Stack(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    item["image"],
                                    width: screenWidth * 0.25,
                                    height: screenWidth * 0.25,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.03),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item["name"],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: screenWidth * 0.045,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: screenWidth * 0.01),
                                      Text(
                                        item["description"],
                                        style: TextStyle(
                                          color: Colors.grey[300],
                                          fontSize: screenWidth * 0.035,
                                        ),
                                      ),
                                      SizedBox(height: screenWidth * 0.015),
                                      Text(
                                        item["price"],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenWidth * 0.04,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: -2, // Moves the cart icon up
                              right: 5,
                              child: GestureDetector(
                                onTap: () => addToCart(item),
                                child: Icon(Icons.shopping_cart,
                                    color: Colors.white,
                                    size: screenWidth * 0.06),
                              ),
                            ),
                            Positioned(
                              bottom: -1, // Moves the quantity icons down
                              right: 5,
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (item["quantity"] > 1) {
                                          item["quantity"]--;
                                        }
                                      });
                                    },
                                    child: Icon(Icons.remove_circle,
                                        color: Colors.white,
                                        size: screenWidth * 0.06),
                                  ),
                                  SizedBox(width: screenWidth * 0.02),
                                  Text(
                                    item["quantity"].toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenWidth * 0.045),
                                  ),
                                  SizedBox(width: screenWidth * 0.02),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        item["quantity"]++;
                                      });
                                    },
                                    child: Icon(Icons.add_circle,
                                        color: Colors.white,
                                        size: screenWidth * 0.05),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: items.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
