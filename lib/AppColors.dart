import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2E3193);
  static const Color secondary = Color(0xFFD0DED8);
  static const Color thirtary = Colors.white;
  static const Color loading = Color(0xFF066CAB);
  static const Color other = Colors.grey;
}

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle subheading = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    color: Colors.grey,
  );

  static const TextStyle button = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.thirtary,
  );

  static const TextStyle input = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    color: Colors.black,
  );
}
