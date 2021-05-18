import 'package:devpush/core/app_text_styles.dart';
import 'package:flutter/material.dart';

class SimpleButton extends StatelessWidget {
  final Color color;
  final String title;
  final Function onTap;
  const SimpleButton({
    Key key,
    @required this.color,
    @required this.title,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 310,
      height: 56,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              title,
              style: AppTextStyles.label,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
