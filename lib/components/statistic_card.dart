import 'package:flutter/material.dart';

import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_text_styles.dart';

class StatisticCard extends StatefulWidget {
  final String title;
  final Color color;
  final IconData icon;
  final String description;
  // final Function onTap;
  const StatisticCard({
    Key key,
    @required this.title,
    @required this.color,
    @required this.icon,
    @required this.description,
    // @required this.onTap,
  }) : super(key: key);

  @override
  _StatisticCardState createState() => _StatisticCardState();
}

class _StatisticCardState extends State<StatisticCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 124,
      decoration: BoxDecoration(
        border: Border.fromBorderSide(
          BorderSide(
            color: AppColors.light,
          ),
        ),
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: widget.color,
                  ),
                  child: Icon(
                    widget.icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    widget.title,
                    style: AppTextStyles.cardBody,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              widget.description,
              style: AppTextStyles.cardDesc,
            ),
          ],
        ),
      ),
    );
  }
}
