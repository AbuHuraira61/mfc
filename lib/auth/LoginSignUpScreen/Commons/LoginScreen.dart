import 'package:flutter/material.dart';
import 'package:mfc/Constants/custom_snackbar.dart';
import 'package:mfc/Services/auth_service.dart';
import 'package:mfc/auth/LoginSignUpScreen/Commons/Common/CustomTextFormField.dart';
import 'package:mfc/auth/LoginSignUpScreen/Commons/SignUpScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<LoginScreen> {
  final TextEditingController _EmailController = TextEditingController();
  final TextEditingController _PasswordController = TextEditingController();
  final AuthService _authService = AuthService();
  final _loginFormkey = GlobalKey<FormState>();
  bool _indicator = false;

  final Color primaryColor = const Color(0xff570101);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginFormkey,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2,
                color: primaryColor,
              ),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 3),
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
                        "assets/logoo.png",
                        width: MediaQuery.of(context).size.width / 1.7,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2.2,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            const Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            customTextFormField(
                                labletext: 'Email',
                                TextController: _EmailController,
                                validatorText: 'email',
                                icon: Icons.mail),
                            const SizedBox(height: 10),
                            customTextFormField(
                              labletext: 'Password',
                              TextController: _PasswordController,
                              validatorText: 'password',
                              icon: Icons.lock,
                            ),
                            const SizedBox(height: 10),
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                'Forget Password?',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(height: 60),
                            InkWell(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                _indicator = true;
                                if (_loginFormkey.currentState!.validate()) {
                                  _authService.loginUser(_EmailController.text,
                                      _PasswordController.text, context);

                                }
                                 _indicator = false;
                               
                                _EmailController.clear();
                                _PasswordController.clear();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(7.0),
                                width: 280,
                                decoration: BoxDecoration(
                                    color: const Color(0xff570101),
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
                                      : Text(
                                          "Login",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 160),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Dont have an Account?',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 3),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpScreen()),
                            );
                          },
                          child: Text(
                            'SignUp',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
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
