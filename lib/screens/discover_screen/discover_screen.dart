import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpush/components/quiz_card.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:devpush/screens/discover_screen/components/highlighted.dart';
import 'package:devpush/screens/quiz_list_screen/quiz_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({
    Key key,
  }) : super(key: key);

  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  void onSelected(Widget detail) {
    Future.delayed(Duration(milliseconds: 200)).then(
      (_) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => detail),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var databaseProvider = Provider.of<DatabaseProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Descobrir',
          style: AppTextStyles.tabTitle,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView(
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              'Em destaque',
              style: AppTextStyles.section,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: StreamBuilder<QuerySnapshot>(
              stream: databaseProvider.getHighlighted(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                return Column(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return Container(
                      width: double.maxFinite,
                      child: Highlighted(
                        quizId: document.data()['quizId'],
                        label: document.data()['label'],
                        imageUrl: document.data()['imageUrl'],
                        title: document.data()['title'],
                        content: document.data()['content'],
                        link: document.data()['link'],
                        onTap: (value) {
                          onSelected(value);
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quizzes',
                  style: AppTextStyles.section,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizListScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Ver todos',
                    style: AppTextStyles.blueText,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 136,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: ClampingScrollPhysics(),
              children: [
                SizedBox(
                  width: 18,
                ),
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

                    return Row(
                      // scrollDirection: Axis.horizontal,
                      // physics: ClampingScrollPhysics(),
                      children: snapshot.data.docs
                          .map((DocumentSnapshot document) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 16),
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
                                },
                                onTap: (value) {
                                  onSelected(value);
                                },
                              ),
                            );
                          })
                          .take(5)
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 18,
          ),
        ],
      ),
    );
  }
}
