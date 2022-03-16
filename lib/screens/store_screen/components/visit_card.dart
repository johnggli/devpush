import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_images.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

class VisitCard extends StatelessWidget {
  final String visitCardId;
  final String image;
  final int value;
  final ValueChanged<Widget> onTap;
  const VisitCard({
    Key key,
    @required this.visitCardId,
    @required this.image,
    @required this.value,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 136,
      width: 264,
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
            // onTap(
            //   QuizDetailScreen(
            //     quizId: quizId,
            //     quizData: quizData,
            //   ),
            // );
          },
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: FancyShimmerImage(
              shimmerBaseColor: Colors.grey[300],
              shimmerHighlightColor: Colors.grey[100],
              imageUrl: image,
              boxFit: BoxFit.cover,
              errorWidget: Image.asset(
                AppImages.defaultImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
