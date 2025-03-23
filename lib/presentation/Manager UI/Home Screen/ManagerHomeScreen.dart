import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mfc/Constants/colors.dart';
import 'package:mfc/presentation/Manager%20UI/AddItem_screen.dart';
import 'package:mfc/presentation/Manager%20UI/AddNewRider_screen.dart';
import 'package:mfc/presentation/Manager%20UI/ManagerPizzaScreen.dart';
import 'package:mfc/presentation/Manager%20UI/PendingOrder_screen.dart';
import 'package:mfc/auth/LoginSignUpScreen/LoginSignUpScreen.dart';

class ManagerHomeScreen extends StatefulWidget {
  const ManagerHomeScreen({super.key});

  @override
  State<ManagerHomeScreen> createState() => _ManagerHomeScreenState();
}

class _ManagerHomeScreenState extends State<ManagerHomeScreen> {
  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginSignUpScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'MFC Food Delivery App',
          style: TextStyle(color: secondaryColor),
        ),
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          // Details Panel
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDetailItem(Icons.info, "Pending", "30"),
                    _buildDetailItem(Icons.check_box, "Completed", "10"),
                    _buildDetailItem(Icons.attach_money, "Earning", "100\$"),
                  ],
                ),
              ],
            ),
          ),

          // Buttons Panel
          Expanded(
            child: GridView.count(
              padding: EdgeInsets.all(10),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return AddItemScreen();
                        },
                      ));
                    },
                    splashColor: Colors.white.withOpacity(0.3),
                    highlightColor: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    child: _buildButton(Icons.add, "Add Menu")),
                InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ManagerPizzaScreen()),
                      );
                    },
                    splashColor: Colors.white.withOpacity(0.3),
                    highlightColor: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    child: _buildButton(Icons.remove_red_eye, "All Item Menu")),
                InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddNewRiderScreen()),
                      );
                    },
                    splashColor: Colors.white.withOpacity(0.3),
                    highlightColor: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    child: _buildButton(Icons.person_add, "Add New Rider")),
                InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PendingOrderScreen()),
                      );
                    },
                    splashColor: Colors.white.withOpacity(0.3),
                    highlightColor: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    child: _buildButton(Icons.local_shipping, "Order Status")),
                InkWell(
                    onTap: () {
                      _logout(context); // Call logout function
                    },
                    splashColor: Colors.white.withOpacity(0.3),
                    highlightColor: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    child: _buildButton(Icons.logout, "Log Out")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildDetailItem(IconData icon, String title, String value) {
  return Column(
    children: [
      Icon(icon, color: Colors.white),
      SizedBox(height: 5),
      Text(title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      Text(value, style: TextStyle(color: Colors.white, fontSize: 18)),
    ],
  );
}

Widget _buildButton(IconData icon, String label) {
  return Ink(
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 40, color: Colors.black87),
        SizedBox(height: 10),
        Text(label,
            textAlign: TextAlign.center,
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
      ],
    ),
  );
}
