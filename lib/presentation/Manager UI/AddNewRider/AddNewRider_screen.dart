import 'package:flutter/material.dart';

class AddNewRiderScreen extends StatefulWidget {
  const AddNewRiderScreen({super.key});

  @override
  _AddNewRiderScreenState createState() => _AddNewRiderScreenState();
}

class _AddNewRiderScreenState extends State<AddNewRiderScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void addRider() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Rider added successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
    }
  }

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
                  color: Color(0xff570101),
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
                        nameController, "Full Name", Icons.person, false),
                    const SizedBox(height: 12),
                    _buildTextField(
                        emailController, "Email Address", Icons.email, false),
                    const SizedBox(height: 12),
                    _buildTextField(
                        phoneController, "Phone Number", Icons.phone, false),
                    const SizedBox(height: 12),
                    _buildTextField(
                        passwordController, "Password", Icons.lock, true),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              // Submit Button
              SizedBox(
                width: screenWidth * 0.75, // Slightly smaller button
                child: ElevatedButton(
                  onPressed: addRider,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff570101),
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.015, // Slightly smaller button
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
