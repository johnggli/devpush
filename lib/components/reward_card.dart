import 'package:devpush/core/app_text_styles.dart';
import 'package:flutter/material.dart';

class RewardCard extends StatelessWidget {
  final Icon icon;
  final Color color;
  final int value;

  const RewardCard({
    Key key,
    @required this.icon,
    @required this.color,
    @required this.value,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      width: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      child: Stack(
        children: [
          Center(
            child: icon,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Opacity(
              opacity: 0.3,
              child: Container(
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              '$value',
              style: AppTextStyles.whiteText,
            ),
          )
        ],
      ),
    );
  }
}
