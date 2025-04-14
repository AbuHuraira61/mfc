import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:typed_data';

class FamilyDeals extends StatefulWidget {
  const FamilyDeals({super.key});

  @override
  _FamilyDealsState createState() => _FamilyDealsState();
}

class _FamilyDealsState extends State<FamilyDeals> {
  Uint8List _decodeBase64Image(String base64String) {
    return base64Decode(base64String);
  }

  void addToCart(Map<String, dynamic> item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${item["name"]} added to cart")),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              "Family Deals",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.05,
                  color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: Color(0xff570101),
            floating: true,
            snap: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            elevation: 0,
          ),
          SliverPadding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            sliver: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('deals')
                  .doc('Family Deals')
                  .collection('deal')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        "No Pizza Deals Available",
                        style: TextStyle(fontSize: 16, color: Colors.green),
                      ),
                    ),
                  );
                }

                final deals = snapshot.data!.docs;

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = deals[index].data() as Map<String, dynamic>;
                      item["quantity"] ??= 1;

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
                                    child: item["image"] != null &&
                                            item["image"].isNotEmpty
                                        ? Image.memory(
                                            _decodeBase64Image(item["image"]),
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            "assets/default-food.png",
                                            width: 80,
                                            height: 80,
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
                                          item["name"] ?? "No Name",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: screenWidth * 0.045,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: screenWidth * 0.01),
                                        Text(
                                          item["description"] ?? "",
                                          style: TextStyle(
                                            color: Colors.grey[300],
                                            fontSize: screenWidth * 0.035,
                                          ),
                                        ),
                                        SizedBox(height: screenWidth * 0.015),
                                        Text(
                                          "Price: ${item["price"]}" ?? "Rs.00",
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
                                top: -2,
                                right: 5,
                                child: GestureDetector(
                                  onTap: () => addToCart(item),
                                  child: Icon(Icons.shopping_cart,
                                      color: Colors.white,
                                      size: screenWidth * 0.06),
                                ),
                              ),
                              Positioned(
                                bottom: -1,
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
                    childCount: deals.length,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// class FamilyDeals extends StatefulWidget {
//   FamilyDeals({super.key});

//   @override
//   _FamilyDealsState createState() => _FamilyDealsState();
// }

// class _FamilyDealsState extends State<FamilyDeals> {
//   List<Map<String, dynamic>> items = List.generate(
//     10,
//     (index) => {
//       "name": "Deal 1",
//       "description":
//           "It's includes a juicy burger, salty fries, and a refreshing drink.",
//       "price": "RS 1050.00",
//       "image": "assets/Deal1.png",
//       "quantity": 1,
//     },
//   );

//   void addToCart(Map<String, dynamic> item) {
//     setState(() {
//       // Handle add to cart logic
//     });
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("${item["name"]} added to cart")),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             title: Text(
//               "Family Deals",
//               style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: screenWidth * 0.05,
//                   color: Colors.white),
//             ),
//             centerTitle: true,
//             backgroundColor: Color(0xff570101),
//             floating: true,
//             snap: true,
//             leading: IconButton(
//               icon: Icon(Icons.arrow_back, color: Colors.white),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//             elevation: 0,
//           ),
//           SliverPadding(
//             padding: EdgeInsets.all(screenWidth * 0.04),
//             sliver: SliverList(
//               delegate: SliverChildBuilderDelegate(
//                 (context, index) {
//                   final item = items[index];
//                   return Container(
//                     margin: EdgeInsets.only(bottom: screenWidth * 0.03),
//                     padding: EdgeInsets.all(screenWidth * 0.03),
//                     decoration: BoxDecoration(
//                       color: Color(0xff570101),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: IntrinsicHeight(
//                       child: Stack(
//                         children: [
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(8),
//                                 child: Image.asset(
//                                   item["image"],
//                                   width: screenWidth * 0.25,
//                                   height: screenWidth * 0.25,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               SizedBox(width: screenWidth * 0.03),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       item["name"],
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: screenWidth * 0.045,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     SizedBox(height: screenWidth * 0.01),
//                                     Text(
//                                       item["description"],
//                                       style: TextStyle(
//                                         color: Colors.grey[300],
//                                         fontSize: screenWidth * 0.035,
//                                       ),
//                                     ),
//                                     SizedBox(height: screenWidth * 0.015),
//                                     Text(
//                                       item["price"],
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: screenWidth * 0.04,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Positioned(
//                             top: -2, // Moves the cart icon up
//                             right: 5,
//                             child: GestureDetector(
//                               onTap: () => addToCart(item),
//                               child: Icon(Icons.shopping_cart,
//                                   color: Colors.white,
//                                   size: screenWidth * 0.06),
//                             ),
//                           ),
//                           Positioned(
//                             bottom: -1, // Moves the quantity icons down
//                             right: 5,
//                             child: Row(
//                               children: [
//                                 GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       if (item["quantity"] > 1) {
//                                         item["quantity"]--;
//                                       }
//                                     });
//                                   },
//                                   child: Icon(Icons.remove_circle,
//                                       color: Colors.white,
//                                       size: screenWidth * 0.06),
//                                 ),
//                                 SizedBox(width: screenWidth * 0.02),
//                                 Text(
//                                   item["quantity"].toString(),
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: screenWidth * 0.045),
//                                 ),
//                                 SizedBox(width: screenWidth * 0.02),
//                                 GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       item["quantity"]++;
//                                     });
//                                   },
//                                   child: Icon(Icons.add_circle,
//                                       color: Colors.white,
//                                       size: screenWidth * 0.05),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//                 childCount: items.length,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
