import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  static final TextStyle title = GoogleFonts.nunito(
    color: AppColors.black,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle head = GoogleFonts.dmSans(
    color: AppColors.gray,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle subHead = GoogleFonts.nunito(
    color: AppColors.gray,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle tabTitle = GoogleFonts.nunito(
    color: AppColors.lightGray,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle blueText = GoogleFonts.nunito(
    color: AppColors.blue,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle grayText = GoogleFonts.nunito(
    color: AppColors.lightGray,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle section = GoogleFonts.nunito(
    color: AppColors.gray,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle body = GoogleFonts.dmSans(
    color: AppColors.gray,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle label = GoogleFonts.dmSans(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  // static final TextStyle body11 = GoogleFonts.notoSans(
  //   color: AppColors.grey,
  //   fontSize: 11,
  //   fontWeight: FontWeight.normal,
  // );
}
