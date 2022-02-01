import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_images.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/screens/detail_screen/detail_screen.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizCard extends StatelessWidget {
  final String quizId;
  final Map<String, dynamic> quizData;
  final ValueChanged<Widget> onTap;
  const QuizCard({
    Key key,
    @required this.quizId,
    @required this.quizData,
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
            onTap(
              DetailScreen(
                quizId: quizId,
                quizData: quizData,
              ),
            );
          },
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 112,
                height: 164,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  child: FancyShimmerImage(
                    shimmerBaseColor: Colors.grey[300],
                    shimmerHighlightColor: Colors.grey[100],
                    imageUrl: quizData['quizImgUrl'],
                    boxFit: BoxFit.cover,
                    errorWidget: Image.asset(
                      AppImages.defaultImage,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // FadeInImage(
                  //   placeholder: AssetImage(AppImages.defaultImage),
                  //   imageErrorBuilder: (context, url, error) => Image.asset(
                  //     AppImages.defaultImage,
                  //     fit: BoxFit.cover,
                  //   ),
                  //   image: NetworkImage(quizData['quizImgUrl']),
                  //   fit: BoxFit.cover,
                  // ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${quizData['numberOfQuestions']} Questões',
                            style: AppTextStyles.description12,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.star,
                                size: 14,
                                color: AppColors.yellow,
                              ),
                              Text(
                                '${double.parse((quizData['ratingSum'] / quizData['totalRatings']).toStringAsFixed(1))}',
                                style: AppTextStyles.description12,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Flexible(
                        child: Text(
                          quizData['quizTitle'],
                          style: GoogleFonts.nunito(
                            color: AppColors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            height: 1,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Text(
                        quizData['quizSubject'],
                        style: AppTextStyles.blueText,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
