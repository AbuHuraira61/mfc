import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditPizzaScreen extends StatefulWidget {
  final QueryDocumentSnapshot item;

  EditPizzaScreen(this.item, {super.key});

  @override
  _EditPizzaScreenState createState() => _EditPizzaScreenState();
}

class _EditPizzaScreenState extends State<EditPizzaScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _smallPriceController;
  late TextEditingController _mediumPriceController;
  late TextEditingController _largePriceController;
  late TextEditingController _familyPriceController;

  @override
void initState() {
  super.initState();
  _nameController = TextEditingController(text: widget.item["name"] ?? "");
  _descriptionController = TextEditingController(text: widget.item["description"] ?? "");

  // Explicitly casting data() to a Map<String, dynamic>
  Map<String, dynamic> data = widget.item.data() as Map<String, dynamic>;

  Map<String, dynamic> prices = data.containsKey("prices") ? data["prices"] : {};

  _smallPriceController = TextEditingController(text: prices["small"]?.toString() ?? "");
  _mediumPriceController = TextEditingController(text: prices["medium"]?.toString() ?? "");
  _largePriceController = TextEditingController(text: prices["large"]?.toString() ?? "");
  _familyPriceController = TextEditingController(text: prices["family"]?.toString() ?? "");
}


  

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _smallPriceController.dispose();
    _mediumPriceController.dispose();
    _largePriceController.dispose();
    _familyPriceController.dispose();
    super.dispose();
  }

  void _updatePizza() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance
          .collection("food_items")
          .doc("Pizza")
          .collection("items")
          .doc(widget.item.id)
          .update({
        "name": _nameController.text,
        "description": _descriptionController.text,
        "smallPrice": double.parse(_smallPriceController.text),
        "mediumPrice": double.parse(_mediumPriceController.text),
        "largePrice": double.parse(_largePriceController.text),
        "familyPrice": double.parse(_familyPriceController.text),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pizza updated successfully!")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Pizza Item"),
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
                  decoration: InputDecoration(labelText: "Pizza Name"),
                  validator: (value) =>
                      value!.isEmpty ? "Enter pizza name" : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: "Description"),
                  validator: (value) =>
                      value!.isEmpty ? "Enter description" : null,
                ),
                SizedBox(height: 10),
                Text("Pizza Prices", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: _smallPriceController,
                  decoration: InputDecoration(labelText: "Small Price"),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? "Enter small price" : null,
                ),
                TextFormField(
                  controller: _mediumPriceController,
                  decoration: InputDecoration(labelText: "Medium Price"),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? "Enter medium price" : null,
                ),
                TextFormField(
                  controller: _largePriceController,
                  decoration: InputDecoration(labelText: "Large Price"),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? "Enter large price" : null,
                ),
                TextFormField(
                  controller: _familyPriceController,
                  decoration: InputDecoration(labelText: "Family Price"),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? "Enter family price" : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updatePizza,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF570101),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Center(
                    child: Text(
                      "Update Pizza",
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
