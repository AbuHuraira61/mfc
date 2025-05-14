import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mfc/Utilities/ImageDecoder.dart';
import 'package:mfc/presentation/Customer%20UI/Home/Common/Singlepizza_screen.dart';
import 'package:mfc/presentation/Customer%20UI/Home/Common/single_item_detail_screen.dart';

class FavouritePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = _auth.currentUser;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Favorite Page",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Color(0xFF6A0202),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('favorites')
              .where('uid', isEqualTo: currentUser?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError)
              return Center(child: Text('Something went wrong'));
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());

            final favorites = snapshot.data!.docs;

            if (favorites.isEmpty) {
              return Center(child: Text("No favorite items found."));
            }

            return GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final data = favorites[index].data() as Map<String, dynamic>;
                
                return GestureDetector(
                  onTap: () {
                    // Check if it's a pizza by looking for 'prices' field
                    if (data.containsKey('prices')) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SinglePizzaScreen(
                            singlePizza: data,
                          ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SingleItemDetailScreen(
                            singleBurger: data,
                          ),
                        ),
                      );
                    }
                  },
                  child: FavoriteItemCard(foodItem: data),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class FavoriteItemCard extends StatefulWidget {
  final Map<String, dynamic> foodItem;

  const FavoriteItemCard({Key? key, required this.foodItem}) : super(key: key);

  @override
  State<FavoriteItemCard> createState() => _FavoriteItemCardState();
}

class _FavoriteItemCardState extends State<FavoriteItemCard> {
  bool isFavorite = true; // Always true since it's in favorites
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> toggleFavorite() async {
    final user = _auth.currentUser;
    if (user == null) return;

    setState(() {
      isFavorite = !isFavorite;
    });

    if (!isFavorite) {
      // Remove from favorites
      await FirebaseFirestore.instance
          .collection('favorites')
          .doc(widget.foodItem['itemId'])
          .delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xff570101),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child:
                  widget.foodItem['image']!=null && widget.foodItem['image'].isNotEmpty?
                   Image.memory(decodeImage(widget.foodItem['image']),
                      fit: BoxFit.cover, height: 100, width: 100):
                       Image.asset(
                  "assets/default-food.png",
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.foodItem['name'] ?? "Food Item",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Display price based on item type
                        if (widget.foodItem.containsKey('prices'))
                          Text(
                            'From \$${widget.foodItem['prices']['small']}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        else
                          Text(
                            '\$${widget.foodItem['price']}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        Icon(Icons.shopping_cart, color: Colors.white, size: 24),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          child: GestureDetector(
            onTap: toggleFavorite,
            child: Icon(
              Icons.favorite,
              color: Colors.red,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}

// class FavouritePage extends StatelessWidget {
//   final List<Map<String, dynamic>> favoriteItems = List.generate(
//     10,
//     (index) => {
//       "name": "Pizza",
//       "description": "Spicy pizza gladiola is a fan",
//       "price": "RS 1050.00",
//       "image": "assets/pizza-pic.png",
//       "quantity": 2,
//     },
//   );

//   FavouritePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(

//         title: Text(
//           "Favorite Page",
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         backgroundColor: Color(0xFF6A0202),

//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             if (Navigator.canPop(context)) {
//               Navigator.pop(context);
//             }
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Your Favorite Food is here",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: favoriteItems.length,
//                 itemBuilder: (context, index) {
//                   final item = favoriteItems[index];
//                   return Container(
//                     margin: EdgeInsets.only(bottom: 10),
//                     padding: EdgeInsets.all(12),
//                     decoration: BoxDecoration(

//                       gradient: LinearGradient(
//                         colors: [
//                           Color(0xFF570101), // Dark Red
//                           Color(0xFF750202), // Slightly lighter red
//                         ],
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                       ),

//                       color: Color(0xFF570101),

//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: Image.asset(
//                             item["image"],
//                             width: 80,
//                             height: 80,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         SizedBox(width: 12),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 item["name"],
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               SizedBox(height: 4),
//                               Text(
//                                 item["description"],
//                                 style: TextStyle(
//                                     color: Colors.white70, fontSize: 12),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               SizedBox(height: 6),
//                               Text(
//                                 item["price"],
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             SizedBox(width: 5),
//                             GestureDetector(
//                               onTap: () {},
//                               child: Icon(Icons.delete_outline,
//                                   color: Colors.white),
//                             ),
//                             SizedBox(height: 20),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 GestureDetector(
//                                   onTap: () {},
//                                   child: Icon(Icons.add_circle,
//                                       color: Colors.white),
//                                 ),
//                                 SizedBox(width: 5),
//                                 Text(
//                                   item["quantity"].toString(),
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 SizedBox(width: 5),
//                                 GestureDetector(
//                                   onTap: () {},
//                                   child: Icon(Icons.remove_circle,
//                                       color: Colors.white),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
