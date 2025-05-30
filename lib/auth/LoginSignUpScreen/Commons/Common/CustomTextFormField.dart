import 'package:flutter/material.dart';

final TextEditingController TextController = TextEditingController();

TextFormField customTextFormField({
  required String labletext,
  required TextEditingController TextController,
  required String validatorText,
  required IconData icon,
   bool obscureText = false,
  VoidCallback? toggleVisibility,
  bool showSuffixIcon = false,

}) {
  return TextFormField(
     obscureText: obscureText,
    validator: (value) {
      if (value!.isEmpty) {
        return 'Please enter $validatorText';
      }
      return null;
    },
    controller: TextController,
    cursorColor: Colors.black,
    style: const TextStyle(
      color: Colors.black87,
    ),
    decoration: InputDecoration(
      isDense: true,
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Icon(icon, color: Color(0xff570101), size: 28.0),
      ),
      prefixIconConstraints: const BoxConstraints(
        minWidth: 40,
        minHeight: 40,
      ),
      
      suffixIcon: showSuffixIcon
          ? IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: toggleVisibility,
            )
          : null,
      hintText: labletext,
      hintStyle: const TextStyle(
          color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
    ),
  );
}
