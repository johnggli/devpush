import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:devpush/screens/create_quiz_screen/create_quiz_screen.dart';
import 'package:devpush/components/quiz_card.dart';
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
  int _indexTab = 0;

  void onSelected(Widget detail) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => detail),
    );
  }

  @override
  Widget build(BuildContext context) {
    var databaseProvider =
        Provider.of<DatabaseProvider>(context, listen: false);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
          bottom: TabBar(
            onTap: (index) {
              setState(() {
                _indexTab = index;
              });
            },
            tabs: [
              Tab(
                child: Text(
                  'Fixos',
                  style: AppTextStyles.subHead,
                ),
              ),
              Tab(
                child: Text(
                  'Criados',
                  style: AppTextStyles.subHead,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: databaseProvider.getAllQuizzes(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                return ListView(
                  physics: ClampingScrollPhysics(),
                  children: [
                    SizedBox(
                      height: 24,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Column(
                        children:
                            snapshot.data.docs.map((DocumentSnapshot document) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Container(
                              width: double.maxFinite,
                              child: QuizCard(
                                quizId: document.id,
                                quizData: {
                                  "userId": document.data()['userId'],
                                  "quizImgUrl": document.data()['quizImgUrl'],
                                  "quizTitle": document.data()['quizTitle'],
                                  "quizDesc": document.data()['quizDesc'],
                                  "quizSubject": document.data()['quizSubject'],
                                  "numberOfQuestions":
                                      document.data()['numberOfQuestions'],
                                  "totalRatings":
                                      document.data()['totalRatings'],
                                  "ratingSum": document.data()['ratingSum']
                                },
                                onTap: (value) {
                                  onSelected(value);
                                },
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 48,
                    ),
                  ],
                );
              },
            ),
            Icon(Icons.directions_car),
          ],
        ),
        floatingActionButton: _indexTab == 0
            ? null
            : FloatingActionButton.extended(
                backgroundColor: AppColors.blue,
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                label: Text(
                  'Criar Quiz',
                  style: AppTextStyles.buttonText,
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
      ),
    );
  }
}
