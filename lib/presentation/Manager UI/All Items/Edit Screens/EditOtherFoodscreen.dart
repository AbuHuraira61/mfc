import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditOtherFoodScreen extends StatefulWidget {
  final QueryDocumentSnapshot item;
  final String category; // Category (Burger, Others, Deals)

  EditOtherFoodScreen({super.key, required this.item, required this.category});

  @override
  _EditOtherFoodScreenState createState() => _EditOtherFoodScreenState();
}

class _EditOtherFoodScreenState extends State<EditOtherFoodScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item["name"]);
    _descriptionController =
        TextEditingController(text: widget.item["description"]);
    _priceController =
        TextEditingController(text: widget.item["price"].toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _updateFoodItem() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance
          .collection("food_items")
          .doc(widget.category) // Use category as document ID (Burger, Others, Deals)
          .collection("items")
          .doc(widget.item.id)
          .update({
        "name": _nameController.text,
        "description": _descriptionController.text,
        "price": double.parse(_priceController.text),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${widget.category} item updated successfully!")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit ${widget.category} Item"),
        backgroundColor: Color(0xFF570101),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "${widget.category} Name"),
                  validator: (value) =>
                      value!.isEmpty ? "Enter ${widget.category} name" : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: "Description"),
                  validator: (value) =>
                      value!.isEmpty ? "Enter description" : null,
                ),
                SizedBox(height: 10),
                Text("Price", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: "Price"),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? "Enter price" : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updateFoodItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF570101),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Center(
                    child: Text(
                      "Update ${widget.category}",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
