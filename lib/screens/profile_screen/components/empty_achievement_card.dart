import 'package:devpush/core/app_colors.dart';
import 'package:flutter/material.dart';

import 'dart:math' as math;

import 'package:google_fonts/google_fonts.dart';

class EmptyAchievementCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 72,
      height: MediaQuery.of(context).size.width * 0.2,
      width: MediaQuery.of(context).size.width * 0.2,
      // color: Colors.red,
      child: Stack(
        children: [
          Center(
            child: Container(
              // height: 54,
              height: MediaQuery.of(context).size.width * 0.15,
              width: MediaQuery.of(context).size.width * 0.15,
              child: Transform.rotate(
                angle: 45 * math.pi / 180,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), //16
                    color: AppColors.light,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.width * 0.1,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: MediaQuery.of(context).size.width * 0.014,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.06,
              height: MediaQuery.of(context).size.width * 0.06,
              decoration: BoxDecoration(
                // border: Border.all(
                //     color: Colors.white,
                //     width: MediaQuery.of(context).size.width * 0.008),
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.048,
                      height: MediaQuery.of(context).size.width * 0.048,
                      decoration: BoxDecoration(
                        // border: Border.all(
                        //     color: Colors.white,
                        //     width: MediaQuery.of(context).size.width * 0.008),
                        shape: BoxShape.circle,
                        color: AppColors.light,
                      ),
                      child: Center(
                        child: Text(
                          '',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
