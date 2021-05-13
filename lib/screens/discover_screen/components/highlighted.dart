import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_images.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/screens/lesson_screen/lesson_screen.dart';
import 'package:flutter/material.dart';

class Highlighted extends StatelessWidget {
  final String title;
  final String label;
  final String content;
  final String quizId;
  const Highlighted({
    Key key,
    @required this.title,
    @required this.label,
    @required this.content,
    @required this.quizId,
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LessonScreen(
                  title: title,
                  content: content,
                  quizId: quizId,
                ),
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
                  child: Image.asset(
                    AppImages.githubLesson,
                    fit: BoxFit.cover,
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
                  label,
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
