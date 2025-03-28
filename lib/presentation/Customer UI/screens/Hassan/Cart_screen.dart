import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mfc/presentation/Customer%20UI/screens/ChekoutScreens/checkoutScreen.dart';

class CartScreen extends StatelessWidget {
  final CartController cartController = Get.put(CartController());

  CartScreen() {
    cartController.addSampleProducts(); // Adding sample products to the cart
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Cart Screen", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color(0xff570101),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() => ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: cartController.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartController.cartItems[index];
                    return Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 8, horizontal: screenWidth * 0.04),
                      padding: EdgeInsets.all(screenWidth * 0.03),
                      decoration: BoxDecoration(
                        color: Color(0xff570101),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(item.image,
                                    width: screenWidth * 0.225,
                                    height: screenWidth * 0.210,
                                    fit: BoxFit.cover),
                              ),
                              SizedBox(width: screenWidth * 0.03),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.name,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: screenWidth * 0.045,
                                            fontWeight: FontWeight.bold)),
                                    Text(item.description,
                                        style: TextStyle(
                                            color: Colors.white54,
                                            fontSize: screenWidth * 0.035)),
                                    Text("RS ${item.price}",
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: screenWidth * 0.04)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: -15,
                            right: -10,
                            child: IconButton(
                              icon: Icon(Icons.delete, color: Colors.white),
                              onPressed: () => cartController.removeItem(index),
                            ),
                          ),
                          Positioned(
                            bottom: -12,
                            right: -10,
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove_circle,
                                      color: Colors.white),
                                  onPressed: () =>
                                      cartController.decreaseQuantity(index),
                                ),
                                Text("${item.quantity}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.04)),
                                IconButton(
                                  icon: Icon(Icons.add_circle,
                                      color: Colors.white),
                                  onPressed: () =>
                                      cartController.increaseQuantity(index),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )),
            SizedBox(height: screenHeight * 0.02),
            _buildCartSummary(screenWidth),
            _buildCheckoutButton(context, screenWidth),
          ],
        ),
      ),
    );
  }

  Widget _buildCartSummary(double screenWidth) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 8),
      color: Color(0xff570101),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPriceRow("Cart Total", cartController.cartTotal),
            _buildPriceRow("Tax", cartController.tax),
            _buildPriceRow("Delivery Charges", cartController.deliveryCharges),
            _buildPriceRow("Discount", -cartController.discount),
            Divider(color: Colors.white),
            _buildPriceRow("Sub Total", cartController.subTotal, isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.white)),
          Text("RS ${value.toStringAsFixed(2)}",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton(BuildContext context, double screenWidth) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff570101),
          padding: EdgeInsets.symmetric(vertical: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => checkoutScreen()));
        },
        child: SizedBox(
          width: double.infinity,
          child: Center(
            child: Text("Proceed To Checkout",
                style: TextStyle(
                    fontSize: screenWidth * 0.045, color: Colors.white)),
          ),
        ),
      ),
    );
  }
}

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;

  double get cartTotal =>
      cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  double get tax => 250.0;
  double get discount => 150.0;
  double get deliveryCharges => 100.0;
  double get subTotal => cartTotal + tax + deliveryCharges - discount;

  void increaseQuantity(int index) {
    cartItems[index].quantity++;
    cartItems.refresh();
  }

  void decreaseQuantity(int index) {
    if (cartItems[index].quantity > 1) {
      cartItems[index].quantity--;
    } else {
      cartItems.removeAt(index);
    }
    cartItems.refresh();
  }

  void removeItem(int index) {
    cartItems.removeAt(index);
    cartItems.refresh();
  }

  void addSampleProducts() {
    cartItems.addAll([
      CartItem(
        name: "Burger",
        image: "assets/burger.png",
        price: 500,
        description: "Delicious chicken burger",
      ),
      CartItem(
        name: "Pizza",
        image: "assets/largepizza.png",
        price: 800,
        description: "Cheesy Italian pizza",
      ),
      CartItem(
        name: "Cold Drink",
        image: "assets/colddrink.png",
        price: 700,
        description: "cold drink fantasy",
      ),
      CartItem(
        name: "Fries",
        image: "assets/fries.png",
        price: 300,
        description: "Crispy French fries",
      ),
      CartItem(
        name: "Ice Cream",
        image: "assets/icecream.png",
        price: 400,
        description: "Chocolate Ice cream",
      ),
    ]);
  }
}

class CartItem {
  final String name;
  final String image;
  final double price;
  final String description;
  int quantity;

  CartItem({
    required this.name,
    required this.image,
    required this.price,
    required this.description,
    this.quantity = 1,
  });
}
