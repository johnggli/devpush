import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:devpush/core/app_colors.dart';

class MedalCard extends StatelessWidget {
  final String color;
  final int codePoint;
  final String label;

  const MedalCard({
    Key key,
    @required this.color,
    @required this.codePoint,
    @required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.16,
      width: MediaQuery.of(context).size.width * 0.16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
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
              IconData(codePoint, fontFamily: 'MaterialIcons'),
              color: Color(
                int.parse(color.split('(0x')[1].split(')')[0], radix: 16),
              ),
              size: 20,
            ),
            Text(
              '$label',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: MediaQuery.of(context).size.width * 0.03,
                color: Color(
                  int.parse(color.split('(0x')[1].split(')')[0], radix: 16),
                ),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
