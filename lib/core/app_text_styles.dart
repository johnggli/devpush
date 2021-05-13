import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  static final TextStyle title = GoogleFonts.nunito(
    color: AppColors.black,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle subHead = GoogleFonts.nunito(
    color: AppColors.dark,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle cardTitle = GoogleFonts.nunito(
    color: AppColors.black,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle cardBody = GoogleFonts.dmSans(
    color: AppColors.black,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle cardDesc = GoogleFonts.dmSans(
    color: AppColors.black,
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle whiteText = GoogleFonts.nunito(
    color: Colors.white,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle buttonText = GoogleFonts.nunito(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle tabTitle = GoogleFonts.nunito(
    color: AppColors.lightGray,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle tabTitleWhite = GoogleFonts.nunito(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    height: 1,
  );

  static final TextStyle blueText = GoogleFonts.nunito(
    color: AppColors.blue,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle grayText = GoogleFonts.nunito(
    color: AppColors.lightGray,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle blackText = GoogleFonts.nunito(
    color: AppColors.black,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle description12 = GoogleFonts.nunito(
    color: AppColors.lightGray,
    fontSize: 12,
    // fontWeight: FontWeight.bold,
  );

  static final TextStyle description14 = GoogleFonts.nunito(
    color: AppColors.lightGray,
    fontSize: 14,
    // fontWeight: FontWeight.bold,
  );

  static final TextStyle section = GoogleFonts.nunito(
    color: AppColors.dark,
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

  static final TextStyle bodyDarkGreen = GoogleFonts.notoSans(
    color: AppColors.darkGreen,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle bodyDarkRed = GoogleFonts.notoSans(
    color: AppColors.darkRed,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle heading40 = GoogleFonts.notoSans(
    color: AppColors.black,
    fontSize: 40,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle bodyBold = GoogleFonts.notoSans(
    color: AppColors.gray,
    fontSize: 13,
    fontWeight: FontWeight.bold,
  );
}
