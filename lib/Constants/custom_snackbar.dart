import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mfc/Constants/colors.dart';

class CustomSnackbar {
   void showSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: primaryColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
      borderRadius: 10,
      margin: EdgeInsets.all(10),
      isDismissible: true,
    );
  }
}