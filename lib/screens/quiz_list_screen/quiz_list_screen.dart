import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:devpush/screens/create_quiz_screen/create_quiz_screen.dart';
import 'package:devpush/components/quiz_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuizListScreen extends StatefulWidget {
  const QuizListScreen({
    Key key,
  }) : super(key: key);

  @override
  _QuizListScreenState createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
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
          'Quizzes',
          style: AppTextStyles.tabTitle,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: databaseProvider.getAllQuizzes(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return Padding(
            padding: const EdgeInsets.only(
              top: 24,
              left: 18,
              right: 18,
              bottom: 12,
            ),
            child: ListView(
              physics: ClampingScrollPhysics(),
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: QuizTile(
                    title: document.data()['quizTitle'],
                    imageUrl: document.data()['quizImgUrl'],
                    description: document.data()['quizDesc'],
                    quizId: document.id,
                    numberOfQuestions: document.data()['numberOfQuestions'],
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.blue,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
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
