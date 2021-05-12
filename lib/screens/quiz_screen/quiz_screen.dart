import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:devpush/screens/quiz_screen/components/question_indicator.dart';
import 'package:devpush/screens/quiz_screen/components/quiz_widget.dart';
import 'package:devpush/controllers/quiz_controller.dart';
import 'package:devpush/screens/result_screen/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuizScreen extends StatefulWidget {
  final int numberOfQuestions;
  final String quizId;
  final String quizTitle;
  QuizScreen({
    Key key,
    @required this.numberOfQuestions,
    @required this.quizId,
    @required this.quizTitle,
  }) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final controller = QuizController();
  final pageController = PageController();

  @override
  void initState() {
    pageController.addListener(() {
      controller.currentPage = pageController.page.toInt() + 1;
    });
    super.initState();
  }

  void nextPage() {
    if (controller.currentPage < widget.numberOfQuestions)
      pageController.nextPage(
        duration: Duration(milliseconds: 100),
        curve: Curves.linear,
      );
  }

  void onSelected(bool value) {
    if (value) {
      controller.qtdAnswerRight++;
    }
    if (controller.currentPage == widget.numberOfQuestions) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            result: controller.qtdAnswerRight,
            title: widget.quizTitle,
            length: widget.numberOfQuestions,
          ),
        ),
      );
    } else {
      nextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    var databaseProvider = Provider.of<DatabaseProvider>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(86),
        child: SafeArea(
          top: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BackButton(),
              ValueListenableBuilder<int>(
                valueListenable: controller.currentPageNotifier,
                builder: (context, value, _) => QuestionIndicator(
                  currentPage: value,
                  length: widget.numberOfQuestions,
                ),
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
              return QuizWidget(
                question: document.data()['question'],
                options: [
                  document.data()['option1'],
                  document.data()['option2'],
                  document.data()['option3'],
                  document.data()['option4'],
                ]..shuffle(),
                correctOption: document.data()['option1'],
                onSelected: onSelected,
              );
            }).toList(),
          );
        },
      ),

      // PageView(
      //   physics: NeverScrollableScrollPhysics(),
      //   controller: pageController,
      //   children: widget.questions
      //       .map((e) => QuizWidget(
      //             question: e,
      //             onSelected: onSelected,
      //           ))
      //       .toList(),
      // ),

      // bottomNavigationBar: SafeArea(
      //   bottom: true,
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 20),
      //     child: ValueListenableBuilder<int>(
      //       valueListenable: controller.currentPageNotifier,
      //       builder: (context, value, _) => Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceAround,
      //         children: [
      //           if (value < widget.questions.length)
      //             Expanded(
      //               child: NextButtonWidget.white(
      //                 label: 'Pular',
      //                 onTap: () {
      //                   nextPage();
      //                 },
      //               ),
      //             ),
      //           if (value == widget.questions.length)
      //             Expanded(
      //               child: NextButtonWidget.green(
      //                 label: 'Confirmar',
      //                 onTap: () {
      //                   Navigator.pushReplacement(
      //                     context,
      //                     MaterialPageRoute(
      //                       builder: (context) => ResultPage(
      //                         result: controller.qtdAnswerRight,
      //                         title: widget.title,
      //                         length: widget.questions.length,
      //                       ),
      //                     ),
      //                   );
      //                 },
      //               ),
      //             ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
