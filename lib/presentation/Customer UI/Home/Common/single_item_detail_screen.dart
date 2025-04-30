import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:mfc/Helper/cart_provider.dart';
import 'package:mfc/Helper/db_helper.dart';
import 'package:mfc/Models/cart_model.dart';
import 'package:mfc/Utilities/ImageDecoder.dart';
import 'package:mfc/presentation/Customer UI/Home/Cart/Cart_screen.dart';

class SingleItemDetailScreen extends StatefulWidget {
  final Map<String, dynamic> singleBurger;
  const SingleItemDetailScreen({Key? key, required this.singleBurger}) : super(key: key);

  @override
  _SingleItemDetailScreenState createState() => _SingleItemDetailScreenState();
}

class _SingleItemDetailScreenState extends State<SingleItemDetailScreen> {
  final DBHelper _dbHelper = DBHelper();
  int quantity = 1;

  void increaseQuantity() => setState(() => quantity++);
  void decreaseQuantity() {
    if (quantity > 1) setState(() => quantity--);
  }

  Future<void> _addToCart() async {
    final cartProv = Provider.of<CartProvider>(context, listen: false);
    final uniqueId = '${widget.singleBurger['id']}';
    final double price = double.tryParse(widget.singleBurger['price'].toString()) ?? 0.0;
    final model = Cart(
      id: uniqueId,
      image: widget.singleBurger['image'],
      initialPrice: price,
      productName: widget.singleBurger['name'],
      productPrice: price * quantity,
      quantity: quantity,
    );

    try {
      await _dbHelper.insert(model);
      await cartProv.getData();
      Get.snackbar('Success!', 'Product added to cart');
      Get.off(() => CartScreen());
    } catch (e) {
      Get.snackbar('Error!', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final double price = double.tryParse(widget.singleBurger['price'].toString()) ?? 0.0;

    return Scaffold(
      backgroundColor: const Color(0xff570101),
      body: Column(
        children: [
          // Image & Top Bar
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 70),
                height: screenHeight * 0.42,
                width: double.infinity,
                color: const Color(0xff570101),
                child: Center(
                  child: widget.singleBurger['image'] != null && widget.singleBurger['image'].isNotEmpty
                      ? Image.memory(
                          decodeImage(widget.singleBurger['image']),
                          height: 200,
                        )
                      : Image.asset(
                          'assets/default-food.png',
                          width: 80,
                          height: 80,
                        ),
                ),
              ),
              Positioned(
                top: 50,
                left: 20,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pop(context),
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
                    icon: const Icon(Icons.favorite_border, color: Colors.red, size: 24),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),

          // Details
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xff570101),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.star, color: Colors.yellow, size: 20),
                              SizedBox(width: 5),
                              Text('4.8', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Name & Description
                    Text(widget.singleBurger['name'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(widget.singleBurger['description'] ?? '', style: const TextStyle(color: Colors.black54)),
                    const SizedBox(height: 12),

                    // Price Display
                    Text('Price: RS ${price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),

                    // Quantity & Add Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            _buildQtyButton(Icons.remove, decreaseQuantity),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text('$quantity', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                            _buildQtyButton(Icons.add, increaseQuantity),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: _addToCart,
                          icon: const Icon(Icons.shopping_cart, size: 18, color: Colors.white),
                          label: const Text('Add To Cart', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff570101),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyButton(IconData icon, VoidCallback onTap) {
    return Container(
      height: 28,
      width: 28,
      decoration: const BoxDecoration(color: Color(0xff570101), shape: BoxShape.circle),
      child: IconButton(
        icon: Icon(icon, size: 16, color: Colors.white),
        onPressed: onTap,
        padding: EdgeInsets.zero,
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mfc/Helper/cart_provider.dart';
// import 'package:mfc/Helper/db_helper.dart';
// import 'package:mfc/Models/cart_model.dart';
// import 'package:mfc/presentation/Customer%20UI/Home/Cart/Cart_screen.dart';
// import 'package:provider/provider.dart';

// class SingleItemDetailScreen extends StatefulWidget {
//   final Map<String, dynamic> singleBurger;
//   const SingleItemDetailScreen({super.key,required this.singleBurger});


//   @override
//   _SingleItemDetailScreenState createState() => _SingleItemDetailScreenState();
// }

// class _SingleItemDetailScreenState extends State<SingleItemDetailScreen> {
//    final DBHelper _dbHelper = DBHelper();
//   String selectedVariation = "Small";
//   int quantity = 1;
//   Map<String, double> variationPrices = {
//     "Extra Dip Sauce": 100.0,
//     "Cheese Petty": 150.0,
//     "Double Petty": 500.0,
//   };

//   void increaseQuantity() {
//     setState(() {
//       quantity++;
//     });
//   }

//   void decreaseQuantity() {
//     if (quantity > 1) {
//       setState(() {
//         quantity--;
//       });
//     }
//   }

//   void selectVariation(String variation) {
//     setState(() {
//       selectedVariation = variation;
//     });
//   }

//    Future<void> _addToCart() async {
//     final cartProv = Provider.of<CartProvider>(context, listen: false);
//     final uniqueId = '${widget.singleBurger['id']}_$selectedVariation';
//     final price = widget.singleBurger['price']!;
//     final model = Cart(
//       id: uniqueId,
//       image: widget.singleBurger['image'],
//       initialPrice: price,
//       productName: widget.singleBurger['name'],
//       productPrice: price * quantity,
//       quantity: quantity,
//     );

//     try {
//       await _dbHelper.insert(model);
//       await cartProv.getData();
//       Get.snackbar('Success!', 'Product added to cart');
//       Get.off(() => CartScreen());
//     } catch (e) {
//       Get.snackbar('Error!', e.toString());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: const Color(0xff570101),
//       body: Column(
//         children: [
//           Stack(
//             children: [
//               Container(
//                 padding: const EdgeInsets.only(top: 70),
//                 height: screenHeight * 0.42,
//                 width: double.infinity,
//                 decoration: const BoxDecoration(color: Color(0xff570101)),
//                 child: Center(
//                   child: Image.asset('assets/beefburger.png', height: 200),
//                 ),
//               ),
//               Positioned(
//                 top: 50,
//                 left: 20, // Added back button on the left
//                 child: IconButton(
//                   icon: const Icon(Icons.arrow_back,
//                       color: Colors.white, size: 28),
//                   onPressed: () {
//                     Navigator.pop(context); // Go back to the previous screen
//                   },
//                 ),
//               ),
//               Positioned(
//                 top: 50,
//                 right: 20,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.white.withOpacity(0.9),
//                   ),
//                   child: IconButton(
//                     icon: const Icon(Icons.favorite_border,
//                         color: Colors.red, size: 24),
//                     onPressed: () {},
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 15),
//             child: Container(
//               height: screenHeight * 0.56,
//               width: double.infinity,
//               padding: const EdgeInsets.only(
//                   top: 30, left: 20, right: 20, bottom: 12),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(50),
//                   topRight: Radius.zero,
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 6, vertical: 3),
//                         width: 70,
//                         height: 35,
//                         decoration: BoxDecoration(
//                           color: const Color(0xff570101),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Row(
//                           children: const [
//                             Icon(Icons.star, color: Colors.yellow, size: 20),
//                             SizedBox(width: 5),
//                             Text("4.8",
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold)),
//                           ],
//                         ),
//                       ),
//                        Text(widget.singleBurger['price'],
//                           style: TextStyle(
//                               fontSize: 22, fontWeight: FontWeight.bold)),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                    Text(widget.singleBurger['name'],
//                         style: const TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 6),
//                    Text(widget.singleBurger['description'] ?? '',
//                         style: const TextStyle(color: Colors.black54)),
//                    SizedBox(height: Get.height*0.28),
                  
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Container(
//                             height: 28,
//                             width: 28,
//                             decoration: const BoxDecoration(
//                               color: Color(0xff570101),
//                               shape: BoxShape.circle,
//                             ),
//                             child: IconButton(
//                               icon: const Icon(Icons.remove,
//                                   color: Colors.white, size: 16),
//                               onPressed: decreaseQuantity,
//                               padding: EdgeInsets.zero,
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Text("$quantity",
//                               style: const TextStyle(
//                                   fontSize: 16, fontWeight: FontWeight.bold)),
//                           const SizedBox(width: 12),
//                           Container(
//                             height: 28,
//                             width: 28,
//                             decoration: const BoxDecoration(
//                               color: Color(0xff570101),
//                               shape: BoxShape.circle,
//                             ),
//                             child: IconButton(
//                               icon: const Icon(Icons.add,
//                                   color: Colors.white, size: 16),
//                               onPressed: increaseQuantity,
//                               padding: EdgeInsets.zero,
//                             ),
//                           ),
//                         ],
//                       ),
//                       ElevatedButton.icon(
//                         onPressed: _addToCart,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xff570101),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10)),
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 14, vertical: 0),
//                         ),
//                         icon: const Icon(Icons.shopping_cart,
//                             color: Colors.white, size: 18),
//                         label: const Text("Add To Cart",
//                             style:
//                                 TextStyle(color: Colors.white, fontSize: 14)),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


