import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension ThemeDataExtension on ThemeData {
  get textColor => Get.isDarkMode ? Colors.white : Colors.black;
}