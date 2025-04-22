import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mfc/Constants/colors.dart';
import 'package:mfc/presentation/Manager%20UI/All%20Items/AllAddedItemScreen.dart';
import 'dart:convert';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemIngredientsController =
      TextEditingController();
  final TextEditingController _itemPriceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _smallPriceController = TextEditingController();
  final TextEditingController _mediumPriceController = TextEditingController();
  final TextEditingController _largePriceController = TextEditingController();
  final TextEditingController _familyPriceController = TextEditingController();

  String _selectedCategory = 'Pizza';
  File? _selectedImage;
  String _selectedPizzaType = 'Standard';
  String _selectedPizzaSize = 'Small';
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _encodeImageToBase64() async {
    if (_selectedImage == null) return null;
    List<int> imageBytes = await _selectedImage!.readAsBytes();
    return base64Encode(imageBytes);
  }

  Future<void> _addItemToFirestore() async {
    if (_itemNameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _itemIngredientsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

// If the selected category is Pizza, check for empty size-based prices
    if (_selectedCategory == 'Pizza' &&
        (_smallPriceController.text.isEmpty ||
            _mediumPriceController.text.isEmpty ||
            _largePriceController.text.isEmpty ||
            _familyPriceController.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all pizza size prices")),
      );
      return;
    }

// If it's NOT pizza, ensure the general price is filled
    if (_selectedCategory != 'Pizza' && _itemPriceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter the item price")),
      );
      return;
    }

    String? imageBase64 = await _encodeImageToBase64();

    Map<String, dynamic> itemData = {
      "name": _itemNameController.text,
      "ingredients": _itemIngredientsController.text,
      "price": _itemPriceController.text,
      "description": _descriptionController.text,
      "image": imageBase64 ?? "",
      "timestamp": FieldValue.serverTimestamp(),
    };

    if (_selectedCategory == 'Pizza') {
      itemData.addAll({
        "pizzaType": _selectedPizzaType,
        "prices": {
          "small": _smallPriceController.text,
          "medium": _mediumPriceController.text,
          "large": _largePriceController.text,
          "family": _familyPriceController.text,
        }
      });
    }

    await FirebaseFirestore.instance
        .collection("food_items")
        .doc(_selectedCategory)
        .collection("items")
        .add(itemData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Item added successfully!")),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AllAddedItemScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Item", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: [
                  'Pizza',
                  'Burger',
                  'Fries',
                  'Chicken Roll',
                  'Hot Wings',
                  'Pasta',
                  'Sandwich',
                  'Broast Chicken'
                ]
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
                    floatingLabelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: primaryColor, width: 1.5)),
                    border: OutlineInputBorder()),
              ),
              if (_selectedCategory == "Pizza") ...[
                SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField<String>(
                  value: _selectedPizzaType,
                  items: ['Standard', 'Premium', 'New Addition', 'Matka Pizza']
                      .map((type) =>
                          DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPizzaType = value!;
                    });
                  },
                  decoration: InputDecoration(
                      labelText: "Select Pizza Type",
                      floatingLabelStyle: TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: primaryColor, width: 1.5)),
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
              SizedBox(height: 12),
              TextField(
                controller: _itemNameController,
                decoration: InputDecoration(
                  labelText: "Item Name",
                  floatingLabelStyle: TextStyle(color: primaryColor),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 1.5)),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _itemIngredientsController,
                decoration: InputDecoration(
                  labelText: "Item Ingredients",
                  floatingLabelStyle: TextStyle(color: primaryColor),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 1.5)),
                ),
              ),
              SizedBox(height: 12),
              if (_selectedCategory == 'Pizza') ...[
                TextField(
                  controller: _smallPriceController,
                  decoration: InputDecoration(
                    labelText: "Price for Small",
                    floatingLabelStyle: TextStyle(color: primaryColor),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: primaryColor, width: 1.5)),
                  ),
                ),
                TextField(
                  controller: _mediumPriceController,
                  decoration: InputDecoration(
                    labelText: "Price for Medium",
                    floatingLabelStyle: TextStyle(color: primaryColor),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: primaryColor, width: 1.5)),
                  ),
                ),
                TextField(
                  controller: _largePriceController,
                  decoration: InputDecoration(
                    labelText: "Price for Large",
                    floatingLabelStyle: TextStyle(color: primaryColor),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: primaryColor, width: 1.5)),
                  ),
                ),
                TextField(
                  controller: _familyPriceController,
                  decoration: InputDecoration(
                    labelText: "Price for Family",
                    floatingLabelStyle: TextStyle(color: primaryColor),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: primaryColor, width: 1.5)),
                  ),
                ),
              ] else ...[
                TextField(
                  controller: _itemPriceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Item Price",
                    floatingLabelStyle: TextStyle(color: primaryColor),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: primaryColor, width: 1.5)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ],
              SizedBox(height: 12),
              Text("Item Image", style: TextStyle(fontSize: 16)),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(_selectedImage!,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover))
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo,
                                  size: 40, color: primaryColor),
                              SizedBox(height: 5),
                              Text("Tap to select image",
                                  style: TextStyle(color: primaryColor)),
                            ],
                          ),
                        ),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Short Description",
                  floatingLabelStyle: TextStyle(color: primaryColor),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(12),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 1.5)),
                ),
              ),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff570101),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _addItemToFirestore,
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
