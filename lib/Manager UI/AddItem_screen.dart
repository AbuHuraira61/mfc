import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemPriceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<Map<String, dynamic>> _ingredients = [];
  String _selectedCategory = 'Pizza';
  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _addIngredientField() {
    setState(() {
      _ingredients.add(
          {"name": TextEditingController(), "price": TextEditingController()});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Add Item", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdown for selecting item type
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: ['Pizza', 'Burger', 'Dessert']
                    .map((type) =>
                        DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                decoration: InputDecoration(
                    labelText: "Select Item Type",
                    border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),

              // Item Name
              TextField(
                controller: _itemNameController,
                decoration: InputDecoration(
                    labelText: "Item Name", border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),

              // Item Price
              TextField(
                controller: _itemPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Item Price", border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),

              // Image Picker
              Row(
                children: [
                  Text("Item Image", style: TextStyle(fontSize: 16)),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.add_a_photo),
                    onPressed: _pickImage,
                  ),
                ],
              ),
              _selectedImage != null
                  ? Image.file(_selectedImage!, height: 120, fit: BoxFit.cover)
                  : Container(
                      height: 120,
                      color: Colors.grey[300],
                      child: Center(child: Text("No Image Selected"))),
              SizedBox(height: 10),

              // Short Description
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                    labelText: "Short Description",
                    border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),

              // Ingredients Section
              Text("Ingredients",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              ..._ingredients.map((ingredient) {
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: ingredient["name"],
                        decoration: InputDecoration(
                            labelText: "Ingredient Name",
                            border: OutlineInputBorder()),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: ingredient["price"],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "Price", border: OutlineInputBorder()),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _ingredients.remove(ingredient);
                        });
                      },
                    ),
                  ],
                );
              }),

              // Add Ingredient Button
              TextButton.icon(
                onPressed: _addIngredientField,
                icon: Icon(Icons.add, color: Colors.blue),
                label: Text("Add Ingredient",
                    style: TextStyle(color: Colors.blue)),
              ),
              SizedBox(height: 20),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      padding: EdgeInsets.symmetric(vertical: 15)),
                  onPressed: () {
                    // Handle form submission
                  },
                  child: Text("Add Item",
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
