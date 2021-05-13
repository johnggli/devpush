import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpush/components/quiz_card.dart';
import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LessonScreen extends StatelessWidget {
  final String title;
  final String content;
  final String quizId;
  const LessonScreen({
    Key key,
    @required this.title,
    @required this.content,
    @required this.quizId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var databaseProvider = Provider.of<DatabaseProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColors.lightGray,
        ),
        centerTitle: true,
        title: Text(
          'Lição',
          style: AppTextStyles.tabTitle,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView(
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          SizedBox(height: 18),
          // TextButton(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => TestScreen(
          //           questions: _questions,
          //         ),
          //       ),
          //     );
          //   },
          //   child: Text('github exam'),
          // ),
          Text("titulo: $title"),
          Text("conteudo: $content"),
          FutureBuilder<DocumentSnapshot>(
            future: databaseProvider.getQuizById(quizId),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }

              if (snapshot.hasData && !snapshot.data.exists) {
                return Text("Document does not exist");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data = snapshot.data.data();
                return QuizCard(
                  quizId: quizId,
                  quizData: {
                    "userId": data['userId'],
                    "quizImgUrl": data['quizImgUrl'],
                    "quizTitle": data['quizTitle'],
                    "quizSubject": data['quizSubject'],
                    "numberOfQuestions": data['numberOfQuestions'],
                  },
                );
              }

              return Text("loading");
            },
          ),
        ],
      ),
    );
  }
}
