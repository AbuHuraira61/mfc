import 'package:flutter/material.dart';
import 'package:mfc/screens/LoginSignUpScreen/LoginSignUpScreen.dart';
import 'package:mfc/screens/burgerpage.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.1),

                  // Delivery Bike Image
                  Image.asset(
                    'assets/bike.png', // Replace with your image path
                    width: screenWidth * 0.7,
                    height: screenHeight * 0.3,
                    fit: BoxFit.contain,
                  ),

                  SizedBox(height: screenHeight * 0.05),

                  // Text Section
                  Text(
                    "ORDER YOUR FOOD  NOW!",
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  Text(
                    "Why wait? Get your cravings satisfied with quick delivery or easy takeaway!",
                    style: TextStyle(fontSize: screenWidth * 0.04),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: screenHeight * 0.04),

                  // Page Indicator (Three Dots)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (index) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: index == 0 ? Colors.brown : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.05),

                  // Home Delivery Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BurgerScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF570101),
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Home Delivery",
                      style: TextStyle(
                          fontSize: screenWidth * 0.045, color: Colors.white),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // Take Away Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginSignUpScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF570101),
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Take Away",
                      style: TextStyle(
                          fontSize: screenWidth * 0.045, color: Colors.white),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.05),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
