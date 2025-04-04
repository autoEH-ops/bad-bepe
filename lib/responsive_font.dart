// utils/responsive_font.dart
import 'package:flutter/material.dart';

double responsiveFontSize(BuildContext context, double baseSize) {
  double screenWidth = MediaQuery.of(context).size.width;
  // Adjust 400 to the base screen width that works well for your app
  return baseSize * (screenWidth / 400);
}
