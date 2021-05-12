import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_images.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/screens/quiz_screen/quiz_screen.dart';
import 'package:flutter/material.dart';

class QuizTile extends StatelessWidget {
  final String imageUrl, title, quizId, description;
  final int numberOfQuestions;
  const QuizTile({
    Key key,
    @required this.imageUrl,
    @required this.title,
    @required this.quizId,
    @required this.description,
    @required this.numberOfQuestions,
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuizScreen(
                  numberOfQuestions: numberOfQuestions,
                  quizId: quizId,
                  quizTitle: title,
                ),
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
                width: 124,
                height: 164,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  child: FadeInImage(
                    placeholder: AssetImage(AppImages.defaultImage),
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.cardTitle,
                      ),
                      Text(
                        'INICIAR',
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

    // GestureDetector(
    //   onTap: () {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => QuizScreen(
    //           numberOfQuestions: numberOfQuestions,
    //           quizId: quizId,
    //           quizTitle: title,
    //         ),
    //       ),
    //     );
    //   },
    //   child: Container(
    //     padding: EdgeInsets.symmetric(horizontal: 24),
    //     height: 150,
    //     child: ClipRRect(
    //       borderRadius: BorderRadius.circular(8),
    //       child: Stack(
    //         children: [
    //           Image.network(
    //             imageUrl.length > 0
    //                 ? imageUrl
    //                 : 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=1000',
    //             fit: BoxFit.cover,
    //             width: MediaQuery.of(context).size.width,
    //           ),
    //           Container(
    //             color: Colors.black26,
    //             child: Center(
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   Text(
    //                     title,
    //                     style: TextStyle(
    //                         fontSize: 18,
    //                         color: Colors.white,
    //                         fontWeight: FontWeight.w500),
    //                   ),
    //                   SizedBox(
    //                     height: 4,
    //                   ),
    //                   Text(
    //                     description,
    //                     style: TextStyle(
    //                         fontSize: 13,
    //                         color: Colors.white,
    //                         fontWeight: FontWeight.w500),
    //                   ),
    //                   SizedBox(
    //                     height: 4,
    //                   ),
    //                   Text(
    //                     'id: $quizId',
    //                     style: TextStyle(
    //                         fontSize: 13,
    //                         color: Colors.white,
    //                         fontWeight: FontWeight.w500),
    //                   ),
    //                   SizedBox(
    //                     height: 4,
    //                   ),
    //                   Text(
    //                     'noOfQuestions: $numberOfQuestions',
    //                     style: TextStyle(
    //                         fontSize: 13,
    //                         color: Colors.white,
    //                         fontWeight: FontWeight.w500),
    //                   )
    //                 ],
    //               ),
    //             ),
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
