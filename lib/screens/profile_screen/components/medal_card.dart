import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:devpush/core/app_colors.dart';

class MedalCard extends StatelessWidget {
  final String kind;
  final String iconName;
  final String label;

  const MedalCard({
    Key key,
    @required this.kind,
    @required this.iconName,
    @required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, IconData> _iconsMap = {
      'library_add': Icons.library_add,
    };

    return Container(
      height: MediaQuery.of(context).size.width * 0.16,
      width: MediaQuery.of(context).size.width * 0.16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          width: 3,
          color: kind == 'gold' ? Colors.yellow : Colors.grey[400],
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
            color: kind == 'gold' ? AppColors.yellow : AppColors.lightGray,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _iconsMap[iconName],
              color: kind == 'gold' ? AppColors.yellow : AppColors.lightGray,
              size: 20,
            ),
            Text(
              '$label',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: MediaQuery.of(context).size.width * 0.03,
                color: kind == 'gold' ? AppColors.yellow : AppColors.lightGray,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
