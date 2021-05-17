import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

class RankTile extends StatelessWidget {
  final String imageUrl;
  final String name;
  final int devPoints;
  const RankTile({
    Key key,
    @required this.imageUrl,
    @required this.name,
    @required this.devPoints,
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
              Text(
                name,
                style: AppTextStyles.blackText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
        ],
      ),
    );
  }
}
