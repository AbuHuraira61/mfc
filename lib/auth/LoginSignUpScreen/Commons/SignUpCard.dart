// ignore: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mfc/Constants/colors.dart';
import 'package:mfc/Services/auth_service.dart';
import 'package:mfc/auth/LoginSignUpScreen/Commons/Common/CustomTextFormField.dart';
import 'package:mfc/presentation/Customer%20UI/Home/Home_screen.dart';

class SignUpCard extends StatefulWidget {
  const SignUpCard({super.key});

  @override
  State<SignUpCard> createState() => _SignUpCardState();
}

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final AuthService authService = AuthService();
final _signUpformkey = GlobalKey<FormState>();

class _SignUpCardState extends State<SignUpCard> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _signUpformkey,
      child: SingleChildScrollView(
        child: Container(
            decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: customTextFormField(
                      labletext: 'Enter your email!',
                      icon: Icons.lock,
                      TextController: emailController,
                      validatorText: 'Email'),
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: customTextFormField(
                      validatorText: 'Password',
                      labletext: 'Enter your password',
                      icon: Icons.lock,
                      TextController: passwordController),
                ),
                SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  onPressed: () {
                    if (_signUpformkey.currentState!.validate()) {
                      authService
                          .signUpUser(emailController.text,
                              passwordController.text, context)
                          .then(
                        (value) {
                          Get.snackbar('Success!', 'Email added sccuessfully!');
                          Get.off(HomeScreen());
                        },
                      ).onError(
                        (error, stackTrace) {
                          Get.snackbar('Error', error.toString());
                          return;
                        },
                      );
                    }
                  },
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 70),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: primaryColor),
                      )),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Text(
                    'Or',
                    style: TextStyle(color: secondaryColor),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Signup with Google',
                      style: TextStyle(color: secondaryColor),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
