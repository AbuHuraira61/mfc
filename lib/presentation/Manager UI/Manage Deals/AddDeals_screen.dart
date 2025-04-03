import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddDealsScreen extends StatefulWidget {
  @override
  _AddDealsScreenState createState() => _AddDealsScreenState();
}

class _AddDealsScreenState extends State<AddDealsScreen> {
  File? _image;
  final picker = ImagePicker();
  String? _selectedDealType;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
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
              DropdownButtonFormField(
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
                  DropdownMenuItem(
                      child: Text("One Person Deal"), value: "One Person Deal"),
                  DropdownMenuItem(
                      child: Text("Two Person Deal"), value: "Two Person Deal"),
                  DropdownMenuItem(
                      child: Text("Student Deal"), value: "Student Deal"),
                  DropdownMenuItem(
                      child: Text("Special Pizzas Deal"),
                      value: "Special Pizzas Deal"),
                  DropdownMenuItem(
                      child: Text("Family Deals"), value: "Family Deals"),
                  DropdownMenuItem(
                      child: Text("Lunch & Midnight Deals"),
                      value: "Lunch & Midnight Deals"),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedDealType = value as String?;
                  });
                },
              ),
              SizedBox(height: 10),
              TextField(
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
                  child: _image == null
                      ? Center(
                          child: Icon(
                          Icons.add_a_photo,
                          color: Colors.grey,
                          size: 40,
                        ))
                      : Image.file(_image!, fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 10),
              TextField(
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
                  onPressed: () {},
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
