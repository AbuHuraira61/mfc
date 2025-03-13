import 'package:flutter/material.dart';

class SingleBurgerScreen extends StatefulWidget {
  const SingleBurgerScreen({super.key});

  @override
  _SingleBurgerScreenState createState() => _SingleBurgerScreenState();
}

class _SingleBurgerScreenState extends State<SingleBurgerScreen> {
  String selectedVariation = "Extra Dip Sauce";
  int quantity = 1;
  double basePrice = 20.0;

  Map<String, double> variationPrices = {
    "Extra Dip Sauce": 100.0,
    "Cheese Petty": 150.0,
    "Double Petty": 500.0,
  };

  void increaseQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  void selectVariation(String variation) {
    setState(() {
      selectedVariation = variation;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff570101),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.only(top: 70),
                height: screenHeight * 0.42,
                width: double.infinity,
                decoration: BoxDecoration(color: Color(0xff570101)),
                child: Center(
                  child: Image.asset('assets/burger.png', height: 350),
                ),
              ),
              Positioned(
                top: 50,
                right: 20,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.favorite_border,
                        color: Colors.red, size: 24),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Container(
              height: screenHeight * 0.56,
              width: double.infinity,
              padding:
                  EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.zero,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        width: 70,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Color(0xff570101),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.star, color: Colors.yellow, size: 20),
                            SizedBox(width: 5),
                            Text("4.8",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Text("\$20",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Beef Burger",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "It's juicy, meaty, greasily satisfying. The bun should be slightly crunchy. The cheese should be happily melting over the meat..",
                    style: TextStyle(color: Colors.black54),
                  ),
                  SizedBox(height: 12),
                  Text("Variations:",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  Text("Please select one option:",
                      style: TextStyle(color: Colors.black54, fontSize: 13)),
                  SizedBox(height: 8),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: variationPrices.keys.map((variation) {
                      return RadioListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        title: Text(
                          "$variation  RS ${variationPrices[variation].toString()}",
                          style: TextStyle(fontSize: 14),
                        ),
                        value: variation,
                        groupValue: selectedVariation,
                        activeColor: Color(0xff570101),
                        onChanged: (value) {
                          selectVariation(value as String);
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 28,
                            width: 28,
                            decoration: BoxDecoration(
                              color: Color(0xff570101),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.remove,
                                  color: Colors.white, size: 16),
                              onPressed: decreaseQuantity,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text("$quantity",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(width: 12),
                          Container(
                            height: 28,
                            width: 28,
                            decoration: BoxDecoration(
                              color: Color(0xff570101),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.add,
                                  color: Colors.white, size: 16),
                              onPressed: increaseQuantity,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff570101),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding:
                              EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                        ),
                        icon: Icon(Icons.shopping_cart,
                            color: Colors.white, size: 18),
                        label: Text("Add To Cart",
                            style:
                                TextStyle(color: Colors.white, fontSize: 14)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SingleBurgerScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
