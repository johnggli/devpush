import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  static final TextStyle title = GoogleFonts.nunito(
    color: AppColors.black,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle body = GoogleFonts.dmSans(
    color: AppColors.gray,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  // static final TextStyle body11 = GoogleFonts.notoSans(
  //   color: AppColors.grey,
  //   fontSize: 11,
  //   fontWeight: FontWeight.normal,
  // );
}
