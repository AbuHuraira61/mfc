import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mfc/presentation/Manager%20UI/All%20Items/Edit%20Screens/EditOtherFoodscreen.dart';
import 'dart:convert';
import 'dart:typed_data';

import 'package:mfc/presentation/Manager%20UI/All%20Items/Edit%20Screens/EditPizzaScreen.dart';

class AllAddedItemScreen extends StatefulWidget {
  const AllAddedItemScreen({super.key});

  @override
  State<AllAddedItemScreen> createState() => _AllAddedItemScreenState();
}

class _AllAddedItemScreenState extends State<AllAddedItemScreen> {
  String _selectedPizzaType = 'Standard';
    String _selectedOtherType = 'Fries';

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
            buildPizzaList(),
            buildFoodList("Burger"),
            buildOtherList(_selectedOtherType),
            buildFoodList("Deals"),
          ],
        ),
      ),
    );
  }

  /// **Build Pizza List (with type selection)**
  Widget buildPizzaList() {
    return Column(
      children: [
        // Pizza Type Selection Dropdown
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField(
            value: _selectedPizzaType,
            items: ['Standard', 'Premium', 'New Addition', 'Matka Pizza']
                .map(
                  (type) => DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedPizzaType = value!;
              });
            },
          ),
        ),
        SizedBox(height: 10),

        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("food_items")
                .doc("Pizza")
                .collection("items")
                .where("pizzaType", isEqualTo: _selectedPizzaType)
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
                  return buildFoodCard(item, "Pizza");
                },
              );
            },
          ),
        ),
      ],
    );
  }

// Build "Other" list
Widget buildOtherList(String _category) {
    return Column(
      children: [
        // Pizza Type Selection Dropdown
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField(
            value: _selectedOtherType,
            items: ['Fries', 'Chicken Roll', 'Hot Wings', 'Pasta', 'Sandwich', 'Broast Chicken']
                .map(
                  (type) => DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedOtherType = value!;
              });
            },
          ),
        ),
        SizedBox(height: 10),

        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("food_items")
                .doc(_selectedOtherType)
                .collection("items")
                .orderBy("timestamp", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text("No ${_selectedOtherType} Available",
                      style: TextStyle(fontSize: 16, color: Colors.green)),
                );
              }

              var otherItems = snapshot.data!.docs;
              return ListView.builder(
                itemCount: otherItems.length,
                itemBuilder: (context, index) {
                  final item = otherItems[index];
                  return buildFoodCard(item, _category);
                },
              );
            },
          ),
        ),
      ],
    );
  }
  /// **Build  Food Categories (Burger, Deals)**
  Widget buildFoodList(String category) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("food_items")
          .doc(category)
          .collection("items")
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text("No $category Items Available",
                style: TextStyle(fontSize: 16, color: Colors.green)),
          );
        }

        var foodItems = snapshot.data!.docs;
        return ListView.builder(
          itemCount: foodItems.length,
          itemBuilder: (context, index) {
            final item = foodItems[index];
            return buildFoodCard(item, category);
          },
        );
      },
    );
  }

  /// **Build Food Item Card**
  Widget buildFoodCard(QueryDocumentSnapshot item, String category) {
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

                /// **Do NOT Show Price for Pizza**
                category == "Pizza"
                    ? SizedBox() // Don't show prices in the list
                    : Text(
                        "Price: ${item["price"]}",
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
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  editItem(item, category);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.white),
                onPressed: () {
                  deleteItem(item, category);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// **Edit Functionality**
  void editItem(QueryDocumentSnapshot item, String category) {
    print("Editing item: ${item.id} from $category");

    if (category == "Pizza") {
      // Open edit screen for pizza where user can edit all 4 prices
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditPizzaScreen(item),
        ),
      );
    } else {
      // Open edit screen for other categories with one price
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditOtherFoodScreen(item: item, category: category,),
        ),
      );
    }
  }

  /// **Delete Functionality**
  void deleteItem(QueryDocumentSnapshot item, String category) {
    FirebaseFirestore.instance
        .collection("food_items")
        .doc(category)
        .collection("items")
        .doc(item.id)
        .delete()
        .then((_) {
      print("Deleted item: ${item.id} from $category");
    }).catchError((error) {
      print("Error deleting item: $error");
    });
  }

   void deleteOtherItem(QueryDocumentSnapshot item, String otherCategory) {
    FirebaseFirestore.instance
        .collection("food_items")
        .doc(otherCategory)
        .collection("items")
        .doc(item.id)
        .delete()
        .then((_) {
      print("Deleted item: ${item.id} from $otherCategory");
    }).catchError((error) {
      print("Error deleting item: $error");
    });
  }

  /// **Decode Base64 Image**
  Uint8List _decodeBase64Image(String base64String) {
    return base64Decode(base64String);
  }
}
