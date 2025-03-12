import 'package:flutter/material.dart';
import 'package:mfc/Constants/colors.dart';

TextField checkoutCustomTextField({required String labletext}){
  return TextField(
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
                        );;
}