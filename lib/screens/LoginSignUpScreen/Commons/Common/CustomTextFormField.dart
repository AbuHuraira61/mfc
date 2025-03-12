import 'package:flutter/material.dart';
import 'package:mfc/Constants/colors.dart';
final TextEditingController TextController = TextEditingController();
 


TextFormField customTextFormField ({required String labletext, required TextEditingController TextController}) {
 return TextFormField(
              controller: TextController,
              cursorColor: secondaryColor,
              style: TextStyle(color: const Color.fromARGB(217, 255, 255, 255),),
            decoration: InputDecoration(
              
              focusColor: secondaryColor, labelText: labletext, labelStyle: TextStyle(color: Colors.white),contentPadding: EdgeInsets.all(2.0), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: secondaryColor),)),
            );
          
}
          