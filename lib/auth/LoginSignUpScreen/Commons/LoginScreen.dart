import 'package:flutter/material.dart';
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
  bool _isPasswordVisible = false;

  final Color primaryColor = const Color(0xff570101);

  // Method to show the reset password dialog
  void _showResetPasswordDialog() {
    final _resetFormKey = GlobalKey<FormState>();
    final _resetEmailController = TextEditingController();
    final _newPasswordController = TextEditingController();
    final _confirmPasswordController = TextEditingController();
    bool _isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Reset Password', style: TextStyle(color: primaryColor)),
          content: Form(
            key: _resetFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  
                  controller: _resetEmailController,
                  decoration:  InputDecoration(labelText: 'Email', focusColor: primaryColor, hoverColor: primaryColor),
                  validator: (value) => value!.isEmpty ? 'Enter email' : null,
                ),
                // TextFormField(
                //   controller: _newPasswordController,
                //   decoration: const InputDecoration(labelText: 'New Password'),
                //   obscureText: true,
                //   validator: (value) => value!.isEmpty ? 'Enter new password' : null,
                // ),
                // TextFormField(
                //   controller: _confirmPasswordController,
                //   decoration: const InputDecoration(labelText: 'Confirm Password'),
                //   obscureText: true,
                //   validator: (value) {
                //     if (value!.isEmpty) {
                //       return 'Confirm your password';
                //     } else if (value != _newPasswordController.text) {
                //       return 'Passwords do not match';
                //     }
                //     return null;
                //   },
                // ),
              ],
            ),
          ),
          actions: [
            if (_isLoading)
              const CircularProgressIndicator()
            else
              TextButton(
                onPressed: () async {
                  if (_resetFormKey.currentState!.validate()) {
                    setState(() {
                      _isLoading = true;
                    });
                    try {
                      // Assuming AuthService has resetPassword method
                      bool success = await _authService.resetPassword(
                        _resetEmailController.text,
                        
                      );
                      if (success) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Email sent for password reset')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to reset password')),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    } finally {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  }
                },
                child: Text('Reset', style: TextStyle(color: primaryColor)),
              ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:  Text('Cancel', style: TextStyle(color: primaryColor)),
            ),
          ],
        ),
      ),
    );
  }

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
                              obscureText: !_isPasswordVisible,
                              showSuffixIcon: true,
                              toggleVisibility: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: _showResetPasswordDialog,
                              child: Container(
                                alignment: Alignment.topRight,
                                child: const Text(
                                  'Forget Password?',
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            const SizedBox(height: 60),
                            InkWell(
                              onTap: () async {
                                setState(() {
                                  _indicator = true;
                                });
                                FocusScope.of(context).unfocus();
                                if (_loginFormkey.currentState!.validate()) {
                                  await _authService.loginUser(
                                      _EmailController.text,
                                      _PasswordController.text,
                                      context);
                                }
                                _EmailController.clear();
                                _PasswordController.clear();
                                setState(() {
                                  _indicator = false;
                                });
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
                                      : const Text(
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
                        const Text(
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
                                  builder: (context) => const SignUpScreen()),
                            );
                          },
                          child: const Text(
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



// import 'package:flutter/material.dart';
// import 'package:mfc/Services/auth_service.dart';
// import 'package:mfc/auth/LoginSignUpScreen/Commons/Common/CustomTextFormField.dart';
// import 'package:mfc/auth/LoginSignUpScreen/Commons/SignUpScreen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginscreenState();
// }

// class _LoginscreenState extends State<LoginScreen> {
//   final TextEditingController _EmailController = TextEditingController();
//   final TextEditingController _PasswordController = TextEditingController();
//   final AuthService _authService = AuthService();
//   final _loginFormkey = GlobalKey<FormState>();
//   bool _indicator = false;
//    bool _isPasswordVisible = false;

//   final Color primaryColor = const Color(0xff570101);

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _loginFormkey,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: SingleChildScrollView(
//           child: Stack(
//             children: [
//               Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.height / 2,
//                 color: primaryColor,
//               ),
//               Container(
//                 margin: EdgeInsets.only(
//                     top: MediaQuery.of(context).size.height / 3),
//                 height: MediaQuery.of(context).size.height / 3,
//                 width: MediaQuery.of(context).size.width,
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(40),
//                     topRight: Radius.circular(40),
//                   ),
//                 ),
//                 child: const Text(""),
//               ),
//               Container(
//                 margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
//                 child: Column(
//                   children: [
//                     Center(
//                       child: Image.asset(
//                         "assets/logoo.png",
//                         width: MediaQuery.of(context).size.width / 1.7,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     Material(
//                       elevation: 5.0,
//                       borderRadius: BorderRadius.circular(20),
//                       child: Container(
//                         padding: const EdgeInsets.only(left: 20, right: 20),
//                         width: MediaQuery.of(context).size.width,
//                         height: MediaQuery.of(context).size.height / 2.2,
//                         decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(20)),
//                         child: Column(
//                           children: [
//                             const SizedBox(height: 20),
//                             const Text(
//                               "Login",
//                               style: TextStyle(
//                                   fontSize: 25, fontWeight: FontWeight.bold),
//                             ),
//                             const SizedBox(height: 10),
//                             customTextFormField(
//                                 labletext: 'Email',
//                                 TextController: _EmailController,
//                                 validatorText: 'email',
//                                 icon: Icons.mail),
//                             const SizedBox(height: 10),
//                             customTextFormField(
//                               labletext: 'Password',
//                               TextController: _PasswordController,
//                               validatorText: 'password',
//                               icon: Icons.lock,
//                                obscureText: !_isPasswordVisible, // 👈 use visibility flag
//           showSuffixIcon: true, // 👈 enable eye icon
//           toggleVisibility: () {
//             setState(() {
//               _isPasswordVisible = !_isPasswordVisible;
//             });
//           },

//                             ),
//                             const SizedBox(height: 10),
//                             Container(
//                               alignment: Alignment.topRight,
//                               child: Text(
//                                 'Forget Password?',
//                                 style: TextStyle(
//                                     fontSize: 15, fontWeight: FontWeight.w500),
//                               ),
//                             ),
//                             const SizedBox(height: 60),
//                             InkWell(
//                               onTap: () async {
//                                      setState(() {
//   _indicator = true;
// });
//                                 FocusScope.of(context).unfocus();
                           
//                                 if (_loginFormkey.currentState!.validate())  {
//                                await   _authService.loginUser(_EmailController.text,
//                                       _PasswordController.text, context);

//                                 }
                              
                               
//                                 _EmailController.clear();
//                                 _PasswordController.clear();
//                                   setState(() {
//   _indicator = false;
// });
//                               },
//                               child: Container(
//                                 padding: const EdgeInsets.all(7.0),
//                                 width: 280,
//                                 decoration: BoxDecoration(
//                                     color: const Color(0xff570101),
//                                     borderRadius: BorderRadius.circular(5)),
//                                 child: Center(
//                                   child: _indicator
//                                       ? const SizedBox(
//                                           height: 20,
//                                           width: 20,
//                                           child: CircularProgressIndicator(
//                                             color: Colors.white,
//                                             strokeWidth: 2,
//                                           ),
//                                         )
//                                       : Text(
//                                           "Login",
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 18),
//                                         ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 160),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'Dont have an Account?',
//                           style: TextStyle(
//                               fontSize: 15, fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(width: 3),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => SignUpScreen()),
//                             );
//                           },
//                           child: Text(
//                             'SignUp',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
