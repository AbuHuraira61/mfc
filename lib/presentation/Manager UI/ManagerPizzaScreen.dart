import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManagerPizzaScreen extends StatelessWidget {
  ManagerPizzaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pizza",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
        backgroundColor: Color(0xFFF0F0F0),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Padding(
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
                var item = pizzaItems[index].data() as Map<String, dynamic>;
                String docId = pizzaItems[index].id; // Firestore document ID

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
                              item["name"] ?? "No Name",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              item["description"] ?? "No Description",
                              style:
                                  TextStyle(color: Colors.green, fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6),
                            Text(
                              "RS ${item["price"] ?? '0.00'}",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          // Edit button
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _editItem(context, docId, item);
                            },
                          ),
                          // Delete button
                          IconButton(
                            icon: Icon(Icons.delete_outline, color: Colors.green),
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection("food_items")
                                  .doc("Pizza")
                                  .collection("items")
                                  .doc(docId)
                                  .delete();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  /// Open Edit Dialog to update item details
  void _editItem(BuildContext context, String docId, Map<String, dynamic> item) {
    TextEditingController nameController = TextEditingController(text: item["name"]);
    TextEditingController descriptionController = TextEditingController(text: item["description"]);
    TextEditingController priceController = TextEditingController(text: item["price"].toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Pizza Item"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: "Description"),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Cancel", style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("Save", style: TextStyle(color: Colors.green)),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection("food_items")
                    .doc("Pizza")
                    .collection("items")
                    .doc(docId)
                    .update({
                  "name": nameController.text,
                  "description": descriptionController.text,
                  "price": priceController.text,
                  "timestamp": FieldValue.serverTimestamp(),
                });

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  /// Decode Base64 Image (if stored as a Base64 string)
  Uint8List _decodeBase64Image(String base64String) {
    return base64Decode(base64String);
  }
}
