import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:mfc/Services/auth_service.dart';
import 'package:mfc/auth/LoginSignUpScreen/Commons/Common/CustomTextFormField.dart';
import 'package:mfc/presentation/Customer%20UI/Extra/LogInCard.dart';
import 'package:mfc/auth/LoginSignUpScreen/Commons/LoginScreen.dart';
import 'package:mfc/presentation/Customer%20UI/Home/Home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final _signUpformkey = GlobalKey<FormState>();
  bool _indicator = false;

  final Color primaryColor = const Color(0xff570101);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _signUpformkey,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.5,
                color: primaryColor,
              ),
              Container(
                margin:
                    EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: const Text(""),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/logo.png",
                        width: MediaQuery.of(context).size.width / 1.7,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2.1,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Text(
                              "SignUp",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            customTextFormField(
                                labletext: 'Name',
                                TextController: _nameController,
                                validatorText: 'name',
                                icon: Icons.person),
                            SizedBox(height: 10),
                            customTextFormField(
                              labletext: 'Email',
                              TextController: _emailController,
                              validatorText: 'email',
                              icon: Icons.email,
                            ),
                            SizedBox(height: 10),
                            customTextFormField(
                              labletext: 'Password',
                              TextController: _passwordController,
                              validatorText: 'password',
                              icon: Icons.lock,
                            ),
                            SizedBox(height: 60),
                            InkWell(
                              onTap: (){
                                _indicator = true;
       if (_signUpformkey.currentState!.validate()) {
                      _authService
                          .signUpUser(_emailController.text,
                              _passwordController.text, _nameController.text, context)
                          .then(
                        (value) {
                          Get.snackbar('Success!', 'Email added sccuessfully!');
                          _indicator = false;
                          Get.off(HomeScreen());
                        },
                      ).onError(
                        (error, stackTrace) {
                          Get.snackbar('Error', error.toString());
                          _indicator = false;
                          return;
                        },
                      );
                    }
                              },
                              child: Container(
                                padding: EdgeInsets.all(7.0),
                                width: 280,
                                decoration: BoxDecoration(
                                    color: Color(0xff570101),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                  child: _indicator
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Text(
              "SignUp",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 140),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            'Already have an Account?',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(width: 3),
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                              );
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
