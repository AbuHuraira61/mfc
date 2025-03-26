import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:typed_data';

class AllAddedItemScreen extends StatelessWidget {
  const AllAddedItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xFF570101),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('All Added Food Items',
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
          bottom: TabBar(
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            unselectedLabelStyle:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            labelColor: Colors.yellow,
            unselectedLabelColor: Colors.white,
            indicatorColor: Colors.yellow,
            tabs: [
              Tab(text: "Pizza"),
              Tab(text: "Burger"),
              Tab(text: "Others"),
              Tab(text: "Deals"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // buildFoodList('Pizza'),
            // buildFoodList('Burger'),
            // buildFoodList('Fries'),
            buildBurgerList(),
            buildBurgerList(),
            buildBurgerList(),
            buildBurgerList()
          ],
        ),
      ),
    );
  }
}

/*Widget buildFoodList(String category) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('foods')
        .where('category', isEqualTo: category) // Category-wise filter
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Center(child: Text("No items available"));
      }

      var foodItems = snapshot.data!.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      return ListView.builder(
        itemCount: foodItems.length,
        itemBuilder: (context, index) {
          final item = foodItems[index];
          return Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item["image"],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["name"],
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        item["description"],
                        style: TextStyle(color: Colors.green, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6),
                      Text(
                        item["price"],
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.green),
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('foods')
                        .doc(snapshot.data!.docs[index].id)
                        .delete();
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  );
}*/

Widget buildBurgerList() {
  List<Map<String, dynamic>> favoriteItems = List.generate(
    10,
    (index) => {
      "name": "Burger",
      "description": "Spicy burger gladiola is a fan",
      "price": "RS 500.00",
      "image": "assets/burger.png",
      "quantity": 2,
    },
  );

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
              .collection("food_items")
              .doc("Pizza")
              .collection("items")
              .orderBy("timestamp", descending: true)
              .snapshots(),
      builder: (context, snapshot) {
         if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text("No Pizza Items Available",
                    style: TextStyle(fontSize: 16, color: Colors.green)),
              );
            }

            var pizzaItems = snapshot.data!.docs;
        return ListView.builder(
          itemCount: pizzaItems.length,
          itemBuilder: (context, index) {
            final item = pizzaItems[index];
            return Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFF570101),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                        child: item["image"] != null && item["image"].isNotEmpty
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
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item["name"],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          item["description"],
                          style: TextStyle(color: Colors.white, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6),
                        Text(
                          item["price"],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.white), // Edit icon
                        onPressed: () {
                          // Add edit functionality here
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline,
                            color: Colors.white), // Delete icon (moved down)
                        onPressed: () {
                          // Add delete functionality here
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }
    ),
  );
}

  /// Decode Base64 Image (if stored as a Base64 string)
  Uint8List _decodeBase64Image(String base64String) {
    return base64Decode(base64String);
  }
