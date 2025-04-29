import 'package:flutter/material.dart';
import 'package:mfc/Constants/colors.dart';

final TextEditingController TextController = TextEditingController();

TextFormField checkoutCustomTextField({
  required String labletext,
  required TextEditingController TextController,
}) {
  return TextFormField(
    controller: TextController,
    cursorColor: primaryColor,
    decoration: InputDecoration(
        hintText: labletext,
        enabled: true,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor, width: 1.5))),
  );
}
