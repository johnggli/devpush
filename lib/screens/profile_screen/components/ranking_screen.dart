import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_images.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RankingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColors.lightGray,
        ),
        centerTitle: true,
        title: Text(
          'Ranque',
          style: AppTextStyles.tabTitle,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 54,
              left: 18,
              right: 18,
              bottom: 18,
            ),
            child: Column(
              children: [
                Container(
                  width: 128,
                  height: 128,
                  child: Image.asset(
                    AppImages.rank,
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                Text(
                  'Ranque dos Usuários',
                  style: GoogleFonts.nunito(
                    color: AppColors.dark,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
