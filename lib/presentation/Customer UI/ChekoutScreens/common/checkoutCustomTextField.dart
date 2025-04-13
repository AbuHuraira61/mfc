import 'package:flutter/material.dart';
import 'package:mfc/Constants/colors.dart';

final TextEditingController TextController = TextEditingController();

TextFormField checkoutCustomTextField({required String labletext,  required TextEditingController TextController, }) {
  return TextFormField(
    controller: TextController,
    cursorColor: primaryColor,
    decoration: InputDecoration(
        hintText: labletext,
        enabled: true,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
            borderRadius: BorderRadius.all(Radius.circular(10)))),
  );
}
