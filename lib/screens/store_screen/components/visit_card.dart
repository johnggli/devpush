import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

class VisitCard extends StatefulWidget {
  @override
  _VisitCardState createState() => _VisitCardState();
}

class _VisitCardState extends State<VisitCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 236,
      decoration: BoxDecoration(
        border: Border.fromBorderSide(
          BorderSide(
            color: AppColors.light,
          ),
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: double.maxFinite,
            height: 136,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: FancyShimmerImage(
                shimmerBaseColor: Colors.grey[300],
                shimmerHighlightColor: Colors.grey[100],
                imageUrl: 'https://i.imgur.com/iD8QDiz.jpg',
                boxFit: BoxFit.cover,
                errorWidget: Container(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 24,
                      width: 24,
                      child: CircleAvatar(
                        backgroundColor: Colors.yellow[500],
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.yellow[700],
                          ),
                          child: Icon(
                            Icons.code,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      '82',
                      style: AppTextStyles.cardTitle,
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'COMPRAR',
                    style: AppTextStyles.blueText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
