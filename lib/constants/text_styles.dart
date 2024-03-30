import 'package:flutter/material.dart';

import 'app_colors.dart';

class KTextStyle {
  static const bodyTextStyle = TextStyle(
    color: Color.fromARGB(255, 1, 8, 5),
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static const headerTextStyle = TextStyle(
      color: AppColors.whiteshade, fontSize: 28, fontWeight: FontWeight.w700);

  static const textFieldHeading = TextStyle(
      color: AppColors.blue, fontSize: 16, fontWeight: FontWeight.w500);

  static const textFieldHintStyle = TextStyle(
      color: AppColors.hintText, fontSize: 14, fontWeight: FontWeight.w500);

  static const authButtonTextStyle = TextStyle(
      fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.whiteshade);
}
