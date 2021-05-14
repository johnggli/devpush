import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_images.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:devpush/screens/detail_screen/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Highlighted extends StatelessWidget {
  final String quizId;
  final String label;
  final String imageUrl;
  final String title;
  final String content;
  final String link;
  final ValueChanged<Widget> onTap;
  const Highlighted({
    Key key,
    @required this.quizId,
    @required this.label,
    @required this.imageUrl,
    @required this.title,
    @required this.content,
    @required this.link,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var databaseProvider = Provider.of<DatabaseProvider>(context);

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
      child: StreamBuilder<DocumentSnapshot>(
        stream: databaseProvider.getQuizById(quizId),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                onTap(
                  DetailScreen(
                    quizId: quizId,
                    isQuiz: false,
                    quizData: {
                      "userId": snapshot.data['userId'],
                      "quizImgUrl": snapshot.data['quizImgUrl'],
                      "quizTitle": snapshot.data['quizTitle'],
                      "quizSubject": snapshot.data['quizSubject'],
                      "numberOfQuestions": snapshot.data['numberOfQuestions'],
                    },
                    imageUrl: imageUrl,
                    title: title,
                    content: content,
                    link: link,
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
                      child: FadeInImage(
                        placeholder: AssetImage(AppImages.defaultImage),
                        imageErrorBuilder: (context, url, error) => Image.asset(
                          AppImages.defaultImage,
                          fit: BoxFit.cover,
                        ),
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 16, left: 16, right: 16),
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
          );
        },
      ),
    );
  }
}
