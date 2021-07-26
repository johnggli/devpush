import 'package:devpush/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MedalCard extends StatelessWidget {
  const MedalCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.16,
      width: MediaQuery.of(context).size.width * 0.16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        // color: Colors.yellow[700],
        border: Border.all(
          width: 3,
          color: Colors.yellow,
          style: BorderStyle.solid,
        ),
      ),
      child: Container(
        height: MediaQuery.of(context).size.width * 0.14,
        width: MediaQuery.of(context).size.width * 0.14,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.white,
          border: Border.all(
            width: 3,
            color: AppColors.yellow,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.library_add,
              color: AppColors.yellow,
              size: 20,
            ),
            Text(
              '10',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: MediaQuery.of(context).size.width * 0.03,
                color: AppColors.yellow,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
