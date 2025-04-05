// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:mfc/Constants/colors.dart';
// import 'package:mfc/Helper/cart_provider.dart';
// import 'package:mfc/Helper/db_helper.dart';
// import 'package:mfc/Models/cart_model.dart';
// import 'package:provider/provider.dart';

// class CartScrreen extends StatefulWidget {
//   const CartScrreen({super.key});

//   @override
//   State<CartScrreen> createState() => _CartScrreenState();
// }

// class _CartScrreenState extends State<CartScrreen> {
//   DBHelper? dbHelper = DBHelper();
//   List<Cart> cartItems = [];
//   bool isLoading = true;

 

//   @override
//   Widget build(BuildContext context) {
//     final cart = Provider.of<CartProvider>(context);
//     cartItems = cart.getData;
//     return Scaffold(
//       appBar: AppBar(title: Text('Cart Screen')),
//       body: Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: cartItems.length,
//                     itemBuilder: (context, index) {
//                       final cartItem = cartItems[index];

//                       Uint8List? imageBytes;
//                       try {
//                         imageBytes = base64Decode(cartItem.image!);
//                       } catch (e) {
//                         imageBytes = null;
//                       }

//                       return Card(
//                         color: primaryColor,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               imageBytes != null
//                                   ? Image.memory(
//                                       imageBytes,
//                                       width: 80,
//                                       height: 80,
//                                       fit: BoxFit.cover,
//                                     )
//                                   : Icon(
//                                       Icons.image_not_supported,
//                                       size: 80,
//                                       color: Colors.white,
//                                     ),
//                               SizedBox(width: 10),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               cartItem.productName ?? '',
//                                               style: TextStyle(
//                                                 color: secondaryColor,
//                                                 fontSize: 16,
//                                                 fontWeight: FontWeight.w500,
//                                               ),
//                                             ),
//                                             Text(
//                                               cartItem.productPrice.toString(),
//                                               style: TextStyle(
//                                                 color: secondaryColor,
//                                                 fontSize: 16,
//                                                 fontWeight: FontWeight.w500,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         InkWell(
//                                           onTap: () async {
//                                             await dbHelper!.delete(cartItem.id!);
//                                             cart.removeCounter();
//                                             cart.removeTotalPrice(
//                                               double.parse(cartItem.productPrice.toString()),
//                                             );
                                           
//                                           },
//                                           child: Icon(Icons.delete, color: secondaryColor),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(height: 5),
//                                     Align(
//                                       alignment: Alignment.centerRight,
//                                       child: Container(
//                                         height: 35,
//                                         width: 100,
//                                         decoration: BoxDecoration(
//                                           color: primaryColor,
//                                           borderRadius: BorderRadius.circular(5),
//                                         ),
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(4.0),
//                                           child: Row(
//                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               InkWell(
//                                                 onTap: () async {
//                                                   int quantity = cartItem.quantity!;
//                                                   double price = cartItem.initialPrice!;
//                                                   if (quantity > 1) {
//                                                     quantity--;
//                                                     double newPrice = price * quantity;

//                                                     Cart updatedCart = Cart(
//                                                       id: cartItem.id!,
//                                                       productName: cartItem.productName!,
//                                                       initialPrice: cartItem.initialPrice!,
//                                                       productPrice: newPrice,
//                                                       quantity: quantity,
//                                                       image: cartItem.image!,
//                                                     );

//                                                     await dbHelper!.updateQuantity(updatedCart);
//                                                     cart.removeTotalPrice(cartItem.initialPrice!);
                                                   
//                                                   }
//                                                 },
//                                                 child: Icon(Icons.remove, color: Colors.white),
//                                               ),
//                                               Text(
//                                                 cartItem.quantity.toString(),
//                                                 style: TextStyle(color: Colors.white),
//                                               ),
//                                               InkWell(
//                                                 onTap: () async {
//                                                   int quantity = cartItem.quantity!;
//                                                   double price = cartItem.initialPrice!;
//                                                   quantity++;
//                                                   double newPrice = price * quantity;

//                                                   Cart updatedCart = Cart(
//                                                     id: cartItem.id!,
//                                                     productName: cartItem.productName!,
//                                                     initialPrice: cartItem.initialPrice!,
//                                                     productPrice: newPrice,
//                                                     quantity: quantity,
//                                                     image: cartItem.image!,
//                                                   );

//                                                   await dbHelper!.updateQuantity(updatedCart);
//                                                   cart.addTotalPrice(cartItem.initialPrice!);
                                                 
//                                                 },
//                                                 child: Icon(Icons.add, color: Colors.white),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 Consumer<CartProvider>(
//                   builder: (context, value, child) {
//                     return Visibility(
//                       visible: value.getTotalPrice().toStringAsFixed(2) != "0.00",
//                       child: Column(
//                         children: [
//                           ReusableWidget(title: 'Sub Total', value: r'$' + value.getTotalPrice().toStringAsFixed(2)),
//                           ReusableWidget(title: 'Discount 5%', value: r'$' + '20'),
//                           ReusableWidget(title: 'Total', value: r'$' + value.getTotalPrice().toStringAsFixed(2)),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//     );
//   }
// }

// class ReusableWidget extends StatelessWidget {
//   final String title, value;
//   const ReusableWidget({required this.title, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(title),
//           Text(value.toString()),
//         ],
//       ),
//     );
//   }
// }
