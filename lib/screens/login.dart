import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(children: [
      ClipPath(
        clipper: ConcaveClipper(),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            
            color: Colors.red,
            
            ),
          height: 350,

          child: Positioned(
            top: 100,
            child: Image(
              
              filterQuality: FilterQuality.high,
              fit: BoxFit.cover,
              image: AssetImage('assets/food-banner.png')),
          ),
            
        
        ),
      ),
      SizedBox(height: 20,),
      Tab(

        child: TabBar(
          controller: TabController(length: 2, vsync: NavigatorState()),
          tabs: [
          Container(

            color: Colors.amber,
          ),
          Container(
            color: Colors.red,
          ),
        ],),
      ),
    ],),);
  }
}

class ConcaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height + 30, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}