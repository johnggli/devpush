import 'package:devpush/core/app_colors.dart';
import 'package:flutter/material.dart';

class EmptyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        decoration: BoxDecoration(
          border: Border.fromBorderSide(
            BorderSide(
              color: AppColors.light,
            ),
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          color: Colors.transparent,
          height: 105,
        ),
      ),
    );
  }
}
