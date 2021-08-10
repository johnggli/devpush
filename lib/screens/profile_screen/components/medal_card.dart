import 'package:devpush/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MedalCard extends StatelessWidget {
  final String color;
  final int codePoint;
  final String label;
  final String title;
  final String date;
  final String desc;

  const MedalCard({
    Key key,
    @required this.color,
    @required this.codePoint,
    @required this.label,
    @required this.title,
    @required this.date,
    @required this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 124,
      // width: MediaQuery.of(context).size.width * 0.18,
      // decoration: BoxDecoration(
      //   border: Border.fromBorderSide(
      //     BorderSide(
      //       color: AppColors.light,
      //     ),
      //   ),
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(10),
      // ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.width * 0.16,
                width: MediaQuery.of(context).size.width * 0.16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    width: MediaQuery.of(context).size.width * 0.02,
                    color: Color(
                      int.parse(color.split('(0x')[1].split(')')[0], radix: 16),
                    ),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      IconData(codePoint, fontFamily: 'MaterialIcons'),
                      color: Color(
                        int.parse(color.split('(0x')[1].split(')')[0],
                            radix: 16),
                      ),
                      size: MediaQuery.of(context).size.width * 0.06,
                    ),
                    Text(
                      '$label',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: MediaQuery.of(context).size.width * 0.03,
                        color: Color(
                          int.parse(color.split('(0x')[1].split(')')[0],
                              radix: 16),
                        ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '$title'.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize: MediaQuery.of(context).size.width * 0.026,
                  height: 1,
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              Text(
                '$date'.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize: MediaQuery.of(context).size.width * 0.026,
                  // height: 1,
                  color: AppColors.lightGray,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
