import 'package:devpush/core/app_colors.dart';
import 'package:flutter/material.dart';

import 'dart:math' as math;

class AchievementsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      width: 72,
      color: Colors.red,
      child: Stack(
        children: [
          Center(
            child: Container(
              height: 54,
              width: 54,
              child: Transform.rotate(
                angle: 45 * math.pi / 180,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), //16
                    color: AppColors.blue,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Icon(Icons.star),
          ),
        ],
      ),
    );
  }
}
