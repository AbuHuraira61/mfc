// import 'package:flutter/material.dart';
// import 'package:mfc/Constants/colors.dart';
// import 'package:mfc/presentation/Customer%20UI/Extra/LogInCard.dart';
// import 'package:mfc/presentation/Customer%20UI/Extra/SignUpCard.dart';

// class LoginSignUpScreen extends StatefulWidget {
//   const LoginSignUpScreen({super.key});

//   @override
//   State<LoginSignUpScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginSignUpScreen> with TickerProviderStateMixin {
//   late TabController tabController;

//   @override
//   void initState() {
//     super.initState();
//     tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   void dispose() {
//     tabController.dispose();
//     super.dispose();
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             ClipPath(
//               clipper: ConcaveClipper(),
//               child: Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(color: primaryColor),
//                 height: 350,
//                 child: Positioned(
//                   height: 100,
//                   child: const Image(
//                     filterQuality: FilterQuality.high,
//                     fit: BoxFit.cover,
//                     image: AssetImage('assets/food-banner.png'),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 30),
//               decoration: BoxDecoration(
//                 color: primaryColor,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: TabBar(
//                 indicatorColor: primaryColor,
//                 unselectedLabelColor: secondaryColor,
//                 labelColor: primaryColor,
//                 dividerHeight: 0,
//                 indicatorSize: TabBarIndicatorSize.tab,
//                 indicator: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: secondaryColor,
//                 ),
//                 controller: tabController,
//                 tabs: const [
//                   Tab(text: 'Sign Up'),
//                   Tab(text: 'Log In'),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               height: 400,
//               child: TabBarView(
//                 controller: tabController,
//                 children: const [
//                   SignUpCard(),
//                   LogInCard(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ConcaveClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     Path path = Path();
//     path.lineTo(0, size.height - 50);
//     path.quadraticBezierTo(size.width / 2, size.height + 30, size.width, size.height - 50);
//     path.lineTo(size.width, 0);
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }
