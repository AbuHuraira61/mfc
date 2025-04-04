import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mfc/Helper/cart_provider.dart';
import 'package:mfc/Helper/db_helper.dart';
import 'package:mfc/Models/cart_model.dart';
import 'package:mfc/Utilities/ImageDecoder.dart';
import 'package:mfc/presentation/Customer%20UI/Home/Cart/Cart_screen.dart';
import 'package:provider/provider.dart';

class SinglePizzaScreen extends StatefulWidget {
  final Map singlePizza;
  const SinglePizzaScreen({super.key, required this.singlePizza});

  @override
  _SinglePizzaScreenState createState() => _SinglePizzaScreenState();
}

class _SinglePizzaScreenState extends State<SinglePizzaScreen> {
  DBHelper dbHelper = DBHelper();


  String selectedVariation = "Small";
  int quantity = 1;
  late Map<String, double> variationPrices;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> prices = widget.singlePizza['prices'] ?? {};

    variationPrices = {
       "Small": double.tryParse(prices["small"].toString()) ?? 0.0,
    "Medium": double.tryParse(prices["medium"].toString()) ?? 0.0,
    "Large": double.tryParse(prices["large"].toString()) ?? 0.0,
    "Family": double.tryParse(prices["family"].toString()) ?? 0.0,
    };
  }

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
    final cart = Provider.of<CartProvider>(context);
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff570101),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 70),
                height: screenHeight * 0.42,
                width: double.infinity,
                decoration: const BoxDecoration(color: Color(0xff570101)),
                child: Center(
                  child: widget.singlePizza['image'] != null &&
                          widget.singlePizza['image'].isNotEmpty
                      ? Image.memory(
                          decodeImage(widget.singlePizza['image']),
                          height: 200)
                      : Image.asset(
                          "assets/default-food.png",
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Positioned(
                top: 50,
                left: 20,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.white, size: 28),
                  onPressed: () {
                    Navigator.pop(context);
                  },
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
                    icon: const Icon(Icons.favorite_border,
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
              padding: const EdgeInsets.only(
                  top: 30, left: 20, right: 20, bottom: 12),
              decoration: const BoxDecoration(
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        width: 70,
                        height: 35,
                        decoration: BoxDecoration(
                          color: const Color(0xff570101),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: const [
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
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(widget.singlePizza['name'],
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(
                    widget.singlePizza['description'],
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 12),
                  const Text("Variations:",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const Text("Please select one option:",
                      style: TextStyle(color: Colors.black54, fontSize: 13)),
                  const SizedBox(height: 8),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: variationPrices.keys.map((variation) {
                      return RadioListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        title: Text(
                          "$variation  RS ${variationPrices[variation]?.toStringAsFixed(0)}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        value: variation,
                        groupValue: selectedVariation,
                        activeColor: const Color(0xff570101),
                        onChanged: (value) {
                          selectVariation(value as String);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 28,
                            width: 28,
                            decoration: const BoxDecoration(
                              color: Color(0xff570101),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.remove,
                                  color: Colors.white, size: 16),
                              onPressed: decreaseQuantity,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text("$quantity",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 12),
                          Container(
                            height: 28,
                            width: 28,
                            decoration: const BoxDecoration(
                              color: Color(0xff570101),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.add,
                                  color: Colors.white, size: 16),
                              onPressed: increaseQuantity,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                           
                          String uniqueCartId = "${widget.singlePizza['id']}_${selectedVariation}";
                          print(uniqueCartId);
                          dbHelper.insert(Cart(
                          id: uniqueCartId, 
                          image: widget.singlePizza['image'],
                          initialPrice: variationPrices[selectedVariation], 
                          productName: widget.singlePizza['name'], 
                          productPrice: variationPrices[selectedVariation], 
                          quantity: quantity))
                          .then(
                            (value) {
                              print("✅ Item added to database"); 
                              cart.addTotalPrice(variationPrices[selectedVariation]!,);
                                print("🛍️ addTotalPrice() Called with: ${variationPrices[selectedVariation]!}"); // Step 3
                              cart.addCounter;
                                 print("🛒 Cart Counter Updated"); // Step 4
                              Get.snackbar( 'Success!', 'Product is added to cart');
                            Get.off(
                              CartScreen()
                            );
                            },
                          )
                          .onError((error, stackTrace) {
                            Get.snackbar( 'Error!', error.toString());
                          },);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff570101),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 0),
                        ),
                        icon: const Icon(Icons.shopping_cart,
                            color: Colors.white, size: 18),
                        label: const Text("Add To Cart",
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
