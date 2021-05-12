import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpush/components/quiz_tile.dart';
import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_images.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:devpush/screens/lesson_screen/lesson_screen.dart';
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
              'Recomendado',
              style: AppTextStyles.section,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(
              height: 164,
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
                        builder: (context) => LessonScreen(),
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
                          child: Image.asset(
                            AppImages.githubLesson,
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
                                'Introdução ao Git e Github',
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
                      children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: QuizTile(
                            title: document.data()['quizTitle'],
                            imageUrl: document.data()['quizImgUrl'],
                            description: document.data()['quizDesc'],
                            quizId: document.id,
                            numberOfQuestions:
                                document.data()['numberOfQuestions'],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
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
                      children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: QuizTile(
                            title: document.data()['quizTitle'],
                            imageUrl: document.data()['quizImgUrl'],
                            description: document.data()['quizDesc'],
                            quizId: document.id,
                            numberOfQuestions:
                                document.data()['numberOfQuestions'],
                          ),
                        );
                      }).toList(),
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
