import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:convert';

class AddDealsScreen extends StatefulWidget {
  @override
  _AddDealsScreenState createState() => _AddDealsScreenState();
}

class _AddDealsScreenState extends State<AddDealsScreen> {
  final TextEditingController _dealNameController = TextEditingController();
  final TextEditingController _dealPriceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedDealType = "One Person Deal";

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

  Future<String?> _encodeImageToBase64() async {
    if (_selectedImage == null) return null;
    List<int> imageBytes = await _selectedImage!.readAsBytes();
    return base64Encode(imageBytes);
  }

  Future<void> _addDealToFirestore() async {
    if (_dealNameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _dealPriceController.text.isEmpty ||
        _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    String? imageBase64 = await _encodeImageToBase64();

    Map<String, dynamic> dealData = {
      "name": _dealNameController.text,
      "price": int.parse(_dealPriceController.text),
      "description": _descriptionController.text,
      "image": imageBase64 ?? "",
      "timestamp": FieldValue.serverTimestamp(),
    };

    //String subCollection = _dealNameController.text.toString();

    await FirebaseFirestore.instance
        .collection("deals")
        .doc(_selectedDealType)
        .collection("deal")
        .add(dealData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Item added successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Add Deals Screen'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Select Deal Type", style: TextStyle(color: Colors.grey)),
              SizedBox(height: 5),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff570101)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                ),
                hint: Text(
                  "Select Deal Type",
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                value: _selectedDealType,
                items: [
                  'One Person Deal',
                  'Two Person Deal',
                  'Student Deal',
                  'Special Pizzas Deal',
                  'Family Deals',
                  'Lunch & Midnight Deals'
                ]
                    .map((type) =>
                        DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDealType = value!;
                  });
                },
              ),
              SizedBox(height: 10),
              TextField(
                controller: _dealNameController,
                decoration: InputDecoration(
                  labelText: "Deal Name",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff570101)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _dealPriceController,
                decoration: InputDecoration(
                  labelText: "Deal Price",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff570101)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              Text("Image"),
              SizedBox(height: 5),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: _selectedImage == null
                      ? Center(
                          child: Icon(
                          Icons.add_a_photo,
                          color: Colors.grey,
                          size: 40,
                        ))
                      : Image.file(_selectedImage!, fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Short Description",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff570101)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                ),
                maxLines: 2,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff570101),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _addDealToFirestore,
                  child:
                      Text("Add Deal", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
