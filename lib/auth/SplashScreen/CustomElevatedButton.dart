import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:mfc/Constants/colors.dart';

class CustomelEvatedButton extends StatelessWidget {
  const CustomelEvatedButton(
      {super.key, required this.buttonName, required this.onPressed});
  final String buttonName;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            minimumSize: WidgetStateProperty.all(Size(Get.width * 0.85, 50)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ), // width: 200, height: 50
            backgroundColor: WidgetStateProperty.all(primaryColor)),
        onPressed: onPressed,
        child: Text(style: TextStyle(color: Colors.white), buttonName));
  }
}
