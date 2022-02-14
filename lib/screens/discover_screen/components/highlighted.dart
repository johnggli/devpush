import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_images.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/screens/post_detail_screen/post_detail_screen.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

class Highlighted extends StatelessWidget {
  final String label;
  final String imageUrl;
  final String title;
  final String content;
  final String link;
  final String subject;
  final ValueChanged<Widget> onTap;
  const Highlighted({
    Key key,
    @required this.label,
    @required this.imageUrl,
    @required this.title,
    @required this.content,
    @required this.link,
    @required this.subject,
    @required this.onTap,
  }) : super(key: key);

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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            onTap(
              PostDetailScreen(
                imageUrl: imageUrl,
                title: title,
                content: content,
                link: link,
                subject: subject,
              ),
            );
          },
          customBorder: RoundedRectangleBorder(
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
                    imageUrl: imageUrl,
                    boxFit: BoxFit.cover,
                    errorWidget: Image.asset(
                      AppImages.defaultImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                child: Text(
                  title,
                  style: AppTextStyles.cardTitle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "$label",
                  style: AppTextStyles.blueText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
