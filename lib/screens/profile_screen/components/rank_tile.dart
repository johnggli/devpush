import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_images.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

class RankTile extends StatelessWidget {
  final String imageUrl;
  final String name;
  final int devPoints;
  final int position;
  const RankTile({
    Key key,
    @required this.imageUrl,
    @required this.name,
    @required this.devPoints,
    @required this.position,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      child: Row(
        children: [
          Column(
            children: [
              ClipOval(
                child: Container(
                  height: 48,
                  width: 48,
                  child: FancyShimmerImage(
                    shimmerBaseColor: Colors.grey[300],
                    shimmerHighlightColor: Colors.grey[100],
                    imageUrl: imageUrl,
                    boxFit: BoxFit.cover,
                    errorWidget: Image.asset(
                      AppImages.defaultImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  name,
                  style: AppTextStyles.blackText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.bolt,
                    color: AppColors.blue,
                    size: 20,
                  ),
                  Text(
                    '$devPoints',
                    style: AppTextStyles.grayText,
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (position == 1)
                  Icon(
                    Icons.emoji_events,
                    color: Colors.yellow[700],
                  ),
                if (position == 2)
                  Icon(
                    Icons.emoji_events,
                    color: Color(0xFFC0C0C0),
                  ),
                if (position == 3)
                  Icon(
                    Icons.emoji_events,
                    color: Color(0xFFCD7F32),
                  ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  '$positionº',
                  style: AppTextStyles.blackText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
