import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mfc/Constants/colors.dart';
import 'package:mfc/Helper/cart_provider.dart';
import 'package:mfc/Helper/db_helper.dart';
import 'package:mfc/Models/cart_model.dart';
import 'package:mfc/Services/image_service.dart';
import 'package:mfc/presentation/Customer%20UI/ChekoutScreens/checkoutScreen.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:typed_data';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final DBHelper _dbHelper = DBHelper();
  final ImageService _imageService = ImageService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CartProvider>(context, listen: false).getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Shopping Cart',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Consumer<CartProvider>(
          builder: (context, cartProv, child) {
            final items = cartProv.cart;
            if (items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    SizedBox(height: 20),
                    Text('Your cart is empty 😌'),
                    SizedBox(height: 20),
                    Text(
                      'Explore products and shop your\nfavourite items',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final cartItem = items[index];

                      return Card(
                        color: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // 🔄 CACHE-ENABLED IMAGE LOADER
                                  FutureBuilder<Uint8List?>(
                                    future: cartItem.image != null
                                        ? ImageService.decodeBase64(
                                            cartItem.id!, cartItem.image!)
                                        : Future.value(null),
                                    builder: (context, snap) {
                                      if (snap.connectionState !=
                                          ConnectionState.done) {
                                        return const SizedBox(
                                          width: 62,
                                          height: 62,
                                          child: Center(
                                            child:
                                                CircularProgressIndicator(),
                                          ),
                                        );
                                      }
                                      final imageBytes = snap.data;
                                      if (imageBytes != null &&
                                          imageBytes.isNotEmpty) {
                                        return ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.memory(
                                            imageBytes,
                                            width: 62,
                                            height: 62,
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      }
                                      return const Icon(
                                        Icons.image_not_supported,
                                        size: 62,
                                        color: Colors.white,
                                      );
                                    },
                                  ),

                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cartItem.productName ?? '',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Rs ${cartItem.productPrice!.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 10, right: 2.0),
                                    child: IconButton(
                                      onPressed: () async {
                                        await _dbHelper.delete(cartItem.id!);
                                        await cartProv.getData();
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _circleIconButton(
                                      icon: Icons.remove,
                                      onTap: () async {
                                        if (cartItem.quantity! > 1) {
                                          final newQty = cartItem.quantity! -
                                              1;
                                          final newPrice = cartItem
                                                  .initialPrice! *
                                              newQty;
                                          await _dbHelper.updateQuantity(
                                            Cart(
                                              id: cartItem.id!,
                                              productName:
                                                  cartItem.productName!,
                                              initialPrice:
                                                  cartItem.initialPrice!,
                                              productPrice: newPrice,
                                              quantity: newQty,
                                              image: cartItem.image!,
                                            ),
                                          );
                                          await cartProv.getData();
                                        }
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Text(
                                        cartItem.quantity.toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16),
                                      ),
                                    ),
                                    _circleIconButton(
                                      icon: Icons.add,
                                      onTap: () async {
                                        final newQty =
                                            cartItem.quantity! + 1;
                                        final newPrice = cartItem
                                                .initialPrice! *
                                            newQty;
                                        await _dbHelper.updateQuantity(
                                          Cart(
                                            id: cartItem.id!,
                                            productName:
                                                cartItem.productName!,
                                            initialPrice:
                                                cartItem.initialPrice!,
                                            productPrice: newPrice,
                                            quantity: newQty,
                                            image: cartItem.image!,
                                          ),
                                        );
                                        await cartProv.getData();
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                if (cartProv.totalPrice > 0)
                  Column(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        color: primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              // ReusableWidget(
                              //   title: 'Sub Total',
                              //   value:
                              //       'Rs ${cartProv.totalPrice.toStringAsFixed(2)}',
                              // ),
                              // ReusableWidget(
                              //   title: 'Discount 5%',
                              //   value:
                              //       'Rs ${(cartProv.totalPrice * 0.05).toStringAsFixed(2)}',
                              // ),
                              ReusableWidget(
                                title: 'Total',
                                value:
                                    'Rs ${(cartProv.totalPrice * 0.95).toStringAsFixed(2)}',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: primaryColor,
                          ),
                          onPressed: () {
                            Get.off(checkoutScreen(
                                totalPrice: cartProv.totalPrice));
                          },
                          child: const Text(
                            'Proceed to Checkout',
                            style: TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _circleIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(5),
        child: Icon(
          icon,
          size: 10,
          color: primaryColor,
        ),
      ),
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  const ReusableWidget({required this.title, required this.value, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white)),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}





























// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:mfc/Constants/colors.dart';
// import 'package:mfc/Helper/cart_provider.dart';
// import 'package:mfc/Helper/db_helper.dart';
// import 'package:mfc/Models/cart_model.dart';
// import 'package:provider/provider.dart';

// class CartScreen extends StatefulWidget {
//   @override
//   State<CartScreen> createState() => _CartScreenState();
// }

// class _CartScreenState extends State<CartScreen> {
//   CartProvider _sharedData = CartProvider();
//   DBHelper _dbHelper = DBHelper();

    



//   Uint8List _decodeImage(String base64String) {
//     return Base64Decoder().convert(base64String);
//   }
   
  
   

//    @override
//   void initState() {
//     super.initState(); 
  
  
//     // ✅ Fetch once and reuse
//   }

//   @override
//   Widget build(BuildContext context) {
//      print("🔄 CartScreen is rebuilding...");
//     final cart = Provider.of<CartProvider>(context);

//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Cart Screen", style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//         backgroundColor: Color(0xff570101),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             FutureBuilder(
//               future: cart.getData(),  // Use provider's future
//               builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
//                 print("Connection state: ${snapshot.connectionState}");
//                 print("Has Data: ${snapshot.hasData}");
//                 print("Data: ${snapshot.data}");

//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } 
//                 else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return Center(child: Text('No items in cart!'));
//                 } 
//                 else {
//                   return ListView.builder(
                    
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     itemCount: snapshot.data!.length,
//                     itemBuilder: (context, index) {
//                       final cartItem = snapshot.data![index];

//                       return Container(
//                         margin: EdgeInsets.symmetric(vertical: 8, horizontal: screenWidth * 0.04),
//                         padding: EdgeInsets.all(screenWidth * 0.03),
//                         decoration: BoxDecoration(
//                           color: Color(0xff570101),
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         child: Stack(
//                           children: [
//                             Row(
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(10),
//                                   child: Image.memory(
//                                     _decodeImage(cartItem.image as String),
//                                     width: screenWidth * 0.225,
//                                     height: screenWidth * 0.210,
//                                     fit: BoxFit.cover
//                                   ),
//                                 ),
//                                 SizedBox(width: screenWidth * 0.03),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(cartItem.productName as String ,
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: screenWidth * 0.045,
//                                               fontWeight: FontWeight.bold)),
//                                       Text("RS ${cartItem.productPrice}",
//                                           style: TextStyle(
//                                               color: Colors.white70,
//                                               fontSize: screenWidth * 0.04)),
                                  
//                                     ],
                                    
//                                   ),
//                                 ),
//                                 SizedBox(width: screenWidth * 0.03),
//                                 Column(
//                                   children: [
//                                     IconButton(
//                                       onPressed: (){
//                                         // String expectedId = snapshot.data![index].id as String;
//                                         // String alternateId = expectedId + snapshot.data![index].productPrice.toString();
//                                              // Check if the cart item ID is null before proceeding
//                                         String? cartItemId = snapshot.data![index].id;
                                    
//                                         // If cartItemId is not null, proceed with deletion
//                                         if (cartItemId != null) {
//                                           _dbHelper.delete(cartItemId); // Delete the item by unique ID
//                                           cart.removeCounter(); // Update cart counter
//                                           cart.removeTotalPrice(snapshot.data![index].productPrice as double); // Update total price
//                                           cart.getData(); // Reload cart data
//                                           setState(() {}); // Refresh the screen
//                                         } else {
//                                           // Handle the case where cartItemId is null, if necessary
//                                           print("Error: Cart item ID is null");
//                                         }
//                                       },
//                                      icon: Icon(Icons.delete, color: secondaryColor,)),
//                                      Row(children: [
                                      
//                                        IconButton(onPressed: (){
                                                 
                                                
                                                 
//                                                     int Quantity = snapshot.data![index].quantity!;
//                                                  double price = snapshot.data![index].initialPrice!;
//                                                    if(Quantity > 1){
                                                    
//  Quantity--;
//                                                  double? newPrice = price * Quantity;
//                                                  _dbHelper.updateQuantity(
//                                                   Cart(
//                                                     id: snapshot.data![index].id, 
//                                                   image: snapshot.data![index].image, 
//                                                   initialPrice: snapshot.data![index].initialPrice, 
//                                                   productName: snapshot.data![index].productName, 
//                                                   productPrice: newPrice, 
//                                                   quantity: Quantity)
//                                                  ).then( (value) {
//                                                    newPrice = 0;
//                                                    Quantity = 0;
//                                                    cart.removeTotalPrice(snapshot.data![index].initialPrice!);
//                                                  },).onError((error, stackTrace) {
//                                                    print(error.toString());
//                                                  },);
//                                                    }
//                                                  }, icon: Icon(Icons.remove, color: secondaryColor,)),
 


//                                        Text(snapshot.data![index].quantity.toString(),style: TextStyle(color: secondaryColor),),
//                                        IconButton(onPressed: (){
                                               
//                                                    int Quantity = snapshot.data![index].quantity!;
//                                                  double price = snapshot.data![index].initialPrice!;

//                                                  Quantity++;
//                                                  double? newPrice = price * Quantity;
//                                                  _dbHelper.updateQuantity(
//                                                   Cart(
//                                                     id: snapshot.data![index].id, 
//                                                   image: snapshot.data![index].image, 
//                                                   initialPrice: snapshot.data![index].initialPrice, 
//                                                   productName: snapshot.data![index].productName, 
//                                                   productPrice: newPrice, 
//                                                   quantity: Quantity)
//                                                  ).then( (value) {
//                                                    newPrice = 0;
//                                                    Quantity = 0;
//                                                    cart.addTotalPrice(snapshot.data![index].initialPrice!);
//                                                  },).onError((error, stackTrace) {
//                                                    print(error.toString());
//                                                  },
//                                                 );
                                                 

//                                        }, icon: Icon(Icons.add, color: secondaryColor,)),
//                                      ],),
                                   
                                
//                                   ],
//                                 )

//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   );
//                 }
//               },
//             ),
//             SizedBox(height: screenHeight * 0.02),
//              _buildCartSummary(screenWidth, _sharedData),
//             //  Consumer<CartProvider>(builder: (context, value, child){
//             //   return Visibility(
//             //     visible: value.getTotalPrice().toStringAsFixed(2) == "0.00" ? false : true,
//             //     child: Column(
//             //       children: [
//             //         ReusableWidget(title: 'Sub Total', value: r'$'+value.getTotalPrice().toStringAsFixed(2),),
//             //         ReusableWidget(title: 'Discout 5%', value: r'$'+'20',),
//             //         ReusableWidget(title: 'Total', value: r'$'+value.getTotalPrice().toStringAsFixed(2),)
//             //       ],
//             //     ),
//             //   );
//             // }),
//             _buildCheckoutButton(context, screenWidth),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCartSummary(double screenWidth, CartProvider cart) {
//     return Card(
//       margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 8),
//       color: Color(0xff570101),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildPriceRow("Cart Total", cart.getTotalPrice()),
//             _buildPriceRow("Tax", 0.0),
//             _buildPriceRow("Delivery Charges", 0.0),
//             _buildPriceRow("Discount", 0.0),
//             Divider(color: Colors.white),
//             _buildPriceRow("Sub Total", 0.0, isBold: true),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPriceRow(String label, double value, {bool isBold = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: TextStyle(color: Colors.white)),
//           Text("RS ${value.toStringAsFixed(2)}",
//               style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
//         ],
//       ),
//     );
//   }

//   Widget _buildCheckoutButton(BuildContext context, double screenWidth) {
//     return Padding(
//       padding:
//           EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 10),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Color(0xff570101),
//           padding: EdgeInsets.symmetric(vertical: 15),
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//         onPressed: () {},
//         child: SizedBox(
//           width: double.infinity,
//           child: Center(
//             child: Text("Proceed To Checkout",
//                 style: TextStyle(
//                     fontSize: screenWidth * 0.045, color: Colors.white)),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ReusableWidget extends StatelessWidget {
//   final String title , value ;
//   const ReusableWidget({required this.title, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(title,),
//           Text(value.toString(),)
//         ],
//       ),
//     );
//   }
// }