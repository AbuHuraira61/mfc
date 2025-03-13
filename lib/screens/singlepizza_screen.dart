import 'package:flutter/material.dart';

class SinglePizzaScreen extends StatefulWidget {
  const SinglePizzaScreen({super.key});

  @override
  _SinglePizzaScreenState createState() => _SinglePizzaScreenState();
}

class _SinglePizzaScreenState extends State<SinglePizzaScreen> {
  String selectedVariation = "Small";
  int quantity = 1;
  Map<String, double> variationPrices = {
    "Small": 650.0,
    "Medium": 1550.0,
    "Large": 1950.0
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
                  child: Image.asset('assets/largepizza.png', height: 200),
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
                  EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 12),
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
                      Text("\$32",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text("Hot Pizza",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text(
                    "This spicy pizza diavola is a fan favorite starring Kalamata olives, spicy peppers, and gooey mozzarella cheese.",
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
                          "$variation  RS \${variationPrices[variation]}",
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
    home: SinglePizzaScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
