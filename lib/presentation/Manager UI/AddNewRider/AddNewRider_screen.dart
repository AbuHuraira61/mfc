import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mfc/Constants/colors.dart';

class AddNewRiderScreen extends StatefulWidget {
  const AddNewRiderScreen({super.key});

  @override
  _AddNewRiderScreenState createState() => _AddNewRiderScreenState();
}

class _AddNewRiderScreenState extends State<AddNewRiderScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();

  // void addRider() {
  //   if (_formKey.currentState!.validate()) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Rider added successfully!")),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Please fill all fields")),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.08, // Side Padding
            vertical: screenHeight * 0.06, // Top/Bottom Padding
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Keep UI compact
            children: [
              // Back Button
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back,
                      color: Color(0xff570101), size: 28),
                  onPressed: () {
                    Navigator.pop(
                        context); // Navigate back to the previous screen
                  },
                ),
              ),

              // Rider Image
              SizedBox(
                height: screenHeight * 0.22, // Slightly smaller image
                child: Image.asset(
                  "assets/riderBG.png",
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 15),

              // Centered Heading Section
              Text(
                "Add New Rider",
                style: TextStyle(
                  fontSize: screenWidth * 0.06, // Slightly smaller
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                "Fill in the details below to register a new rider.",
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),

              // Form Section
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                        _nameController, "Full Name", Icons.person, false),
                    const SizedBox(height: 12),
                    _buildTextField(
                        _emailController, "Email Address", Icons.email, false),
                    const SizedBox(height: 12),
                    _buildTextField(
                        _phoneController, "Phone Number", Icons.phone, false),
                    const SizedBox(height: 12),
                    _buildTextField(
                        _passwordController, "Password", Icons.lock, true),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              SizedBox(height: 50),
              // Submit Button
              SizedBox(
                width: screenWidth * 0.85, // Slightly smaller button
                child: ElevatedButton(
                  onPressed: () async {
                    UserCredential userCredential =
                        await _auth.createUserWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                    _firestore
                        .collection("users")
                        .doc(userCredential.user!.uid)
                        .set({
                      "email": _emailController.text,
                      "role": 'rider',
                      "name": _nameController.text,
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff570101),
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.015, // Slightly smaller button
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    "Add Rider",
                    style: TextStyle(
                      fontSize: screenWidth * 0.045, // Adjusted font size
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      IconData icon, bool obscureText) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: hint,
        prefixIcon: Icon(icon, color: Color(0xff570101)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter $hint";
        }
        return null;
      },
    );
  }
}
