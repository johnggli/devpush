import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpush/core/app_colors.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:devpush/screens/quiz_screen/components/question_indicator.dart';
import 'package:devpush/screens/quiz_screen/components/quiz_widget.dart';
import 'package:devpush/screens/result_screen/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuizScreen extends StatefulWidget {
  final String quizId;
  final Map<String, dynamic> quizData;
  final bool haveReward;
  QuizScreen({
    Key key,
    @required this.quizId,
    @required this.quizData,
    @required this.haveReward,
  }) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final pageController = PageController();

  @override
  void initState() {
    pageController.addListener(() {
      Provider.of<DatabaseProvider>(context, listen: false)
          .setCurrentPage(pageController.page.toInt() + 1);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var databaseProvider =
        Provider.of<DatabaseProvider>(context, listen: false);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: SafeArea(
          top: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: BackButton(
                  color: AppColors.lightGray,
                ),
              ),
              QuestionIndicator(
                length: widget.quizData['numberOfQuestions'],
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: databaseProvider.getQuestions(widget.quizId),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: pageController,
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              return ListView(
                // physics: BouncingScrollPhysics(),
                children: [
                  QuizWidget(
                    question: document.data()['question'],
                    options: [
                      document.data()['option1'],
                      document.data()['option2'],
                      document.data()['option3'],
                      document.data()['option4'],
                    ]..shuffle(),
                    correctOption: document.data()['option1'],
                    onSelected: (value) {
                      if (value) {
                        databaseProvider.incrementQtdAnswerRight();
                      }
                      if (databaseProvider.currentPage ==
                          widget.quizData['numberOfQuestions']) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultScreen(
                              quizId: widget.quizId,
                              quizData: widget.quizData,
                              result: databaseProvider.qtdAnswerRight,
                              haveReward: widget.haveReward,
                            ),
                          ),
                        );
                      } else {
                        if (databaseProvider.currentPage <
                            widget.quizData['numberOfQuestions'])
                          pageController.nextPage(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.linear,
                          );
                      }
                    },
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
