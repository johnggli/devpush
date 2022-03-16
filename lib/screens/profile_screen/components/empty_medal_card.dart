import 'package:devpush/core/app_colors.dart';
import 'package:flutter/material.dart';

class EmptyMedalCard extends StatelessWidget {
  const EmptyMedalCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.154,
              child: Column(
                children: [
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.width * 0.15,
                    width: MediaQuery.of(context).size.width * 0.15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: AppColors.light,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.154,
              child: Column(
                children: [
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.width * 0.15,
                    width: MediaQuery.of(context).size.width * 0.15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.width * 0.154,
              width: MediaQuery.of(context).size.width * 0.154,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  width: MediaQuery.of(context).size.width * 0.02,
                  color: AppColors.light,
                  style: BorderStyle.solid,
                ),
              ),
              // child: Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Icon(
              //       IconData(codePoint, fontFamily: 'MaterialIcons'),
              //       color: Color(
              //         int.parse(color.split('(0x')[1].split(')')[0], radix: 16),
              //       ),
              //       size: MediaQuery.of(context).size.width * 0.06,
              //     ),
              //     Text(
              //       '$label'.toUpperCase(),
              //       textAlign: TextAlign.center,
              //       style: GoogleFonts.nunito(
              //         fontSize: MediaQuery.of(context).size.width * 0.03,
              //         color: Color(
              //           int.parse(color.split('(0x')[1].split(')')[0],
              //               radix: 16),
              //         ),
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ],
              // ),
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
