import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/screens/create_quiz_screen/create_quiz_screen.dart';
import 'package:flutter/material.dart';

class QuizListScreen extends StatefulWidget {
  @override
  _QuizListScreenState createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Quizzes',
          style: AppTextStyles.tabTitle,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: [
            // Aki vão os quizzes
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateQuizScreen(),
            ),
          );
        },
      ),
    );
  }
}
