import 'package:flutter/material.dart';
import 'package:mfc/Constants/colors.dart';

class CustomText extends StatelessWidget {
  const CustomText({super.key, required this.textName, required this.fontSize});
  final String textName; 
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return  Text(textName, style: TextStyle(color: secondaryColor, fontSize: fontSize, ),
    );
  }
}