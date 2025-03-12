// ignore: file_names
import 'package:flutter/material.dart';
import 'package:mfc/Constants/colors.dart';
import 'package:mfc/screens/LoginSignUpScreen/Commons/Common/CustomTextFormField.dart';

class SignUpCard extends StatefulWidget {
  const SignUpCard({super.key});

  @override
  State<SignUpCard> createState() => _SignUpCardState();
}

final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String email = emailController.text;
  String password = passwordController.text;

class _SignUpCardState extends State<SignUpCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20))),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: customTextFormField(labletext: 'Enter your email!',TextController: emailController),
          ),
           SizedBox(height: 40,),
          Padding(
            child: customTextFormField(labletext: 'Enter your password', TextController: passwordController),
            padding: const EdgeInsets.symmetric(horizontal: 20,
          
          ),
          ),
          SizedBox(height: 40,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20))),
            onPressed: (){}, child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 70),
            child: Text('Sign Up',style: TextStyle(color: primaryColor),)),
          ),
          SizedBox(height: 15,),
          Center(child: Text('Or',style: TextStyle(color: secondaryColor), ),),
          SizedBox(height: 5,),
          Center(child: TextButton(
            onPressed: (){},
            child: Text('Signup with Google', style: TextStyle(color: secondaryColor),), ),),
        ],
      )
    );
  }
}