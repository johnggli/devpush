import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpush/components/quiz_card.dart';
import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_gradients.dart';
import 'package:devpush/core/app_images.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LessonScreen extends StatefulWidget {
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
  _LessonScreenState createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  @override
  Widget build(BuildContext context) {
    var databaseProvider = Provider.of<DatabaseProvider>(context);
    var top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              expandedHeight: 232,
              floating: true,
              pinned: true,
              elevation: 1,
              backgroundColor: AppColors.black,
              brightness: Brightness.dark,
              flexibleSpace: LayoutBuilder(builder: (context, constraints) {
                top = constraints.biggest.height;
                // print(top);
                return FlexibleSpaceBar(
                  centerTitle: true,
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        AppImages.defaultImage,
                        fit: BoxFit.cover,
                      ),
                      Opacity(
                        opacity: 0.5,
                        child: Container(
                          // color: AppColors.black,
                          decoration: BoxDecoration(
                            gradient: AppGradients.linearPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                  title: top < 110.14
                      ? Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            widget.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: AppTextStyles.tabTitleWhite,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Text(
                            widget.title,
                            style: AppTextStyles.tabTitleWhite,
                          ),
                        ),
                );
              }),
            )
          ];
        },
        body: ListView(
          padding: EdgeInsets.only(top: 0),
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            Text("titulo: ${widget.title}"),
            Text("conteudo: ${widget.content}"),
            FutureBuilder<DocumentSnapshot>(
              future: databaseProvider.getQuizById(widget.quizId),
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
                    quizId: widget.quizId,
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
      ),
    );
  }
}
