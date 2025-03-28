import 'package:flutter/material.dart';
import 'package:mfc/Constants/colors.dart';
import 'package:mfc/Services/auth_service.dart';
import 'package:mfc/auth/LoginSignUpScreen/Commons/Common/CustomTextFormField.dart';

import 'package:mfc/auth/LoginSignUpScreen/Commons/SignUpCard.dart';
import 'package:mfc/presentation/Customer%20UI/screens/Hassan/Home_screen,.dart';

import 'package:mfc/presentation/Customer%20UI/screens/Home_screen,.dart';



class LogInCard extends StatefulWidget {
  const LogInCard({super.key});

  @override
  State<LogInCard> createState() => _LogInCardState();
}

final TextEditingController EmailController = TextEditingController();
final TextEditingController PasswordController = TextEditingController();
final AuthService authService = AuthService();
final _loginFormkey = GlobalKey<FormState>();

class _LogInCardState extends State<LogInCard> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginFormkey,
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
                      TextController: EmailController,
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
                      labletext: 'Enter your password',
                      TextController: PasswordController,
                      validatorText: 'Email'),
                ),
                SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  onPressed: () {
                    if (_loginFormkey.currentState!.validate()) {
                      authService.loginUser(EmailController.text,
                          PasswordController.text, context);
                    }
                  },
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 70),
                      child: Text(
                        'Login',
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
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return HomeScreen();
                      }));
                    },
                    child: Text(
                      'Login with Google',
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
